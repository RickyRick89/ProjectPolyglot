`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/11/2023 02:58:29 PM
// Design Name: 
// Module Name: tb_Freq_Div_Board
// Project Name: Assignment 02
// Target Devices: 
// Tool Versions: 
// Description: This testbench tests the functionality of the Freq_Div_Board module. 
//              It generates a clock signal with a specified period and toggles a reset signal to test the reset functionality of the Freq_Div_Board module.
// 
// Dependencies: Freq_Div_Board
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_Freq_Div_Board();

    /*--------- Declare registers and wires --------------------------*/
    reg tb_clk;             // Testbench clock signal
    reg rst;                // Reset signal for the unit under test
    wire tb_clk_1hz_out;    // 1Hz output clock signal from the unit under test
    wire tb_clk_5hz_out;    // 5Hz output clock signal from the unit under test

    /*--------- Declare parameters and variables --------------------------*/
    parameter period = 50;          // Period of the testbench clock signal
    parameter num_cycles = 1000;    // Number of cycles for the testbench clock signal
    integer inc;                    // Loop variable for generating the testbench clock signal

    /*--------- Instantiate the unit under test --------------------------*/
    Freq_Div_Board uut (.Clock_1Hz(tb_clk_1hz_out), .Clock_5Hz(tb_clk_5hz_out), .Clock_in(tb_clk), .Reset(rst)); // Unit under test

    /*--------- Initial block to toggle the reset signal --------------------------*/
    initial
    begin
       rst = 1'b0;         // Set the reset signal high initially
       #(period/2);        // Wait for half a period
       rst = 1'b1;         // Set the reset signal low
       # period;           // Wait for a period
       rst = 1'b0;         // Set the reset signal high again
    end

    /*--------- Always block to generate the testbench clock signal --------------------------*/
    always 
    begin
        tb_clk = 0;        // Initialize the testbench clock signal to low
        for (inc = 0; inc < num_cycles; inc = inc + 1)
        begin
            tb_clk = ~tb_clk;  // Toggle the testbench clock signal
            # (period/2);       // Wait for half a period
        end
        $stop;  // Stop the simulation
    end

endmodule
