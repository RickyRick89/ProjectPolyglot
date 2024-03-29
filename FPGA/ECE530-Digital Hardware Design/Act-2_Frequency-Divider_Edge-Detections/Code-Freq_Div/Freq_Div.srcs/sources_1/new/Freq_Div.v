`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/11/2023 10:25:49 AM
// Design Name: 
// Module Name: Freq_Div
// Project Name: Assignment 02
// Target Devices: 
// Tool Versions: 
// Description: This module divides the frequency of the input clock signal (clkin) by a specified divisor.
//				The module also supports a negative reset (n_rst), which resets the clock divider and the output clock signal to their initial states.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Freq_Div(clkout,clkin,n_rst);

    /*--------- Declare I/O --------------------------*/
    output reg clkout;	// Output clock signal with divided frequency
    input clkin;		// Input clock signal
    input n_rst;		// Negative reset signal

    /*--------- Declare parameters and internal registers --------------------------*/
    parameter divisor_size = 2;                 // Size of the divisor
    parameter [divisor_size-1:0] divisor = 2;   // Divisor value
    reg [divisor_size-2:0] count;               // Counter register

    /*--------- Frequency Division Logic --------------------------*/
    always @ (posedge clkin or negedge n_rst)
    begin
        if (n_rst == 1'b0)
        begin
            count <= (divisor/2'b10)-1'b1;  // Reset the counter to half the divisor value minus one
            clkout <= 1'b0;                 // Reset the output clock signal
        end
        else
        begin
            if (count == 0)
            begin
                clkout <= ~clkout;              // Toggle the output clock signal
                count <= (divisor/2'b10)-1'b1;  // Reset the counter to half the divisor value minus one
            end
            else
            begin
                count <= count - 1'b1;  // Decrement the counter
            end
        end
    end

endmodule
