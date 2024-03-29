`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
//
// Create Date: 09/25/2023 09:06:36 AM
// Design Name: ALU (Arithmetic Logic Unit)
// Module Name: alu
// Project Name: Project 01 - ALU Design
// Target Devices: 
// Tool Versions: 
// Description: ALU capable of various arithmetic and logical operations based on selector inputs.
// Dependencies: n_bit_adder, n_bit_sub, n_bit_twos_comp, n_bit_compare, n_bit_shift
// Revision: 0.01
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module alu #(parameter WIDTH = 32)(out, carry_sgn, a, b, sel);

    /*--------- Declare I/O --------------------------*/
    output [WIDTH-1:0] out;           // ALU output
    output carry_sgn;                 // Carry or sign bit output
    input [WIDTH-1:0] a;              // Operand 'a'
    input [WIDTH-1:0] b;              // Operand 'b'
    input [3:0] sel;                  // Selector input

    /*--------- Declare internal wires --------------------------*/
    wire [WIDTH-1:0] w_sum;           // Sum from the adder module
    wire w_add_c;                     // Carry from the adder module
    wire [WIDTH-1:0] w_sub;           // Subtraction result
    wire w_sgn;                       // Sign bit from the subtractor module
    wire [WIDTH-1:0] w_tc_out;        // Two's complement result
    wire w_gt;                        // Greater-than comparison result
    wire w_eq;                        // Equals comparison result
    wire w_lt;                        // Less-than comparison result
    wire [WIDTH-1:0] w_shift_right;   // Right shift result
    wire [WIDTH-1:0] w_shift_left;    // Left shift result
    wire [WIDTH-1:0] w_shift_out;     // Shift operation result

    // Module instantiations and ALU logic
    n_bit_adder #(WIDTH) add(.s(w_sum), .cout(w_add_c), .a(a), .b(b), .cin(1'b0));
    n_bit_sub #(WIDTH) sub(.sub(w_sub), .sgn(w_sgn), .a(a), .b(b));
    n_bit_twos_comp #(WIDTH) tc(.out(w_tc_out), .in(a));
    n_bit_compare #(WIDTH) comp(.gt_out(w_gt), .eq_out(w_eq), .lt_out(w_lt), .a(a), .b(b));
    n_bit_shift #(WIDTH) shift(.out(w_shift_out), .in(a), .right(sel[3]));

    assign carry_sgn = sel[0] ? w_sgn : w_add_c;

    // ALU operations based on selector input
    assign out = (sel[2:0] == 3'b000) ? w_sum :
                 (sel[2:0] == 3'b001) ? w_sub :
                 (sel[2:0] == 3'b010) ? {w_gt, w_eq, w_lt} :
                 (sel[2:0] == 3'b011) ? w_tc_out :
                 (sel[2:0] == 3'b100) ? a & b :
                 (sel[2:0] == 3'b101) ? a | b :
                 (sel[2:0] == 3'b110) ? a ^ b :
                 (sel[2:0] == 3'b111) ? w_shift_out : 0;

endmodule
