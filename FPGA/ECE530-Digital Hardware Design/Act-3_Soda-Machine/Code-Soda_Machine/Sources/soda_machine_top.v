`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 10/05/2023 02:14:29 PM
// Design Name: Soda Machine Top-Level Module
// Module Name: soda_machine_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module serves as the top-level module for the soda machine system. It integrates
//              both the finite state machine (FSM) and datapath components, and handles the necessary
//              interconnections between them.
// Dependencies:soda_machine_fsm
// 				soda_machine_datapath
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module soda_machine_top(d, tot, chng, s, a, c, clkin, n_rst);

    /*--------- Declare I/O --------------------------*/
    output d;                // Output to dispense soda
    output [7:0] tot;        // Total accumulated value
    output [7:0] chng;        
    input [7:0] s;           // Set value against which total is compared
    input [7:0] a;           // Value to be added to the total
    input c;                 // Control input to FSM
    input clkin;             // Clock input
    input n_rst;             // Active-low reset signal

    /*--------- Declare internal wires --------------------------*/
    wire w_tot_ld;           // Load control signal for total value
    wire w_tot_clr;          // Clear control signal for total value
    wire w_tot_lt_s;         // Output indicating if total is less than set value
    wire w_d;                // Internal wire for soda dispense signal

    /*--------- Instantiate FSM and Datapath modules --------------------------*/
    soda_machine_fsm fsm ( 
        .d(w_d),
        .tot_ld(w_tot_ld),
        .tot_clr(w_tot_clr),
        .tot_lt_s(w_tot_lt_s),
        .c(c),
        .clkin(clkin),
        .n_rst(n_rst)
    );                       // Finite state machine for soda machine control

    soda_machine_datapath dp ( 
        .tot_lt_s(w_tot_lt_s),
        .tot(tot),
		.chng(chng),
        .s(s),
        .a(a),
        .tot_ld(w_tot_ld),
        .tot_clr(w_tot_clr),
        .clkin(clkin),
        .n_rst(n_rst)
    );                       // Datapath for soda machine arithmetic and logic

    /*--------- Assignments --------------------------*/
    assign d = w_d;          // Assign the internal dispense signal to output

endmodule
