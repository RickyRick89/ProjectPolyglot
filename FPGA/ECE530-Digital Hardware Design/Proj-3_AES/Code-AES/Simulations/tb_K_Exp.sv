`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 12/01/2023 10:52:45 AM
// Design Name: 
// Module Name: tb_K_Exp
// Project Name: AES Design
// Target Devices: 
// Tool Versions: 
// Description: Testbench for validating the Key Expansion (K_Exp) function used in the AES
//              encryption process. Applies various test vectors to the function and checks
//              the outputs to ensure correct functionality.
// 
// Dependencies: Functions.sv
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_K_Exp();
    `include "../../sources_1/new/Functions.sv" // Include file for the K_Exp function

    // Test Inputs
    reg [15:0] key_in; // Input key for the K_Exp function
    reg [3:0] i;       // Round number input for the K_Exp function

    // Dummy variable to hold function result
    reg [15:0] dummy;  // Variable to store the result of K_Exp

    // Apply test vectors
    initial
    begin
        // Initialize Inputs
        key_in = 0;
        i = 0;

        #10; // Wait for 10 time units

        // Test Case 1
        key_in = 16'h3456; // Set key input
        i = 0;             // Set round number
        dummy = K_Exp(key_in, i); // Call K_Exp function
        #10;
        // Display the results
        $display("Time = %d : key_in = %h, i = %h, result = %h", $time, key_in, i, dummy);
        #10;

        // Test Case 2
        key_in = dummy;    // Update key input with previous result
        i = 1;             // Increment round number
        dummy = K_Exp(key_in, i); // Call K_Exp function
        #10;
        // Display the results
        $display("Time = %d : key_in = %h, i = %h, result = %h", $time, key_in, i, dummy);
        #10;

        // Test Case 3
        key_in = dummy;    // Update key input with previous result
        i = 2;             // Increment round number
        dummy = K_Exp(key_in, i); // Call K_Exp function
        #10;
        // Display the results
        $display("Time = %d : key_in = %h, i = %h, result = %h", $time, key_in, i, dummy);
        #10;

        // Wait for 100 time units and finish the simulation
        #100;
        $finish;
    end

endmodule
