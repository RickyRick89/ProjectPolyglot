`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 02:19:44 PM
// Design Name: 
// Module Name: tb_full_adder
// Project Name: Assignment 01, Part 1
// Target Devices: 
// Tool Versions: 
// Description: Testbench for 1-bit full adder
// 
// Dependencies: full_adder.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TB_Full_Adder;
    reg tb_a;    // First input bit for the full adder
    reg tb_b;    // Second input bit for the full adder
    reg tb_cin;  // Carry-in bit for the full adder
    wire tb_s;   // Sum output bit from the full adder
    wire tb_cout;// Carry-out bit from the full adder

    parameter period=10; // Time period for each test vector
    
    // Instantiate the 1-bit full adder
    Full_Adder uut(.s (tb_s), .cout (tb_cout), .a (tb_a), .b (tb_b), .cin (tb_cin));
    
    initial
        // Do nothing
    begin
        // test vector 1
        {tb_a, tb_b, tb_cin} = 5'b000;
        # period; // wait
        
        // test vector 2
        {tb_a, tb_b, tb_cin} = 5'b001;
        # period; // wait
        
        // test vector 3
        {tb_a, tb_b, tb_cin} = 5'b100;
        # period; // wait
        
        // test vector 4
        {tb_a, tb_b, tb_cin} = 5'b101;
        # period; // wait
        
        // test vector 5
        {tb_a, tb_b, tb_cin} = 5'b010;
        # period; // wait
        
        // test vector 6
        {tb_a, tb_b, tb_cin} = 5'b011;
        # period; // wait
        
        // test vector 7
        {tb_a, tb_b, tb_cin} = 5'b110;
        # period; // wait
        
        // test vector 8
        {tb_a, tb_b, tb_cin} = 5'b111;
        # period; // wait
        
        
        # (period*5) $stop; // stop the simulation

    end
endmodule