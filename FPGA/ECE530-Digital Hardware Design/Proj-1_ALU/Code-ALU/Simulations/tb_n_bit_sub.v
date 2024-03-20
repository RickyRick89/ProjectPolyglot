`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/22/2023 11:07:48 AM
// Design Name: Testbench for n-bit subtractor
// Module Name: tb_n_bit_sub
// Project Name: Project 01 - ALU Design
// Target Devices: 
// Tool Versions: 
// Description: Testbench to simulate the functionality of the n-bit subtractor.
// Dependencies: n_bit_sub
// Revision: 0.01
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module tb_n_bit_sub;

    /*--------- Declare registers --------------------------*/
    reg [3:0] i1;         // Loop index for first input 
    reg [3:0] i2;         // Loop index for second input
    reg [3:0] tb_a;       // Testbench operand 'a' 
    reg [3:0] tb_b;       // Testbench operand 'b' 

    /*--------- Declare internal wires --------------------------*/
    wire [3:0] tb_sub;    // Output of the subtraction operation
    wire tb_sgn;          // Sign output (indicates if result is negative)

    parameter period = 10; // Time period for each test vector

    // Instantiate the n-bit subtractor
    n_bit_sub #(4) uut(.sub(tb_sub), .sgn(tb_sgn), .a(tb_a), .b(tb_b));

    initial
    begin
        for (i1 = 0; i1 < 15; i1 = i1 + 1)
        begin
            tb_a = i1;
            for (i2 = 0; i2 < 15; i2 = i2 + 1)
            begin
                tb_b = i2;
                # period; // wait for specified period
            end
        end
        # (period*5) $stop; // Stop the simulation
    end

endmodule
