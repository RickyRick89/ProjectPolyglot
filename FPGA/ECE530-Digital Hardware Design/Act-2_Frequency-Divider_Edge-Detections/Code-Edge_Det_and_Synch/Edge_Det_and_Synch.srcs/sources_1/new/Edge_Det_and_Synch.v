`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/13/2023 03:25:55 PM
// Design Name: 
// Module Name: Edge_Det_and_Synch
// Project Name: Assignment 02
// Target Devices: 
// Tool Versions: 
// Description: This module integrates the functionalities of frequency division, flip-flops, and edge detection to synchronize and detect edges in a signal.
//				It takes a signal input and synchronizes it with a 1Hz clock, then detects rising and falling edges in the synchronized signal.
// 
// Dependencies: Freq_Div, D_FF, Edge_Det
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Edge_Det_and_Synch(Rise,Fall,Clock_1Hz,Clock_5Hz,Clock_in,Reset,Sig);

    /*--------- Declare I/O --------------------------*/
    output reg Rise;		// Output signal indicating a rising edge
    output reg Fall;		// Output signal indicating a falling edge
    output reg Clock_1Hz;	// Output clock signal with a frequency of 1Hz
    output reg Clock_5Hz;   // Output clock signal with a frequency of 5Hz
    input Clock_in;			// Clock input signal
    input Reset;			// Reset input signal
    input Sig;				// Signal input

    /*--------- Declare internal wires and registers --------------------------*/
    reg n_reset;        // Internal inverted reset signal
    wire w_clock_1hz_out; // 1Hz clock output from frequency divider
    wire w_SYNC_Q;        // Synchronized signal output
    wire w_C1_Q;          // Output from the first flip-flop in the synchronization chain
    wire w_C2_Q;          // Output from the second flip-flop in the synchronization chain
    wire w_rise;        // Internal wire indicating a rising edge
    wire w_fall;        // Internal wire indicating a falling edge

    /*--------- Instantiate modules --------------------------*/
    //Freq_Div #(27,2) freq_div_1hz (.clkout(w_clock_1hz_out), .clkin(Clock_in), .n_rst(n_reset));     		// For Simulation Only
    Freq_Div #(27,125000000) freq_div_1hz (.clkout(w_clock_1hz_out), .clkin(Clock_in), .n_rst(n_reset)); 	// Frequency divider module
    Freq_Div #(25,25000000) freq_div_5hz (.clkout(w_clock_5hz_out), .clkin(Clock_in), .n_rst(n_reset));   	// 5Hz frequency divider module
    D_FF SYNC (.Q(w_SYNC_Q), .D(Sig), .clkin(w_clock_1hz_out), .n_rst(n_reset)); 							// Synchronization flip-flop
    D_FF C1 (.Q(w_C1_Q), .D(w_SYNC_Q), .clkin(w_clock_1hz_out), .n_rst(n_reset)); 							// First flip-flop in the chain
    D_FF C2 (.Q(w_C2_Q), .D(w_C1_Q), .clkin(w_clock_1hz_out), .n_rst(n_reset)); 							// Second flip-flop in the chain
    Edge_Det Compare (.rise(w_rise), .fall(w_fall), .in_1(w_C1_Q), .in_2(w_C2_Q)); 							// Edge detection module

    /*--------- Logic to update outputs and display values --------------------------*/
    always @ (*)
    begin
       n_reset = ~Reset; 			// Invert the reset signal
       Rise = w_rise;    			// Update the rise output
       Fall = w_fall;    			// Update the fall output
       Clock_1Hz = w_clock_1hz_out;	// Update the 1Hz clock output
       Clock_5Hz = w_clock_5hz_out;	// Update the 5Hz clock output
    end

endmodule
