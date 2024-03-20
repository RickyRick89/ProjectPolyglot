`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2023 04:55:23 PM
// Design Name: 
// Module Name: UART_top
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


module UART_top(TxD,TxFIFO_full,TxFIFO_empty,clk_50mhz,TxDin,TxFIFO_wr,config_reg,clk,n_rst);
	output TxD;
	output TxFIFO_full;
	output TxFIFO_empty;
	input clk_50mhz;
	input [9:0] TxDin;
	input TxFIFO_wr;
    input clk;
    input n_rst;
	input	[7:0] config_reg; //I_Rst,Clr_EF,Par1,Par0,S_num,D_num,Bd_rate1,Bd_rate0
							/*BD_Rate (1:0) – These two bits are used to specify the baud rate which can be:
									9600 for Bd_Rate = 0 0
									19,200 for Bd_Rate = 0 1
									57,600 for Bd_Rate = 1 0
									115,200 for Bd_Rate = 1 1
							D_num – This bit specify the number of data bits which can be
									7 if D_ num = 0
									8 if D_num = 1
							S_num – This bit specify the number of stop bits which can be
									1 if S-num = 0
									2 if S_num = 1
							Par (1:0) – These two bits are used to specify desired parity scheme
									No parity if Par = 0 0
									Odd parity if Par = 0 1
									Even parity if Par = 1 0
									Invalid if Par = 1 1
							Clr_EF – If set, all error flags are cleared.
							I_Rst – if set, an internal reset is issued to clear status register and returns the
									UART back to the configuration mode.*/
	reg [4:0] status_reg; //OE_Fg,FE_Fg,PE_Fg,Tx_Rdy,Rx_Rdy
							/*
							Tx_Rdy – This bit is set to logic 1 to inform the CPU that the UART can accept a
									new character for transmission. i.e., the TX_FIFO in not full. This bit is
									reset to logic 0 when the TX_FIFO is full and data were not yet read by
									the external serial peripheral device.
							Rx_Rdy – This bit is set to logic 1 when at least one character is in the RX_ FIFO. It
									will go inactive when there are no more characters in the FIFO.
							PE_Fg – The Parity Error Flag is set to indicate that the data character in the
									FIFO does not have the correct parity.
							FE_Fg – The framing Error Flag is set to indicate that the character in the FIFO
									does not have valid stop bit(s) sequence detected.
							OE_Fg – The Overrun Error Flag is set when a character is being received by the
									receiver block while the RX_FIFO is full. An interrupt is generated and
									This character is lost. The interrupt routine will read all data from the
									receive FIFO */
    
	reg Tx_NewDta;
	reg TxFIFO_rd;
		
    wire w_sample_tick;
    (* mark_debug = "true" *) wire w_baud;
	wire [9:0] w_RxDin;
	wire w_RxDone;
	wire w_RxPar;
	wire w_RxErr;
	wire w_RxFIFO_full;
	wire w_RxFIFO_empty;
	wire [9:0] w_TxFIFO_Dout;
	wire w_Tx_Rdy;
	
    
    
    baud_gen #(50000000) gen (.tick(w_sample_tick),.bd(w_baud),.sample('d16),.bd_rate(config_reg[1:0]),.clk(clk_50mhz),.n_rst(n_rst));
	UART_xmtr xmtr (.TxD(TxD),.Tx_Rdy(w_Tx_Rdy),.Tx_Dout(w_TxFIFO_Dout),.Tx_NewDta(Tx_NewDta),.clk(clk_50mhz),.n_rst(n_rst),.baud_tick(w_baud),.d_num(config_reg[2]),.s_num(config_reg[3]),.par(config_reg[5:4]));
    uart_fifo TxFIFO (.data_out(w_TxFIFO_Dout),.empty(TxFIFO_empty),.full(TxFIFO_full),.clock(clk_50mhz),.reset(n_rst),.write(TxFIFO_wr),.data_in(TxDin),.read(TxFIFO_rd));
	
	
    always @(posedge clk_50mhz, negedge n_rst)
	begin
		if (n_rst==1'b0)
		begin
			Tx_NewDta <= 0;
			TxFIFO_rd <= 0;
			status_reg <= 0;
		end
		else
		begin
			if (!TxFIFO_empty & w_Tx_Rdy)
			begin
				TxFIFO_rd <= 1'b1;
				Tx_NewDta <= 1'b1;
			end
			else
			begin
				TxFIFO_rd <= 1'b0;
				Tx_NewDta <= 1'b0;
			end	
		end
	end
	
	
endmodule
