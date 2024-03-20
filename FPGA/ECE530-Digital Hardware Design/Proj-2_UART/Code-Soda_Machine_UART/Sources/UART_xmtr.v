`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2023 04:54:28 PM
// Design Name: 
// Module Name: UART_xmtr
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


module UART_xmtr(TxD,Tx_Rdy,Tx_Dout,Tx_NewDta,clk,n_rst,baud_tick,d_num,s_num,par);
	output reg TxD;
	output reg Tx_Rdy;
	
	input [7:0] Tx_Dout;
	input Tx_NewDta;
	input clk;
	input n_rst;
	input baud_tick;
    input d_num;
    input s_num;
    input [1:0] par;
	
	reg [3:0] state;
	reg [4:0] data_stop_no;
	reg Tx_par;
	
	wire [4:0] w_num_data_bits;
	wire [1:0] w_num_stop_bits;
	wire w_num_par_bits;
	
	
	assign w_num_data_bits = (d_num == 1'b1) ? 'd8:
											   'd7;
	assign w_num_stop_bits = (s_num == 1'b1) ? 'd2:
											   'd1;
	assign w_num_par_bits = (par == 2'b00) 	? 'd0:
							(par == 2'b01) 	? 'd1:
							(par == 2'b10) 	? 'd1:
											  'd0;
	
    /*--------- Parameterized States for the FSM ---------*/
    parameter   st_init    		= 4'd1,
				st_transmit    = 4'd2;
				
				
				
    always @(posedge clk, negedge n_rst)
	begin
		if (n_rst==1'b0)
		begin
			state <= st_init;
			Tx_Rdy <= 0;
			TxD <= 1;
			data_stop_no <= 0;
			Tx_par <= 0;
			
		end
		else
		begin		
			case (state)
			st_init:
			begin
				Tx_Rdy <= 1'b1;
				TxD <= 1;
				data_stop_no <= 0;
				Tx_par <= 0;
				
				if (Tx_NewDta)
				begin
					state <= st_transmit;
				end
			end
			st_transmit:
			begin
				Tx_Rdy <= 1'b0;
				if (baud_tick)
				begin
					if (data_stop_no == 0)//Start Bit
					begin
						TxD <= 0;
						data_stop_no = data_stop_no + 1;
					end
					else if (data_stop_no > 0 & data_stop_no <= w_num_data_bits)//Data Bits
					begin
						TxD <= Tx_Dout[data_stop_no-1];
						Tx_par <= Tx_par^Tx_Dout[data_stop_no-1];
						data_stop_no = data_stop_no + 1;
					end
					else if (data_stop_no > w_num_data_bits & data_stop_no <= (w_num_data_bits + w_num_par_bits))//Parity Bit (If Applicable)
					begin
						if (par == 2'b01)
						begin
							TxD <= !Tx_par;
						end
						else if (par == 2'b10)
						begin
							TxD <= Tx_par;
						end
						data_stop_no = data_stop_no + 1;
					end
					else if (data_stop_no > (w_num_data_bits + w_num_par_bits) & data_stop_no < (w_num_data_bits + w_num_par_bits + w_num_stop_bits))//First Stop Bit (If 2 Configured)
					begin
						TxD <= 1;
						data_stop_no = data_stop_no + 1;
					end
					else if (data_stop_no == (w_num_data_bits + w_num_par_bits + w_num_stop_bits))//Last Stop Bit
					begin
						TxD <= 1;
						data_stop_no = data_stop_no + 1;
					end
					else if (data_stop_no > (w_num_data_bits + w_num_par_bits + w_num_stop_bits))//Last Stop Bit
					begin
						state <= st_init;
					end
					
					
				end
			end
			endcase
		end
	end
		
endmodule
