`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 02:50:59 PM
// Design Name: 
// Module Name: tb_Binary_to_BCD
// Project Name: Assignmet 01, Part 3
// Target Devices: 
// Tool Versions: 
// Description: This testbench module is designed to validate the functionality of the "Binary_to_BCD" module.
//              Within this testbench, a loop iterates through all possible 8-bit binary numbers (from 0 to 255), assigning each as an input to the Binary_to_BCD module and observing the BCD output.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_Binary_to_BCD();
    /*--------- Declare registers and wires --------------------------*/
    reg [8:0] i;     // Loop index for simulation
    reg [7:0] bin;   // Binary input for the unit under test
    wire [9:0] w_bcd;  // BCD output from the unit under test

    /*--------- Declare simulation period --------------------------*/
    parameter period=10;
        
    /*--------- Instantiate the unit under test (uut) --------------------------*/
    Binary_to_BCD uut (.bcd(w_bcd), .bin(bin));
    
    /*--------- Initial block for simulation --------------------------*/
    initial						
    begin
        // Loop through all possible binary numbers
        for (i = 0; i <= 255; i = i + 1)
        begin
            bin = i;  // Set the binary input
            # period; // Wait for 'period' time units
        end
        
        // Stop the simulation after 5*'period' time units
        # (period*5) $stop;
    end
endmodule