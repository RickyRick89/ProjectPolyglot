`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 02:19:44 PM
// Design Name: 
// Module Name: tb_full_adder_2bit
// Project Name: Assignment 01, Part 1
// Target Devices: 
// Tool Versions: 
// Description:  This testbench module is for a 2-bit full adder, specifying and simulating all possible input vectors and observing the sum and carry-out outputs.
// 
// Dependencies: full_adder_2bit.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TB_Full_Adder_2Bit;

    /*--------- Declare registers --------------------------*/
    reg [1:0] tb_a;  // First 2-bit input for the 2-bit full adder
    reg [1:0] tb_b;  // Second 2-bit input for the 2-bit full adder
    reg tb_cin;      // Carry-in bit for the 2-bit full adder
    
    /*--------- Declare internal wires --------------------------*/
    wire [1:0] tb_s; // 2-bit sum output from the 2-bit full adder
    wire tb_cout;    // Carry-out bit from the 2-bit full adder

    parameter period=10; // Time period for each test vector
    
    // Instantiate the 2-bit full adder
    Full_Adder_2Bit uut(.s (tb_s), .cout (tb_cout), .a (tb_a), .b (tb_b), .cin (tb_cin));
    
    initial
        // Do nothing
    begin
        // test vector 1 - Expected Result: s = 2'b00, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b00000;
        # period; // wait
        
        // test vector 2 - Expected Result: s = 2'b01, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b00001;
        # period; // wait
        
        // test vector 3 - Expected Result: s = 2'b01, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b00100;
        # period; // wait
        
        // test vector 4 - Expected Result: s = 2'b10, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b00010;
        # period; // wait
        
        // test vector 5 - Expected Result: s = 2'b10, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b00101;
        # period; // wait
        
        // test vector 6 - Expected Result: s = 2'b11, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b00011;
        # period; // wait
        
        // test vector 7 - Expected Result: s = 2'b11, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b00110;
        # period; // wait
        
        // test vector 8 - Expected Result: s = 2'b00, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b00111;
        # period; // wait
        
        // test vector 9 - Expected Result: s = 2'b01, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b01000;
        # period; // wait
        
        // test vector 10 - Expected Result: s = 2'b10, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b01001;
        # period; // wait
        
        // test vector 11 - Expected Result: s = 2'b10, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b01100;
        # period; // wait
        
        // test vector 12 - Expected Result: s = 2'b11, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b01010;
        # period; // wait
        
        // test vector 13 - Expected Result: s = 2'b11, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b01101;
        # period; // wait
        
        // test vector 14 - Expected Result: s = 2'b00, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b01110;
        # period; // wait
        
        // test vector 15 - Expected Result: s = 2'b00, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b10000;
        # period; // wait
        
        // test vector 16 - Expected Result: s = 2'b01, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b10001;
        # period; // wait
        
        // test vector 17 - Expected Result: s = 2'b10, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b10010;
        # period; // wait
        
        // test vector 18 - Expected Result: s = 2'b11, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b10011;
        # period; // wait
        
        // test vector 19 - Expected Result: s = 2'b11, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b10110;
        # period; // wait
        
        // test vector 20 - Expected Result: s = 2'b00, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b10111;
        # period; // wait
        
        // test vector 21 - Expected Result: s = 2'b00, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b11000;
        # period; // wait
        
        // test vector 22 - Expected Result: s = 2'b01, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b11001;
        # period; // wait
        
        // test vector 23 - Expected Result: s = 2'b01, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b11100;
        # period; // wait
        
        // test vector 24 - Expected Result: s = 2'b10, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b11010;
        # period; // wait
        
        // test vector 25 - Expected Result: s = 2'b11, Cout = 1'b0
        {tb_a, tb_b, tb_cin} = 5'b11011;
        # period; // wait
        
        // test vector 26 - Expected Result: s = 2'b00, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b11110;
        # period; // wait
        
        // test vector 27 - Expected Result: s = 2'b00, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b11100;
        # period; // wait
        
        // test vector 28 - Expected Result: s = 2'b01, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b11101;
        # period; // wait
        
        // test vector 29 - Expected Result: s = 2'b01, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b11110;
        # period; // wait
        
        // test vector 30 - Expected Result: s = 2'b10, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b11111;
        # period; // wait
        
        // test vector 31 - Expected Result: s = 2'b10, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b11110;
        # period; // wait
        
        // test vector 32 - Expected Result: s = 2'b11, Cout = 1'b1
        {tb_a, tb_b, tb_cin} = 5'b11111;
        # period; // wait

        
        # (period*5) $stop; // stop the simulation

    end
    
endmodule
