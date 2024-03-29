`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/11/2023 04:40:43 PM
// Design Name: 
// Module Name: Freq_Div_Board
// Project Name: Assignment 02
// Target Devices: 
// Tool Versions: 
// Description: This module generates two different frequency clock signals, 1Hz and 5Hz, from the input clock signal. 
// 
// Dependencies: Freq_Div
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Freq_Div_Board(Clock_1Hz,Clock_5Hz,Clock_in,Reset);

    /*--------- Declare I/O --------------------------*/
    output reg Clock_1Hz;	// Output clock signal with a frequency of 1Hz
    output reg Clock_5Hz;   // Output clock signal with a frequency of 5Hz
    input Clock_in;         // Input clock signal
    input Reset;            // Reset input signal

    /*--------- Declare internal wires and registers --------------------------*/
    reg n_reset;            // Internal inverted reset signal
    wire w_clock_1hz_out;     // 1Hz clock output from frequency divider
    wire w_clock_5hz_out;     // 5Hz clock output from frequency divider

    /*--------- Instantiate modules --------------------------*/
    Freq_Div #(27,125000000) freq_div_1hz (.clkout(w_clock_1hz_out), .clkin(Clock_in), .n_rst(n_reset));// 1Hz frequency divider module
    Freq_Div #(25,25000000) freq_div_5hz (.clkout(w_clock_5hz_out), .clkin(Clock_in), .n_rst(n_reset)); // 5Hz frequency divider module
    //Freq_Div #(27,20) freq_div_1hz (.clkout(w_clock_1hz_out), .clkin(Clock_in), .n_rst(n_reset));     // For Simulation Only
    //Freq_Div #(25,10) freq_div_5hz (.clkout(w_clock_5hz_out), .clkin(Clock_in), .n_rst(n_reset));     // For Simulation Only

    /*--------- Logic to update outputs and invert reset signal --------------------------*/
    always @(*)
    begin
       Clock_1Hz = w_clock_1hz_out;  // Update the 1Hz clock output
       Clock_5Hz = w_clock_5hz_out;  // Update the 5Hz clock output
       n_reset = ~Reset;           // Invert the reset signal
    end

endmodule
