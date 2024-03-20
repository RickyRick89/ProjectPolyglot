`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/22/2023 11:42:55 AM
// Design Name: Bitwise Comparison Cell
// Module Name: compare_cell
// Project Name: Project 01 - ALU Design
// Target Devices: 
// Tool Versions: 
// Description: This module provides bitwise comparison between two input bits.
// Dependencies: None
// Revision: 0.01
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module compare_cell(gt_out, eq_out, lt_out, gt_in, eq_in, lt_in, a, b);

    /*--------- Declare I/O --------------------------*/
    output gt_out;   // Output for 'greater than' condition
    output eq_out;   // Output for 'equal to' condition
    output lt_out;   // Output for 'less than' condition
    input gt_in;     // Previous 'greater than' condition
    input eq_in;     // Previous 'equal to' condition
    input lt_in;     // Previous 'less than' condition
    input a, b;      // Two input bits for comparison

    /*--------- Logic operations --------------------------*/
    assign eq_out = eq_in & (~a & ~b | a & b);
    assign gt_out = a & ~b | (gt_in & (~a & ~b | a & b));
    assign lt_out = ~(eq_in & (~a & ~b | a & b)) & ~(a & ~b | (gt_in & (~a & ~b | a & b)));

endmodule
