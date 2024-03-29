`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 03:09:07 PM
// Design Name: 
// Module Name: Mux_2x4
// Project Name: Assignmet 01, Part 3
// Target Devices: 
// Tool Versions: 
// Description: This module is a 2x4 multiplexer.
//              It is designed to select one output from four 4-bit input lines (a, b, c, and d) based on a 2-bit selector input (sel).
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux_2x4( out, a, b, c, d, sel);

    /*--------- Declare Module I/O --------------------------*/
    output reg [3:0] out; // Output from the multiplexer
    input [3:0] a;        // Input a
    input [3:0] b;        // Input b
    input [3:0] c;        // Input c
    input [3:0] d;        // Input d
    input [1:0] sel;       // Selector input
    
    wire w_out;
    
    // Multiplexer logic
    assign w_out = sel[1] ? (sel[0] ? d : c ) : ( sel[0] ? b :a);
    
    /*--------- Always block to drive output --------------------------*/
    always @(*)
    begin
        out = w_out;
    end

endmodule