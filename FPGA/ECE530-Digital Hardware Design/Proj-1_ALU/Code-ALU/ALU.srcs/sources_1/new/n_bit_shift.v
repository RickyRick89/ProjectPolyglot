`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/25/2023 08:40:39 AM
// Design Name: N-bit Shift Module
// Module Name: n_bit_shift
// Project Name: Project 01 - ALU Design
// Target Devices: 
// Tool Versions: 
// Description: This module shifts the input either to the right or to the left by one position based on the 'right' input signal.
//              A shift to the right is indicated by 'right' being high, and a shift to the left is indicated by 'right' being low.
// Dependencies: None
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module n_bit_shift #(parameter WIDTH = 32)(out, in, right);

    /*--------- Declare I/O --------------------------*/
    output [WIDTH-1:0] out; // Shifted output
    input [WIDTH-1:0] in;   // N-bit input data
    input right;            // Right shift control signal, when high it shifts to the right, otherwise to the left

    /*--------- Shift operation --------------------------*/
    // If 'right' is high, it will shift to the right by introducing the LSB at the MSB position
    // If 'right' is low, it will shift to the left by pushing the MSB to the LSB position
    assign out = right ? {in[0], in[WIDTH-1:1]} : {in[WIDTH-2:0], in[WIDTH-1]};

endmodule
