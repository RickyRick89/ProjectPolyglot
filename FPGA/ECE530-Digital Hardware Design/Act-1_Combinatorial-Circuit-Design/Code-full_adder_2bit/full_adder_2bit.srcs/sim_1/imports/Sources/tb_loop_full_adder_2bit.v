`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 02:19:44 PM
// Design Name: 
// Module Name: tb_loop_full_adder_2bit
// Project Name: Assignment 01, Part 1
// Target Devices: 
// Tool Versions: 
// Description:  This is a testbench module for a 2-bit full adder. It utilizes a loop structure to systematically simulate all possible input combinations (0 to 31) for the adder.
// 
// Dependencies: full_adder_2bit.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TB_Loop_Full_Adder_2Bit;

    /*--------- Declare registers --------------------------*/
    reg [4:0] i;       // Loop index for running through test vectors
    reg [1:0] tb_a;    // First 2-bit input for the 2-bit full adder
    reg [1:0] tb_b;    // Second 2-bit input for the 2-bit full adder
    reg tb_cin;        // Carry-in bit for the 2-bit full adder
    
    /*--------- Declare internal wires --------------------------*/
    wire [1:0] tb_s;   // 2-bit sum output from the 2-bit full adder
    wire tb_cout;      // Carry-out bit from the 2-bit full adder

    parameter period=10; // Time period for each test vector
    
    // Instantiate the 2-bit full adder
    Full_Adder_2Bit uut(.s (tb_s), .cout (tb_cout), .a (tb_a), .b (tb_b), .cin (tb_cin));
    
    initial
        // Do nothing
    begin
        for (i = 0; i < 31; i = i + 1)
        begin
            {tb_a, tb_b, tb_cin} = i;
            # period; // wait
        end
        
        # (period*5) $stop; // stop the simulation
    end
    
endmodule