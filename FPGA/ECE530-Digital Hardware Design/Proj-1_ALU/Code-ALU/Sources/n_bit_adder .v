`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/20/2023 02:19:44 PM
// Design Name: N-bit Adder Module
// Module Name: n_bit_adder
// Project Name: Project 01 - ALU Design
// Target Devices: 
// Tool Versions: 
// Description: An n-bit adder module which uses a generate statement to create multiple full adders based on the provided width.
// Dependencies: full_adder.v
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module n_bit_adder #(parameter WIDTH = 32)(s, cout, a, b, cin);

    /*--------- Declare I/O --------------------------*/
    output [WIDTH-1:0] s;   // n-bit sum output
    output cout;            // Carry-out bit
    input [WIDTH-1:0] a;    // First n-bit input operand
    input [WIDTH-1:0] b;    // Second n-bit input operand
    input cin;              // Carry-in bit

    /*--------- Declare internal wires --------------------------*/
    wire [WIDTH:0] w_carry; // Internal carry wires for each full adder

    /*--------- Instantiate multiple full adders --------------------------*/
    genvar inc;
    generate
        for (inc = 0; inc < WIDTH; inc = inc + 1)
        begin: gen_adder_block
            full_adder fa (
                .a(a[inc]), 
                .b(b[inc]), 
                .cin(w_carry[inc]), 
                .s(s[inc]), 
                .cout(w_carry[inc+1])
            ); // Full adder module for each bit
        end
    endgenerate

    /*--------- Assignments --------------------------*/
    assign w_carry[0] = cin;             // Initial carry-in assignment
    assign cout = w_carry[WIDTH];       // Carry-out assignment for the MSB full adder

endmodule
