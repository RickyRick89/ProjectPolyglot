`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 11/22/2023 01:00:48 PM
// Design Name: 
// Module Name: Poly_Mult
// Project Name: AES Design
// Target Devices: 
// Tool Versions: 
// Description: Performs polynomial multiplication as part of the AES cryptographic
//              algorithm. It takes an 8-bit multiplier and a 4-bit multiplicand to
//              produce an 8-bit output, using a finite state machine for the process.
// 
// Dependencies: n_bit_shift.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Poly_Mult(out,dn,multr,multnd,ld,clk,n_rst);
    output reg [7:0] out;  // 8-bit output of the polynomial multiplication
    output reg dn;         // Done signal, indicates completion of operation
    input [7:0] multr;     // 8-bit multiplier input
    input [3:0] multnd;    // 4-bit multiplicand input
    input ld;              // Load signal to initiate multiplication
    input clk;             // Clock input
    input n_rst;           // Active low reset signal
    
    /*--------- Define FSM states --------------------------*/
    parameter st_init = 4'd1, st_mult1 = 4'd2, st_mult2 = 4'd3, st_result = 4'd4;
    
    reg [3:0] state, next_state; // Current and next state registers
    reg [7:0] mpr_r;             // Register for multiplier
    reg [3:0] mcd_r;             // Register for multiplicand
    reg [7:0] rslt;              // Result register

	/*--------- Wires for shifted operands -----------------*/
    wire [7:0] w_shifted_mcd;
    wire [7:0] w_shifted_mpr;
    
	/*--------- Shift module instances ---------------------*/
    n_bit_shift #(4) mcd_shift (.out(w_shifted_mcd), .in(mcd_r), .right(1'b1));
    n_bit_shift #(8) mpr_shift (.out(w_shifted_mpr), .in(mpr_r), .right(1'b0));
    
	/*--------- State update logic -------------------------*/
    always @ (negedge clk, negedge n_rst)
    begin
        if (n_rst == 1'b0)
        begin
            state <= st_init;      // Set to initial state on reset
            next_state <= st_init;
        end
        else
            state <= next_state;   // Update state
    end	
	
	/*--------- Main FSM logic -----------------------------*/
    always @ (posedge clk, negedge n_rst)
    begin
        if (n_rst == 1'b0)
        begin
            // Reset all registers and output
            mpr_r <= 8'd0;
            mcd_r <= 4'd0;
            rslt <= 8'd0;
            out <= 8'd0;
            dn <= 1'd0;
        end
        else
        begin
            case (state)
                st_init: // Initialization state
                begin
                    mpr_r <= multr;     // Load multiplier
                    mcd_r <= multnd;    // Load multiplicand
                    rslt <= 8'd0;       // Clear result
                    out <= 8'd0;        // Clear output
                    dn <= 1'd0;         // Clear done signal
                    
                    // Move to multiplication phase if load signal is high
                    if (ld)
                        next_state <= st_mult1;
                end
                st_mult1: // First phase of multiplication
                begin
                    if (mcd_r == 4'd0)
                        next_state <= st_result; // Move to result state if multiplicand is zero
                    else
                    begin
                        if (mcd_r[0] == 1'b1)
                            rslt <= rslt ^ mpr_r; // XOR result with multiplier if LSB of multiplicand is 1
                        
                        mpr_r <= w_shifted_mpr;   // Shift multiplier
                        next_state <= st_mult2;   // Move to second phase
                    end
                end
                st_mult2: // Second phase of multiplication
                begin
                    if (mpr_r[4] == 1'b1)
                        mpr_r <= mpr_r ^ 2'd3; // XOR multiplier with 3 if 5th bit is 1
                    
                    mcd_r <= w_shifted_mcd;   // Shift multiplicand
                    next_state <= st_mult1;   // Return to first phase
                end
                st_result: // Result computation state
                begin
                    dn <= 1'd1;                // Set done signal
                    out <= rslt & 8'h0F;       // Output the lower 8 bits of result
                    next_state <= st_init;     // Return to initial state
                end
            endcase
        end
    end
endmodule
