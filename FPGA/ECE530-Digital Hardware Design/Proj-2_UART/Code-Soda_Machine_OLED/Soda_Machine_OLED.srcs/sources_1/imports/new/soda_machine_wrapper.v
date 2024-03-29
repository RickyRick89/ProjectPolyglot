`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/20/2023 02:19:44 PM
// Design Name: Soda Vending Machine System
// Module Name: soda_machine_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module serves as the wrapper for the soda vending machine, integrating 
// 				button press detection, finite state machine for operational logic, and 
// 				display handling for an OLED interface.
// Dependencies:freq_div.v
// 				edge_det_and_synch.v
// 				soda_machine_top.v
// 				Binary_to_BCD.v
// 				oled_driver.sv
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////



module soda_machine_wrapper(ja,led,btn,clk,RxD);

    /*--------- I/O Declarations --------------------------*/
    output [7:0] ja;         // Output for the OLED interface
    output [3:0] led;        // 4-bit LED outputs
    input [1:0] btn;          // 4-bit push button inputs
    input clk;               // Main system clock
    (* mark_debug = "true" *) input RxD;

    /*--------- Parameterized States for the FSM ---------*/
    parameter   st_init    		= 4'd1,
                st_get_chars    = 4'd2,
                st_disp_chars	= 4'd3,
				st_wait			= 4'd4;

    /*--------- Internal Registers and Variables ---------*/
    (* mark_debug = "true" *) reg [3:0] state, next_state;   // Current and next state registers for the FSM
    reg [7:0] price;               // Price set by the user
    reg [7:0] price_acptd;         // Accepted price
    reg [24:0] wait_cycles;        // Count for the number of cycles to wait
    reg [24:0] wait_count;         // Counter for wait cycles
    reg characters_valid;          // Flag to indicate if characters are valid
    reg [(12 * 8) - 1:0] characters_r1;
    reg [(12 * 8) - 1:0] characters_r1_buf;
    reg [(12 * 8) - 1:0] prev_characters_r1;
    reg [(12 * 8) - 1:0] characters_r2;
    reg [(12 * 8) - 1:0] characters_r2_buf;
    reg [(12 * 8) - 1:0] prev_characters_r2;
    reg [(12 * 8) - 1:0] characters_r3;
    reg [(12 * 8) - 1:0] characters_r3_buf;
    reg [(12 * 8) - 1:0] prev_characters_r3;
    reg [4:0] bg_r;
    reg [5:0] bg_g;
    reg [4:0] bg_b;
    reg [4:0] txt_r;
    reg [5:0] txt_g;
    reg [4:0] txt_b;
	reg [7:0] chng;
	reg RxFIFO_rd;
	(* mark_debug = "true" *) reg [3:0] line_num;
	(* mark_debug = "true" *) reg [7:0] char_num;

    /*--------- Internal Wires and Interconnections ---------*/
    wire w_n_rst;                  // Not reset derived from push button 0
    wire w_d;                      // Derived signal, possibly indicating drink selection
    wire [7:0] w_tot;              // Total amount
    wire [7:0] w_a;                // Coin denomination based on switch input
    wire w_oled_init_done;         // OLED initialization completion signal
    wire w_oled_char_done;         // OLED character display completion signal
    wire [9:0] w_price_bcd;        // BCD representation of price
    wire [9:0] w_tot_bcd;          // BCD representation of total amount
    wire [9:0] w_a_bcd;            // BCD representation of coin denomination
    wire [9:0] w_change_bcd;
	wire [7:0] w_chng;
	wire [7:0] w_config_reg;
	(* mark_debug = "true" *) wire [9:0] w_RxFIFO_Dout;
	wire w_RxFIFO_full;
	wire w_RxFIFO_empty;
	wire w_clk_50mhz;


   /*--------- Instantiations ---------*/
    clk_wiz_0 clk0 (.clk_out1(w_clk_50mhz),.resetn(w_n_rst),.clk_in1(clk));
	UART_top uart1 (.RxFIFO_Dout(w_RxFIFO_Dout),.RxFIFO_full(w_RxFIFO_full),.RxFIFO_empty(w_RxFIFO_empty),.clk_50mhz(w_clk_50mhz),.RxD(RxD),.RxFIFO_rd(RxFIFO_rd),.config_reg(w_config_reg),.clk(clk),.n_rst(w_n_rst));
    
    oled_driver #(
    .CLOCK_FREQUENCY (12000000) // Must be slower than 12 MHz.
    ) oled (
    
    // System Signals:
    .clock     (clk),
    .reset_n   (w_n_rst),
    
    // SPI:
    .cs  (ja[0]), // PMOD Pin 1.
    .mosi(ja[1]), // PMOD Pin 2.
    .sck (ja[3]), // PMOD Pin 4.
    
    // OLED Signals:
    .dc       (ja[4]), // PMOD Pin 7.
    .res      (ja[5]), // PMOD Pin 8.
    .vccen    (ja[6]), // PMOD Pin 9.
    .pmoden   (ja[7]), // PMOD Pin 10.
    
    // Done Signals:
    .init_done      (w_oled_init_done),
    .characters_done(w_oled_char_done),
	
	.BACKGROUND_COLOR_RED   (bg_r),
	.BACKGROUND_COLOR_GREEN (bg_g),
	.BACKGROUND_COLOR_BLUE  (bg_b),
	.TEXT_COLOR_RED         (txt_r),
	.TEXT_COLOR_GREEN       (txt_g),
	.TEXT_COLOR_BLUE        (txt_b),
    
    .characters_r1      (characters_r1),
    .characters_r2      (characters_r2),
    .characters_r3      (characters_r3),
    .characters_valid   (characters_valid)
    
    );
	
	
    /*--------- Assignments --------------------------*/
    assign w_n_rst = ~btn[0];
	assign led[0] = w_oled_init_done;
	assign led[1] = w_oled_char_done;
    assign w_config_reg = {2'b00,2'b00,1'b0,1'b1,2'b00};
									  
	/*--------- State Transisition Block --------------------------*/
	always @ (negedge w_clk_50mhz, negedge w_n_rst)
	begin
		// Check if reset is active (low)
		if (w_n_rst == 1'b0)
		begin
			state <= st_init;	// If reset is active, initialize the state to 'st_init'
		end
		else
			state <= next_state; // On every clock edge, transition to the next determined state
	end
	
 
	/*--------- Character Validation Block --------------------------*/
	always @ (posedge clk, negedge w_n_rst)
	begin
		// Check if reset is active (low)
		if (w_n_rst == 1'b0)
		begin
			characters_valid <= 1'b0;	// If reset is active, set 'characters_valid' to 0
			prev_characters_r1 <= 0;
			prev_characters_r2 <= 0;
			prev_characters_r3 <= 0;
		end
		else
		begin
			// Check if OLED initialization is complete
			if (w_oled_init_done)
			begin
				// If the characters have changed and the previous characters have been displayed on OLED
				if (((characters_r1 != prev_characters_r1)|(characters_r2 != prev_characters_r2)|(characters_r3 != prev_characters_r3)) & w_oled_char_done)
				begin
					characters_valid <= 1'b1; // Validate the characters
					prev_characters_r1 <= characters_r1; // Update the 'prev_characters' with the current 'characters'
					prev_characters_r2 <= characters_r2; // Update the 'prev_characters' with the current 'characters'
					prev_characters_r3 <= characters_r3; // Update the 'prev_characters' with the current 'characters'
				end
				// If 'characters_valid' is already set and conditions don't meet
				else if (characters_valid && w_oled_char_done)
					characters_valid <= 1'b0; // Invalidate the characters
			end
		end
	end

			
	/*--------- State Machine Block for Display Logic --------------------------*/
	always @ (posedge w_clk_50mhz, negedge w_n_rst)
	begin
		// Check if reset is active (low)
		if (w_n_rst == 1'b0)
		begin
			next_state <= st_init;  // Initialize state on reset
			characters_r1 <= 0;
			characters_r2 <= 0;
			characters_r3 <= 0;
		end
		else
		begin
			// State Machine Logic
			case (state)
				st_init:
				begin
                    bg_r <= 5'd0;
                    bg_g <= 6'd0;
                    bg_b <= 5'd0;
                    txt_r <= 5'd31;
                    txt_g <= 6'd63;
                    txt_b <= 5'd31;
					
					line_num <= 0;
					char_num <= 0;
					
					if (!w_RxFIFO_empty)
					begin
						RxFIFO_rd <= 1;
						next_state <= st_get_chars;
					end
				end

				st_get_chars:
				begin
					RxFIFO_rd <= 0;
					if (!RxFIFO_rd)
					begin
						if (w_RxFIFO_Dout[7:0] == 8'd4) //End of Transmission
						begin
							line_num <= 0;
							char_num <= 0;
							next_state <= st_disp_chars;
						end
						else if (w_RxFIFO_Dout[7:0] == 8'd3) //End of Text
						begin
							line_num <= line_num + 1;
							char_num <= 0;
							next_state <= st_wait;
						end
						else
						begin
							case (line_num)
								0:
								begin
									characters_r1_buf[char_num] <= w_RxFIFO_Dout[0];
									characters_r1_buf[char_num+1] <= w_RxFIFO_Dout[1];
									characters_r1_buf[char_num+2] <= w_RxFIFO_Dout[2];
									characters_r1_buf[char_num+3] <= w_RxFIFO_Dout[3];
									characters_r1_buf[char_num+4] <= w_RxFIFO_Dout[4];
									characters_r1_buf[char_num+5] <= w_RxFIFO_Dout[5];
									characters_r1_buf[char_num+6] <= w_RxFIFO_Dout[6];
									characters_r1_buf[char_num+7] <= w_RxFIFO_Dout[7];
								end
								1:
								begin
									characters_r2_buf[char_num] <= w_RxFIFO_Dout[0];
									characters_r2_buf[char_num+1] <= w_RxFIFO_Dout[1];
									characters_r2_buf[char_num+2] <= w_RxFIFO_Dout[2];
									characters_r2_buf[char_num+3] <= w_RxFIFO_Dout[3];
									characters_r2_buf[char_num+4] <= w_RxFIFO_Dout[4];
									characters_r2_buf[char_num+5] <= w_RxFIFO_Dout[5];
									characters_r2_buf[char_num+6] <= w_RxFIFO_Dout[6];
									characters_r2_buf[char_num+7] <= w_RxFIFO_Dout[7];
								end
								2:
								begin
									characters_r3_buf[char_num] <= w_RxFIFO_Dout[0];
									characters_r3_buf[char_num+1] <= w_RxFIFO_Dout[1];
									characters_r3_buf[char_num+2] <= w_RxFIFO_Dout[2];
									characters_r3_buf[char_num+3] <= w_RxFIFO_Dout[3];
									characters_r3_buf[char_num+4] <= w_RxFIFO_Dout[4];
									characters_r3_buf[char_num+5] <= w_RxFIFO_Dout[5];
									characters_r3_buf[char_num+6] <= w_RxFIFO_Dout[6];
									characters_r3_buf[char_num+7] <= w_RxFIFO_Dout[7];
								end
							endcase
							char_num = char_num + 8;
							next_state <= st_wait;
						end
					end
					
				end
				
				st_disp_chars:
				begin
					characters_r1 <= characters_r1_buf;
					characters_r2 <= characters_r2_buf;
					characters_r3 <= characters_r3_buf;
					next_state <= st_init;
				end
				
				st_wait:
				begin
					if (!w_RxFIFO_empty)
					begin
						RxFIFO_rd <= 1;
						next_state <= st_get_chars;
					end
					
				end

			endcase
		end
	end
				


endmodule
