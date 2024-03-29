`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 03:03:50 PM
// Design Name: 
// Module Name: Binary_to_BCD_Mux
// Project Name: Assignmet 01, Part 3
// Target Devices: 
// Tool Versions: 
// Description: This module functions as a board-level module that integrates the functionalities of binary to BCD conversion and multiplexing.
//              It takes an 8-bit binary input and a 2-bit selector input to produce a 4-bit output that is intended to drive LEDs.
//              The 4-bit output is a binary representation of each decimal (ones, tens, hundreds).
// 
// Dependencies: Mux_2x4.v, Binary_to_BCD.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Binary_to_BCD_Board( leds, bin, sel);

    /*--------- Declare Module I/O --------------------------*/
    output reg [3:0] leds;  // Output to LEDs
    input [7:0] bin;        // Binary input
    input [1:0] sel;         // Selector for multiplexer
    
    /*--------- Declare internal wires --------------------------*/
    wire [9:0] w_bcd;       // BCD output from Binary_to_BCD module
    wire [3:0] w_mux1_out;  // Output from the 2x4 multiplexer
    
    /*--------- Instantiate Binary_to_BCD and Mux_2x4 modules --------------------------*/
    Binary_to_BCD bin2bcd (.bcd(w_bcd), .bin(bin));
    Mux_2x4 mux1 (.out(w_mux1_out), .a({w_bcd[3],w_bcd[2],w_bcd[1],w_bcd[0]}), .b({w_bcd[7],w_bcd[6],w_bcd[5],w_bcd[4]}), .c({0,0,w_bcd[9],w_bcd[8]}), .d(4'b0000), .sel(sel));
    
    /*--------- Always block to drive LEDs --------------------------*/
    always @(bin, sel)
    begin
        leds = w_mux1_out;  // Update LED outputs
    end
endmodule
