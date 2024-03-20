`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 02:30:07 PM
// Design Name: 
// Module Name: tb_Shift_Row
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_Shift_Row();
    `include "../../sources_1/new/Functions.sv"
    reg [15:0] b;
    wire [15:0] shifted_row;

    assign shifted_row = Shift_Row(b);

    initial begin
        b = 16'h1234;
        #10;
        $display("Input: %h, Shifted Output: %h", b, shifted_row);
        
        $finish;
    end
endmodule
