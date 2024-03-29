`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/20/2023 04:23:59 PM
// Design Name: Testbench for n-bit two's complement converter
// Module Name: tb_n_bit_twos_comp
// Project Name: Project 01 - ALU Design
// Target Devices: 
// Tool Versions: 
// Description: Testbench to simulate the functionality of the n-bit two's complement converter.
// Dependencies: n_bit_twos_comp
// Revision: 0.01
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module tb_n_bit_twos_comp;

    /*--------- Declare registers --------------------------*/
    reg [4:0] i;         // Loop index for running through test vectors
    reg [4:0] tb_in;     // Testbench input

    /*--------- Declare internal wires --------------------------*/
    wire [4:0] tb_out;   // Output of the two's complement operation

    parameter period = 10; // Time period for each test vector

    // Instantiate the n-bit two's complement converter
    n_bit_twos_comp #(5) uut(.out(tb_out), .in(tb_in));

    initial
    begin
        for (i = 0; i < 31; i = i + 1)
        begin
            tb_in = i;
            # period; // Wait for specified period
        end
        # (period*5) $stop; // Stop the simulation
    end

endmodule
