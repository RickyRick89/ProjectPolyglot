`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2023 04:52:41 PM
// Design Name: 
// Module Name: UART_receiver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_receiver(Rx_Dout,Rx_Done,Rx_par,err,clk,n_rst,RxD,sample_tick,d_num,s_num,par);
    
    output reg [9:0] Rx_Dout;
    output reg Rx_Done;
	output reg Rx_par;
    output reg err;
    
    input clk;
    input n_rst;
    input RxD;
    input sample_tick;
    input d_num;
    input s_num;
    input [1:0] par;
	
	
	
	reg [3:0] state;
	reg [4:0] tick_no;
	(* mark_debug = "true" *) reg [4:0] data_stop_no;
	reg [4:0] num_bits;
	reg [7:0] data_buf;
	reg par_error;
	reg frame_error;
	
	wire [4:0] w_num_data_bits;
	wire [1:0] w_num_stop_bits;
	wire w_num_par_bits;
	
	
	assign w_num_data_bits = (d_num == 1'b1) ? 4'd8:
											   4'd7;
	assign w_num_stop_bits = (s_num == 1'b1) ? 2'd2:
											   2'd1;
	assign w_num_par_bits = (par == 2'b00) 	? 1'd0:
							(par == 2'b01) 	? 1'd1:
							(par == 2'b10) 	? 1'd1:
											  1'd0;
							
    
    
    /*--------- Parameterized States for the FSM ---------*/
    parameter   st_init    = 4'd1,
				st_receive    = 4'd2;
				
			    
    always @(posedge clk, negedge n_rst)
	begin
		if (n_rst==1'b0)
		begin
			state <= st_init;
			Rx_Dout <= 0;
			Rx_Done <= 0;
			data_stop_no <= 0;
			num_bits <= 0;
			data_buf <= 0;
			Rx_par <= 0;
			par_error <= 0;
			frame_error <= 0;
			err <= 0;
			
		end
		else
		begin	
            if (sample_tick & tick_no > 0)
                tick_no <= tick_no - 1'b1;
            
			case (state)
			st_init:
			begin
				data_buf <= 0;
				Rx_par <= 0;
				Rx_Dout <= 0;
				Rx_Done <= 0;
			    tick_no <= 1'b0;
				data_stop_no <= 0;
				frame_error <= 0;
			    err <= 0;
				
				if (!RxD & sample_tick)
				begin
					tick_no <= 6;
					state <= st_receive;
				end
			end
			st_receive:
			begin
				if (sample_tick)
				begin
					if (tick_no == 0)
					begin
						if (data_stop_no == 0)//Middle of Start Bit
						begin
							data_stop_no <= data_stop_no + 1;
							tick_no <= 15;
						end
						else
						begin
							if (data_stop_no <= w_num_data_bits)//Data Bits
							begin
								data_buf[data_stop_no-1] <= RxD;
								
								data_stop_no <= data_stop_no + 1;
								tick_no <= 15;
							end
							else if (data_stop_no > w_num_data_bits & data_stop_no <= (w_num_data_bits + w_num_par_bits))//Parity Bit (If Applicable)
							begin
								if (w_num_data_bits == 8)
									Rx_par <= data_buf[0]^data_buf[1]^data_buf[2]^data_buf[3]^data_buf[4]^data_buf[5]^data_buf[6]^data_buf[7]^RxD;
								else
									Rx_par <= data_buf[0]^data_buf[1]^data_buf[2]^data_buf[3]^data_buf[4]^data_buf[5]^data_buf[6]^RxD;
							
								data_stop_no <= data_stop_no + 1;
								tick_no <= 15;
							end
							else if (data_stop_no > (w_num_data_bits + w_num_par_bits) & data_stop_no < (w_num_data_bits + w_num_par_bits + w_num_stop_bits))//First Stop Bit (If 2 Configured)
							begin
								if (!RxD)
									frame_error <= 1'b1;
									
								data_stop_no <= data_stop_no + 1;
								tick_no <= 15;
							end
							else if (data_stop_no >= (w_num_data_bits + w_num_par_bits + w_num_stop_bits))//Last Stop Bit
							begin
								if (!RxD)
									frame_error <= 1'b1;
									
								if (par == 2'b01) //Odd Parity
								begin
									if (!Rx_par)
										par_error <= 1'b1;
									else
										par_error <= 1'b0;
								end
								else if (par == 2'b10) //Even Parity
								begin
									if (Rx_par)
										par_error <= 1'b1;
									else
										par_error <= 1'b0;
								end
									
												  
                                err <= par_error | frame_error;
							
								Rx_Dout <= {frame_error,par_error,data_buf};
								Rx_Done <= 1'b1;
								state <= st_init;
							end
						end
					end
				end
			end
			endcase
		end
	end
    
endmodule
