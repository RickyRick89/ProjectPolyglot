`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 02:19:44 PM
// Design Name: 
// Module Name: Full_Adder_2Bit
// Project Name: Assignment 01, Part 1
// Target Devices: 
// Tool Versions: 
// Description: This two-bit ripple carry adder is made of two cascading full adders, where the carry out of the first full adder serves as the carry in for the second full adder.
//              This setup allows for the addition of two two-bit binary numbers.
// 
// Dependencies: Full_Adder.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Full_Adder_2Bit( s, cout, a, b, cin);

    /*--------- Declare Module I/O --------------------------*/
    output [1:0] s;    // 2-bit sum
    output cout;       // Carry-out bit
    input [1:0] a;     // First 2-bit input
    input [1:0] b;     // Second 2-bit input
    input cin;          // Carry-in bit
    
    /*--------- Declare internal wires --------------------------*/
    wire w_c1;  // Carry-out from the first 1-bit full adder, used as carry-in for the second
    reg w_cin_internal; // Internal signal to hold the value of cin    
    
    Full_Adder fa1 (.a (a[0]), .b (b[0]), .cin (cin), .s (s[0]), .cout (w_c1));
    Full_Adder fa2 (.a (a[1]), .b (b[1]), .cin (w_c1), .s (s[1]), .cout (cout));
                  
endmodule
