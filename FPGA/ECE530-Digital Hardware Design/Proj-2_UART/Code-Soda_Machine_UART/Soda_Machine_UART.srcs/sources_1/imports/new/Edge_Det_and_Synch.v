`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/13/2023 03:25:55 PM
// Design Name: 
// Module Name: edge_det_and_synch
// Project Name: Assignment 02
// Target Devices: 
// Tool Versions: 
// Description: This module integrates the functionalities of frequency division, flip-flops, and edge detection to synchronize and detect edges in a signal.
//
// 
// Dependencies: Freq_Div, D_FF, Edge_Det
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module edge_det_and_synch(Rise,Fall,Clock_in,n_rst,Sig);

    /*--------- Declare I/O --------------------------*/
    output reg Rise;		// Output signal indicating a rising edge
    output reg Fall;		// Output signal indicating a falling edge
    input Clock_in;			// Clock input signal
    input n_rst;			// Reset input signal
    input Sig;				// Signal input

    /*--------- Declare internal wires and registers --------------------------*/
    wire w_SYNC_Q;        // Synchronized signal output
    wire w_C1_Q;          // Output from the first flip-flop in the synchronization chain
    wire w_C2_Q;          // Output from the second flip-flop in the synchronization chain
    wire w_rise;        // Internal wire indicating a rising edge
    wire w_fall;        // Internal wire indicating a falling edge

    /*--------- Instantiate modules --------------------------*/
    d_ff SYNC (.Q(w_SYNC_Q), .D(Sig), .clkin(Clock_in), .n_rst(n_rst)); 							// Synchronization flip-flop
    d_ff C1 (.Q(w_C1_Q), .D(w_SYNC_Q), .clkin(Clock_in), .n_rst(n_rst)); 							// First flip-flop in the chain
    d_ff C2 (.Q(w_C2_Q), .D(w_C1_Q), .clkin(Clock_in), .n_rst(n_rst)); 							// Second flip-flop in the chain
    Edge_Det Compare (.rise(w_rise), .fall(w_fall), .in_1(w_C1_Q), .in_2(w_C2_Q)); 							// Edge detection module

    /*--------- Logic to update outputs and display values --------------------------*/
    always @ (*)
    begin
       Rise = w_rise;    			// Update the rise output
       Fall = w_fall;    			// Update the fall output
    end

endmodule
