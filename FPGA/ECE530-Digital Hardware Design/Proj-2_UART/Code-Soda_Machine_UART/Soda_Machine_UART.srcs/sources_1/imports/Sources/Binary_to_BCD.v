`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 02:19:44 PM
// Design Name: 
// Module Name: Binary_to_BCD
// Project Name: Assignmet 01, Part 3
// Target Devices: 
// Tool Versions: 
// Description: This module is designed to convert 8-bit binary inputs to 10-bit Binary-Coded Decimal (BCD) outputs.
//              This module utilizes multiple instances of the "C" module to process a segment of the binary input, and the outputs are then concatenated to form the final BCD output.
// 
// Dependencies: C.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Binary_to_BCD( bcd, bin);

    /*--------- Declare Module I/O --------------------------*/
    output reg [9:0] bcd; // BCD output
    input [7:0] bin;       // Binary input
    
    /*--------- Declare internal wires --------------------------*/
    wire [3:0] w_c1_out, w_c2_out, w_c3_out, w_c4_out, w_c5_out, w_c6_out, w_c7_out;
    
    /*--------- Instantiate multiple C modules for conversion --------------------------*/
    C c1 (.data(w_c1_out), .addr({0,bin[7],bin[6],bin[5]}));
    C c2 (.data(w_c2_out), .addr({w_c1_out[2],w_c1_out[1],w_c1_out[0],bin[4]}));
    C c3 (.data(w_c3_out), .addr({w_c2_out[2],w_c2_out[1],w_c2_out[0],bin[3]}));
    C c4 (.data(w_c4_out), .addr({w_c3_out[2],w_c3_out[1],w_c3_out[0],bin[2]}));
    C c5 (.data(w_c5_out), .addr({w_c4_out[2],w_c4_out[1],w_c4_out[0],bin[1]}));
    C c6 (.data(w_c6_out), .addr({0,w_c1_out[3],w_c2_out[3],w_c3_out[3]}));
    C c7 (.data(w_c7_out), .addr({w_c6_out[2],w_c6_out[1],w_c6_out[0],w_c4_out[3]}));
    
    /*--------- Always block for BCD output --------------------------*/
    always @(*)
    begin
        // Concatenate outputs to form BCD
        bcd = {w_c6_out[3], w_c7_out, w_c5_out, bin[0]};
    end
endmodule
