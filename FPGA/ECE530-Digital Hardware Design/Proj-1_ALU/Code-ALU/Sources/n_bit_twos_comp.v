`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
//
// Create Date: 09/20/2023 04:17:01 PM
// Design Name: n_bit_twos_comp Module
// Module Name: n_bit_twos_comp
// Project Name: Project 01 - ALU Design
// Target Devices: 
// Tool Versions: 
// Description: Module to compute the two's complement of an n-bit number.
//
// Dependencies: None.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module n_bit_twos_comp #(parameter WIDTH = 32)(out, in);

    /*--------- Declare Module I/O --------------------------*/
    output [WIDTH-1:0] out;     // Twos-complement output
    input [WIDTH-1:0] in;       // n-bit input to be complemented

    /*--------- Declare internal wires --------------------------*/
    wire [WIDTH-2:0] w_ors;     // OR gate results for the calculation
    wire [WIDTH-1:0] w_xors;    // XOR gate results for the calculation

    // Initial assignments for the calculation
    assign out[0] = in[0];
    assign w_ors[0] = in[0];
    assign w_xors[0] = in[0];
    assign w_xors[1] = in[0] ^ in[1];
    assign out = w_xors;

    genvar inc;

    // Generate the logic for twos complement
    generate
        for (inc = 2; inc < WIDTH; inc = inc + 1)
        begin: gen_n_bit_twos_comp
            // OR gate instantiation for twos complement logic
            or O(w_ors[inc-1], w_ors[inc-2], w_xors[inc-1]);

            // XOR gate instantiation for twos complement logic
            xor XO(w_xors[inc], in[inc], w_ors[inc-1]);
        end
    endgenerate

endmodule
