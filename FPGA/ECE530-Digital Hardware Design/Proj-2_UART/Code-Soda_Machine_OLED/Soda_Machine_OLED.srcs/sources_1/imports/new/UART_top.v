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


module UART_top(RxFIFO_Dout,RxFIFO_full,RxFIFO_empty,clk_50mhz,RxD,RxFIFO_rd,config_reg,clk,n_rst);
	output [9:0] RxFIFO_Dout;
	output RxFIFO_full;
	output RxFIFO_empty;
	input clk_50mhz;
	input RxD;
	input RxFIFO_rd;
    input clk;
    input n_rst;
	input	[7:0] config_reg; //I_Rst,Clr_EF,Par1,Par0,S_num,D_num,Bd_rate1,Bd_rate0
							/*BD_Rate (1:0) - These two bits are used to specify the baud rate which can be:
									9600 for Bd_Rate = 0 0
									19,200 for Bd_Rate = 0 1
									57,600 for Bd_Rate = 1 0
									115,200 for Bd_Rate = 1 1
							D_num - This bit specify the number of data bits which can be
									7 if D_ num = 0
									8 if D_num = 1
							S_num - This bit specify the number of stop bits which can be
									1 if S-num = 0
									2 if S_num = 1
							Par (1:0) - These two bits are used to specify desired parity scheme
									No parity if Par = 0 0
									Odd parity if Par = 0 1
									Even parity if Par = 1 0
									Invalid if Par = 1 1
							Clr_EF - If set, all error flags are cleared.
							I_Rst - if set, an internal reset is issued to clear status register and returns the
									UART back to the configuration mode.*/
	reg [4:0] status_reg; //OE_Fg,FE_Fg,PE_Fg,Tx_Rdy,Rx_Rdy
							/*
							Tx_Rdy - This bit is set to logic 1 to inform the CPU that the UART can accept a
									new character for transmission. i.e., the TX_FIFO in not full. This bit is
									reset to logic 0 when the TX_FIFO is full and data were not yet read by
									the external serial peripheral device.
							Rx_Rdy - This bit is set to logic 1 when at least one character is in the RX_ FIFO. It
									will go inactive when there are no more characters in the FIFO.
							PE_Fg - The Parity Error Flag is set to indicate that the data character in the
									FIFO does not have the correct parity.
							FE_Fg - The framing Error Flag is set to indicate that the character in the FIFO
									does not have valid stop bit(s) sequence detected.
							OE_Fg - The Overrun Error Flag is set when a character is being received by the
									receiver block while the RX_FIFO is full. An interrupt is generated and
									This character is lost. The interrupt routine will read all data from the
									receive FIFO */
    
		
    (* mark_debug = "true" *) wire w_sample_tick;
    wire w_baud;
	wire [9:0] w_RxDin;
	wire w_RxDone;
	wire w_RxPar;
	wire w_RxErr;
    
    
    baud_gen #(50000000) gen (.tick(w_sample_tick),.bd(w_baud),.sample('d16),.bd_rate(config_reg[1:0]),.clk(clk_50mhz),.n_rst(n_rst));
    UART_receiver rcvr (.Rx_Dout(w_RxDin),.Rx_Done(w_RxDone),.Rx_par(w_RxPar),.err(w_RxErr),.clk(clk_50mhz),.n_rst(n_rst),.RxD(RxD),.sample_tick(w_sample_tick),.d_num(config_reg[2]),.s_num(config_reg[3]),.par(config_reg[5:4]));
    uart_fifo RxFIFO (.data_out(RxFIFO_Dout),.empty(RxFIFO_empty),.full(RxFIFO_full),.clock(clk_50mhz),.reset(n_rst),.write(w_RxDone),.data_in(w_RxDin),.read(RxFIFO_rd));

endmodule
