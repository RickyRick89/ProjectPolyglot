`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 11/29/2023 03:42:59 PM
// Design Name: 
// Module Name: AES_Cntr
// Project Name: AES Design
// Target Devices: 
// Tool Versions: 
// Description: Implements the control logic for AES encryption, processing plaintext
//              to ciphertext through various AES stages (initial round, NibbleSub,
//              ShiftRow, MixColumn, KeyAddition) as per the AES standard. Utilizes
//              a finite state machine for sequencing through encryption rounds.
// 
// Dependencies: Functions.sv, Mix_Column.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AES_Cntr(ciph_txt, dn, pln_txt, key_in, IV, rnds, ld, clk, n_rst);
    `include "../../sources_1/new/Functions.sv" // Include for cryptographic functions
    output reg [15:0] ciph_txt;  // Cipher text output
    output reg dn;              // Done signal
    input [15:0] pln_txt;       // Plain text input
    input [15:0] key_in;        // Input key
    input [15:0] IV;            // Initialization Vector
    input [3:0] rnds;           // Number of rounds
    input ld;                   // Load signal
    input clk;                  // Clock input
    input n_rst;                // Active low reset signal

    /*--------- Parameterized States for the FSM ---------*/
    // Define states for the AES encryption process
    parameter st_init         = 4'd1,
              st_r0           = 4'd2,
              st_nibblesub    = 4'd3,
              st_shiftrow     = 4'd4,
              st_mixcol_start = 4'd5,
              st_mixcol_wait  = 4'd6,
              st_keyadd       = 4'd7;

    reg [3:0] state;              // Current state of the FSM
    reg [15:0] result_buf;        // Buffer to store intermediate results
    reg [3:0] current_rnd;        // Counter for the current round
    reg [15:0] mc_in;             // Input for the Mix Column operation
    reg mc_ld;                    // Load signal for the Mix Column operation
    reg [15:0] prev_key;          // Buffer to store the previous key

    wire [15:0] w_mc_out;         // Output from the Mix Column module
    wire w_mc_dn;                 // Done signal from the Mix Column module

    // Instantiation of the Mix Column module
    Mix_Column mc (.d(w_mc_out), .dn(w_mc_dn), .ld(mc_ld), .c(mc_in), .clk(clk), .n_rst(n_rst));

    /*--------- Main Control Logic -----------------------*/
    // AES control logic executed on positive edge of clock or negative edge of reset
    always @ (posedge clk, negedge n_rst)
    begin
        if (n_rst == 1'b0)
        begin
            // Reset logic
            ciph_txt <= 0;
            current_rnd <= 0;
            mc_in <= 0;
            result_buf <= 0;
            prev_key <= 0;
            dn <= 0;
            mc_ld <= 0;
            state <= st_init;
        end
        else
        begin
            // State Machine Logic
            case (state)
                st_init:
                begin
                    // Initialization state
                    // Reset all outputs and internal buffers, and check for load signal
                    ciph_txt <= 0;
                    current_rnd <= 0;
                    mc_in <= 0;
                    prev_key <= 0;
                    result_buf <= 0;
                    dn <= 0;
                    mc_ld <= 0;
                    if (ld)
                    begin
                        result_buf <= pln_txt ^ IV; // Initial XOR with IV
                        state <= st_r0;
                    end
                end
                st_r0:
                begin
                    // First round state
                    // XOR with input key and move to NibbleSub
                    result_buf <= result_buf ^ key_in;
                    prev_key <= key_in;
                    state <= st_nibblesub;
                end
				st_nibblesub:
                begin
                    // Nibble Substitution state
                    // Apply the Nibble Substitution function to each 4-bit part of result_buf
                    current_rnd <= current_rnd + 1;
                    result_buf[3:0] <= Nibble_Sub(result_buf[3:0]);
                    result_buf[7:4] <= Nibble_Sub(result_buf[7:4]);
                    result_buf[11:8] <= Nibble_Sub(result_buf[11:8]);
                    result_buf[15:12] <= Nibble_Sub(result_buf[15:12]);
                    state <= st_shiftrow; // Move to Shift Row state
                end
                st_shiftrow:
                begin
                    // Shift Row state
                    // Apply the Shift Row function to result_buf
                    result_buf <= Shift_Row(result_buf);
                    // Check if current round is less than total rounds and decide next state
                    if (current_rnd < rnds)
                        state <= st_mixcol_start; // Move to start of Mix Column
                    else
                        state <= st_keyadd; // Move to Key Addition state
                end
                st_mixcol_start:
                begin
                    // Mix Column Start state
                    // Prepare data for Mix Column operation
                    mc_in <= result_buf; // Load result_buf into Mix Column input
                    mc_ld <= 1; // Set load signal for Mix Column
                    state <= st_mixcol_wait; // Move to Mix Column Wait state
                end
                st_mixcol_wait:
                begin
                    // Mix Column Wait state
                    // Wait for Mix Column operation to complete
                    mc_ld <= 0; // Clear load signal for Mix Column
                    if (w_mc_dn)
                    begin
                        result_buf <= w_mc_out; // Update result_buf with Mix Column output
                        state <= st_keyadd; // Move to Key Addition state
                    end
                end
				st_keyadd:
                begin
                    // Key addition state
                    // Perform key expansion and XOR with result buffer
                    prev_key <= K_Exp(prev_key, current_rnd);
                    if (current_rnd < rnds)
                    begin
                        result_buf <= result_buf ^ K_Exp(prev_key, current_rnd);
                        state <= st_nibblesub;
                    end
                    else
                    begin
                        ciph_txt <= result_buf ^ K_Exp(prev_key, current_rnd);
                        dn <= 1;
                        state <= st_init;
                    end
                end
            endcase
        end
    end
endmodule
