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



module soda_machine_wrapper(ja,led,pb,sw,clk);

    /*--------- I/O Declarations --------------------------*/
    output [7:0] ja;         // Output for the OLED interface
    output [3:0] led;        // 4-bit LED outputs
    input [3:0] pb;          // 4-bit push button inputs
    input [3:0] sw;          // 4-bit switch inputs
    input clk;               // Main system clock

    /*--------- Parameterized States for the FSM ---------*/
    parameter   st_init    = 4'd1,
                st_cost    = 4'd2,
                st_tot     = 4'd3,
                st_coin    = 4'd4,
                st_disp    = 4'd5,
                st_wait    = 4'd6;

    /*--------- Internal Registers and Variables ---------*/
    reg [3:0] state, next_state;   // Current and next state registers for the FSM
    reg [7:0] price;               // Price set by the user
    reg [7:0] price_acptd;         // Accepted price
    reg [24:0] wait_cycles;        // Count for the number of cycles to wait
    reg [24:0] wait_count;         // Counter for wait cycles
    reg characters_valid;          // Flag to indicate if characters are valid
    reg [(12 * 8) - 1:0] characters_r1;
    reg [(12 * 8) - 1:0] prev_characters_r1;
    reg [(12 * 8) - 1:0] characters_r2;
    reg [(12 * 8) - 1:0] prev_characters_r2;
    reg [(12 * 8) - 1:0] characters_r3;
    reg [(12 * 8) - 1:0] prev_characters_r3;
    reg [4:0] bg_r;
    reg [5:0] bg_g;
    reg [4:0] bg_b;
    reg [4:0] txt_r;
    reg [5:0] txt_g;
    reg [4:0] txt_b;
	reg [7:0] chng;

    /*--------- Internal Wires and Interconnections ---------*/
    wire w_pb1_rise;               // Rising edge detected on push button 1
    wire w_pb1_fall;               // Falling edge detected on push button 1
    wire w_pb2_rise;               // Rising edge detected on push button 2
    wire w_pb2_fall;               // Falling edge detected on push button 2
    wire w_pb3_rise;               // Rising edge detected on push button 3
    wire w_pb3_fall;               // Falling edge detected on push button 3
    wire w_n_rst;                  // Not reset derived from push button 0
    wire w_clock_10khz_out;        // 10kHz derived clock
    wire w_clock_10mhz_out;        // 10.417MHz derived clock
    wire w_d;                      // Derived signal, possibly indicating drink selection
    wire [7:0] w_tot;              // Total amount
    wire [7:0] w_a;                // Coin denomination based on switch input
    wire w_oled_init_done;           // OLED initialization completion signal
    wire w_oled_char_done;           // OLED character display completion signal
    wire [9:0] w_price_bcd;     // BCD representation of price
    wire [9:0] w_tot_bcd;       // BCD representation of total amount
    wire [9:0] w_a_bcd;         // BCD representation of coin denomination
    wire [9:0] w_change_bcd;         
	wire [7:0] w_chng;


   /*--------- Instantiations ---------*/
	freq_div #(14,12500) freq_div_10khz (.clkout(w_clock_10khz_out), .clkin(clk), .n_rst(1'b1)); // Frequency divider for 10kHz clock generation
	freq_div #(5,12) freq_div_10mhz (.clkout(w_clock_10mhz_out), .clkin(clk), .n_rst(1'b1)); // Frequency divider for 10MHz clock generation

	edge_det_and_synch pb1_edge_to_pulse (.Rise(w_pb1_rise), .Fall(w_pb1_fall), .Clock_in(w_clock_10khz_out), .n_rst(w_n_rst), .Sig(pb[1])); // Edge detector for push button 1
	edge_det_and_synch pb2_edge_to_pulse (.Rise(w_pb2_rise), .Fall(w_pb2_fall), .Clock_in(w_clock_10khz_out), .n_rst(w_n_rst), .Sig(pb[2])); // Edge detector for push button 2
	edge_det_and_synch pb3_edge_to_pulse (.Rise(w_pb3_rise), .Fall(w_pb3_fall), .Clock_in(w_clock_10khz_out), .n_rst(w_n_rst), .Sig(pb[3])); // Edge detector for push button 3

	soda_machine_top sm (.d(w_d),.tot(w_tot),.chng(w_chng),.s(price_acptd),.a(w_a),.c(w_pb2_rise),.clkin(w_clock_10khz_out),.n_rst(w_n_rst)); // Top level module for the soda machine

	Binary_to_BCD bin2bcd_price (.bcd(w_price_bcd),.bin(price)); // Binary to BCD conversion for price
	Binary_to_BCD bin2bcd_tot (.bcd(w_tot_bcd),.bin(w_tot));     // Binary to BCD conversion for total amount
	Binary_to_BCD bin2bcd_coin (.bcd(w_a_bcd),.bin(w_a));        // Binary to BCD conversion for coin input
	Binary_to_BCD bin2bcd_change (.bcd(w_change_bcd),.bin(chng));        


	
    oled_driver #(
    .CLOCK_FREQUENCY (10416667) // Must be slower than 12 MHz.
    ) oled (
    
    // System Signals:
    .clock     (w_clock_10mhz_out),
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
    assign w_n_rst = ~pb[0];
	assign w_a = 	(sw[0] == 1'b1) ? 8'd5:
					(sw[1] == 1'b1) ? 8'd10:
					(sw[2] == 1'b1) ? 8'd25:
									  8'd0;
									  
	/*--------- State Transisition Block --------------------------*/
	always @ (posedge w_clock_10khz_out, negedge w_n_rst)
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
	always @ (posedge w_clock_10khz_out, negedge w_n_rst)
	begin
		// Check if reset is active (low)
		if (w_n_rst == 1'b0)
		begin
			characters_valid <= 1'b0;	// If reset is active, set 'characters_valid' to 0
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
				else if (characters_valid)
					characters_valid <= 1'b0; // Invalidate the characters
			end
		end
	end

			
	/*--------- State Machine Block for Display Logic --------------------------*/
	always @ (posedge w_clock_10khz_out, negedge w_n_rst)
	begin
		// Check if reset is active (low)
		if (w_n_rst == 1'b0)
		begin
			next_state <= st_init;  // Initialize state on reset
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
					chng <= 8'd0;
					wait_cycles <= 25'd10000;     // Initialization of cycles to wait
					wait_count <= 25'd0;          // Initialization of counter
					if (sw[3])                     // Check switch 3
						next_state <= st_cost;    // Transition to cost state
					else
						next_state <= st_tot;    // Transition to total state
				end

				st_cost:
				begin
                    bg_r <= 5'd0;
                    bg_g <= 6'd0;
                    bg_b <= 5'd0;
                    txt_r <= 5'd31;
                    txt_g <= 6'd63;
                    txt_b <= 5'd31;
					// Display cost using BCD conversion
					characters_r1 <= {"COST:  $", ("0" + w_price_bcd[9:8]), ".",("0" + w_price_bcd[7:4]),("0" + w_price_bcd[3:0])};
					characters_r2 <= {"SWITCHES:",("0" + w_a_bcd[7:4]),("0" + w_a_bcd[3:0]),"C"};
					characters_r3 <= "            ";
					if (~sw[3])                    // Check switch 3 for transition
						next_state <= st_tot;    // Transition to total state
				end

				st_tot:
				begin
                    bg_r <= 5'd0;
                    bg_g <= 6'd0;
                    bg_b <= 5'd0;
                    txt_r <= 5'd31;
                    txt_g <= 6'd63;
                    txt_b <= 5'd31;
					// Display total using BCD conversion
					characters_r1 <= {"COST:  $", ("0" + w_price_bcd[9:8]), ".",("0" + w_price_bcd[7:4]),("0" + w_price_bcd[3:0])};
					characters_r2 <= {"TOT:   $", ("0" + w_tot_bcd[9:8]), ".",("0" + w_tot_bcd[7:4]),("0" + w_tot_bcd[3:0])};
					characters_r3 <= {"SWITCHES:",("0" + w_a_bcd[7:4]),("0" + w_a_bcd[3:0]),"C"};
					if (sw[3])                      // Check switch 3 for transition
						next_state <= st_cost;    // Transition to cost state
					if (w_pb2_rise)                  // Check for rising edge on push button 2
						next_state <= st_coin;    // Transition to coin state
				end

				st_coin:
				begin
                    bg_r <= 5'd31;
                    bg_g <= 6'd31;
                    bg_b <= 5'd0;
                    txt_r <= 5'd0;
                    txt_g <= 6'd0;
                    txt_b <= 5'd0;
					// Display coin value using BCD conversion
					characters_r1 <= " COIN ADDED ";
					characters_r2 <= {"    ",("0" + w_a_bcd[7:4]),("0" + w_a_bcd[3:0]),"C     "};
					characters_r3 <= "            ";
					if (w_d)                        // Check dispense condition
					begin
						next_state <= st_disp;    // Transition to dispense state
						chng <= w_chng;
					end
					else
						next_state <= st_wait;   // Otherwise, transition to wait state
				end

				st_disp:
				begin
                    bg_r <= 5'd0;
                    bg_g <= 6'd63;
                    bg_b <= 5'd0;
                    txt_r <= 5'd0;
                    txt_g <= 6'd0;
                    txt_b <= 5'd0;
					characters_r1 <= "*DISPENSED* ";     // Display dispensed message
					characters_r2 <= {"CHANGE:  ",("0" + w_change_bcd[7:4]),("0" + w_change_bcd[3:0]), "C"};
					characters_r3 <= "            ";
					next_state <= st_wait;           // Transition to wait state
				end

				st_wait:
				begin
					wait_count <= wait_count + 1'b1;  // Increment wait count
					if (w_d)                          // Check dispense condition
					begin
						wait_count <= 25'd0;      // Reset wait count
						next_state <= st_disp;    // Transition to dispense state
					end
					if (wait_count >= wait_cycles)    // Check if waiting has completed the desired cycles
					begin
						next_state <= st_init;    // Transition to init state
					end
				end

				default:
					next_state <= st_wait;           // Default state is wait state
			endcase
		end
	end
							  
	/*--------- Price Update and Acceptance Block --------------------------*/
	always @(posedge w_clock_10khz_out, negedge w_n_rst)
	begin
		// Check if reset is active (low)
		if (w_n_rst == 1'b0)
		begin
			price <= 8'd0;  // Initialize price to zero on reset
		end
		else
		begin
			// Check if push button 1 (w_pb1_rise) is pressed and switch 3 (sw[3]) is on
			if (w_pb1_rise == 1'b1 & sw[3])
			begin
				price <= price + w_a;  // Increment the price by the value in w_a
			end
			
			// Check if push button 3 (w_pb3_rise) is pressed and switch 3 (sw[3]) is on
			if (w_pb3_rise == 1'b1 & sw[3])
			begin
				price_acptd <= price;  // Accept the current price value
			end
		end
	end


endmodule
