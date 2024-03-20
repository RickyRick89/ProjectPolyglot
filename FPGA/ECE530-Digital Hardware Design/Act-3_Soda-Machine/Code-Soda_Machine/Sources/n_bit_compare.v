`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/22/2023 12:05:42 PM
// Design Name: N-bit Compare Module
// Module Name: n_bit_compare
// Project Name: Project 01 - ALU Design
// Target Devices: 
// Tool Versions: 
// Description: An n-bit comparison module that utilizes the compare_cell to generate greater than, less than, and equal outputs.
// Dependencies: compare_cell.v
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module n_bit_compare #(parameter WIDTH = 32) (gt_out, eq_out, lt_out, a, b);

    /*--------- Declare I/O --------------------------*/
    output gt_out;          // Greater than output
    output eq_out;          // Equal to output
    output lt_out;          // Less than output
    input [WIDTH-1:0] a;    // First n-bit input operand
    input [WIDTH-1:0] b;    // Second n-bit input operand

    /*--------- Declare internal wires --------------------------*/
    wire [WIDTH:0] w_gt_out; // Greater than internal wires
    wire [WIDTH:0] w_eq_out; // Equal to internal wires
    wire [WIDTH:0] w_lt_out; // Less than internal wires
    
    /*--------- Initial assignments --------------------------*/
    assign w_gt_out[0] = 1'b0;
    assign w_eq_out[0] = 1'b1;
    assign w_lt_out[0] = 1'b0;
    
    /*--------- Instantiate multiple compare cells --------------------------*/
    genvar inc;
    generate
        for (inc = 1; inc <= WIDTH; inc = inc + 1)
        begin: gen_comp_cell
            compare_cell comp_c (
                .gt_out(w_gt_out[inc]),
                .eq_out(w_eq_out[inc]),
                .lt_out(w_lt_out[inc]),
                .gt_in(w_gt_out[inc-1]),
                .eq_in(w_eq_out[inc-1]),
                .lt_in(w_lt_out[inc-1]),
                .a(a[inc-1]),
                .b(b[inc-1])
            ); // Compare cell for each bit
        end
    endgenerate

    /*--------- Final output assignments --------------------------*/
    assign gt_out = w_gt_out[WIDTH];
    assign eq_out = w_eq_out[WIDTH];
    assign lt_out = w_lt_out[WIDTH];
    
endmodule
