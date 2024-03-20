`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2023 10:22:47 AM
// Design Name: 
// Module Name: baud_gen
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


module baud_gen #(parameter [27:0]clock_freq = 50000000) (tick,bd,sample,bd_rate,clk,n_rst);
    output reg tick;
	output reg bd;
    input [7:0] sample;
    input [1:0] bd_rate;
    input clk;
    input n_rst;
    
    reg [31:0]tick_counter;
    reg [31:0]bd_counter;
    
    wire [15:0] w_bd_rate;
    wire [31:0] w_tick_count_target;
    wire [31:0] w_bd_count_target;
    
    assign w_bd_rate = (bd_rate == 2'b00) ? 17'd9600:
                        (bd_rate == 2'b01) ? 17'd19200:
                        (bd_rate == 2'b10) ? 17'd57600:
                        (bd_rate == 2'b11) ? 17'd115200:
                                             17'd0;
                                             
    assign w_tick_count_target = (w_bd_rate != 0 & sample != 0) ? (clock_freq/(w_bd_rate*sample)):
                                                            0;
    assign w_bd_count_target = (w_bd_rate != 0) ? clock_freq/(w_bd_rate):
                                                            0;
                                                            
    always @(posedge clk, negedge n_rst)
    begin
		// Check if reset is active (low)
		if (n_rst == 1'b0)
		begin
			tick <= 0;	
			bd <= 0;	
            tick_counter <= w_tick_count_target;
            bd_counter <= w_bd_count_target;
		end
		else
		begin
		  if (tick_counter==0)
		  begin
		      tick <= 1'b1;
		      tick_counter <= w_tick_count_target;
		  end
		  else
		  begin
		      tick <= 1'b0;
		      tick_counter <= tick_counter - 1;
		  end
		  
		  if (bd_counter==0)
		  begin
		      bd <= 1'b1;
		      bd_counter <= w_bd_count_target;
		  end
		  else
		  begin
		      bd <= 1'b0;
		      bd_counter <= bd_counter - 1;
		  end
		
		end
	end

endmodule
