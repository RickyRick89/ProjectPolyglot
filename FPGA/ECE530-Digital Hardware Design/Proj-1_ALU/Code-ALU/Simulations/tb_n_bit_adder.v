`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/20/2023 02:19:44 PM
// Design Name: 
// Module Name: tb_loop_n_bit_adder
// Project Name: Assignment 01, Part 1
// Target Devices: 
// Tool Versions: 
// Description:  
// 
// Dependencies: n_bit_adder.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_loop_n_bit_adder;

    /*--------- Declare registers --------------------------*/
    reg [4:0] i;       // Loop index for running through test vectors
    reg [1:0] tb_a;    
    reg [1:0] tb_b;    
    reg tb_cin;        
    
    /*--------- Declare internal wires --------------------------*/
    wire [1:0] tb_s;   // 2-bit sum output from the 2-bit full adder
    wire tb_cout;      // Carry-out bit from the 2-bit full adder

    parameter period=10; // Time period for each test vector
    
    // Instantiate a 2-bit full adder
    n_bit_adder #(2) uut(.s (tb_s), .cout (tb_cout), .a (tb_a), .b (tb_b), .cin (tb_cin));
    
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