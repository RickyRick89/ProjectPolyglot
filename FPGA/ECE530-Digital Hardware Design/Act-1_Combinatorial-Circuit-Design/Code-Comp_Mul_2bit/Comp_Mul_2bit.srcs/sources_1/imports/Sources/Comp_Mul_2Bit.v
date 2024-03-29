`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 02:19:44 PM
// Design Name: 
// Module Name: Comp_Mul_2bit
// Project Name: Activity 01, Part 2
// Target Devices: 
// Tool Versions: 
// Description: This module integrates comparison and multiplication functionalities, utilizing ROMs and a multiplexer to process and output respective results.
// 
// Dependencies: Mul_2bit.v, Comp_2bit.v, mux_2w_to_1w.v
// 
// Revision: 0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Comp_Mul_2bit( out, a, b, sel);

    /*--------- Declare Module I/O --------------------------*/
    output wire [3:0] out;  // Output data
    input [1:0] a, b;       // First and second 2-bit input
    input sel;              // Selector for mux
    
    /*--------- Declare internal wires --------------------------*/
    wire [3:0] w_mul_out;    // Output from multiplication module
    wire [3:0] w_comp_out;   // Output from comparison module

    // Instantiate multiplication and comparison modules
    Mul_2bit mul1 (.data(w_mul_out),.addr({b,a}));
    Comp_2bit comp1 (.data(w_comp_out),.addr({b,a}));
   
    assign out = sel ? w_mul_out : w_comp_out;
    
endmodule
