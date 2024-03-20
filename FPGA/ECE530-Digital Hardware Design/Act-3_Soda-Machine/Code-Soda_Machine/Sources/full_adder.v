`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/20/2023 08:22:01 AM
// Design Name: 
// Module Name: full_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This full adder performs the addition of three one-bit binary numbers.
//              The three inputs are a, b, and cin (Carry in), and it produces two outputs: s (Sum) and cout (Carry out).
//              The sum output represents the sum of the inputs, while the carry out represents a carry-over value, if any.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module full_adder( cout, s, a, b, cin);

    /*--------- Declare Module I/O --------------------------*/
    output cout; // Carry-out bit
    output s;    // Sum bit
    input a;     // First input bit
    input b;     // Second input bit
    input cin;   // Carry-in bit
    
    /*--------- Declare internal wires --------------------------*/
    wire w_out1; // XOR of a and b
    wire w_out2; // AND of a and b
    wire w_out3; // AND of out1 and cin
    
    xor x1(w_out1 , a, b);
    xor x2(s ,w_out1, cin);
    and a1(w_out2, a, b);
    and a2(w_out3,w_out1, cin);
    or o1(cout, w_out2, w_out3);                  
endmodule
