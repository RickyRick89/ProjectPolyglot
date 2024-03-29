`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 02:19:44 PM
// Design Name: 
// Module Name: mux_2w_to_1w
// Project Name: Activity 01, Part 2
// Target Devices: 
// Tool Versions: 
// Description: 2 to 1 mux module
// 
// Dependencies: None
// 
// Revision: 0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mux_2w_to_1w(
    output reg [2:0] out, // Output data
    input [2:0] a,        // First input
    input [2:0] b,        // Second input
    input sel             // Selector
);

    // Always block for mux logic
    always @ (a, b, sel)
    begin
        if (sel) out = b;
        else out = a;
    end
    
endmodule
