`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/13/2023 03:35:09 PM
// Design Name: 
// Module Name: D_FF
// Project Name: Assignment 02
// Target Devices: 
// Tool Versions: 
// Description: This module implements a D-type flip-flop (D FF) with a negative reset input. 
//              The flip-flop captures the value on the D input at the rising edge of the clock 
//              and transfers it to the Q output, unless the reset is active, in which case it resets the Q output to 0.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module D_FF(Q,D,clkin,n_rst);

    /*--------- Declare I/O --------------------------*/
    output reg Q;	// Output of the flip-flop
    input D;		// Data input to the flip-flop
    input clkin;	// Clock input
    input n_rst;	// Negative reset input
    
    /*--------- Flip-flop behavior --------------------------*/
    always @ (posedge clkin or negedge n_rst)
    begin
        if (n_rst == 1'b0)
            Q <= 1'b0;	// Reset the output to 0 when reset is active
        else
            Q <= D;   	// Capture the data input on the rising edge of the clock
    end
endmodule
