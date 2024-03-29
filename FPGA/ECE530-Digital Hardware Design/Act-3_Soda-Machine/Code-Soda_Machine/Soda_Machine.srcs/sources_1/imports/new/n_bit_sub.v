`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/20/2023 04:52:43 PM
// Design Name: N-bit Subtraction Module
// Module Name: n_bit_sub
// Project Name: Project 01 - ALU Design
// Target Devices: 
// Tool Versions: 
// Description: This module performs N-bit subtraction using a combination of an N-bit adder and
//              two's complement arithmetic. The subtraction is done by adding the two's complement
//              of the second operand (b) to the first operand (a). The result and the sign are produced
//              based on the output of the adder.
// Dependencies: n_bit_adder, n_bit_twos_comp
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module n_bit_sub #(parameter WIDTH = 32)(sub, sgn, a, b);

    /*--------- Declare I/O --------------------------*/
    output [WIDTH-1:0] sub;  // N-bit subtraction result
    output sgn;              // Sign output, indicating if the result is negative
    input [WIDTH-1:0] a;    // First operand for subtraction
    input [WIDTH-1:0] b;    // Second operand for subtraction

    /*--------- Declare internal wires --------------------------*/
    wire [WIDTH-1:0] w_adder_out;               // N-bit adder output
    wire w_adder_carry_out;                    // Carry out from the adder
    wire [WIDTH-1:0] w_n_bit_twos_comp_out;    // Two's complement output for the subtracted result
    
    /*--------- Instantiate required modules --------------------------*/
    // Adder instantiation to add 'a' and two's complement of 'b'
    n_bit_adder #(WIDTH) fa (.a (a), .b (~b), .cin (1'b1), .s (w_adder_out), .cout (w_adder_carry_out));
    // Two's complement module instantiation to get the two's complement of the adder's output
    n_bit_twos_comp #(WIDTH) tc (.out(w_n_bit_twos_comp_out), .in(w_adder_out));
    
    /*--------- Logic to determine subtraction result --------------------------*/
    // If the carry out from the adder is not set, then the result is negative, 
    // and the two's complement of the adder's output is taken as the result.
    // Otherwise, the output from the adder itself is taken as the result.
    assign sub = (~w_adder_carry_out) ? w_n_bit_twos_comp_out : w_adder_out;
    assign sgn = ~w_adder_carry_out;  // If carry out is not set, sign is '1' indicating a negative result

endmodule
