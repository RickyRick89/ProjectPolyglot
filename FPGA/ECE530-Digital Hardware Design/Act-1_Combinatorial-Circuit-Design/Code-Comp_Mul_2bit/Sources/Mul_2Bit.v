`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 02:19:44 PM
// Design Name: 
// Module Name: Mul_2bit
// Project Name: Activity 01, Part 2
// Target Devices: 
// Tool Versions: 
// Description: This multiplier ROM stores predefined results of 2-bit unsigned number multiplications.
// 
// Dependencies: None
// 
// Revision: 0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Mul_2bit( data, addr);
    /*--------- Declare Module I/O --------------------------*/
    output reg [3:0] data;  // Output data after multiplication
    input [3:0] addr;       // Input address, addr = {B[1],B[0],A[1],A[0]}
    
    // Always block for multiplication logic
    always @(addr)
    begin
        case (addr)
            4'b0000 : data = 4'b0000;
            4'b0001 : data = 4'b0000;
            4'b0010 : data = 4'b0000;
            4'b0011 : data = 4'b0000;
            4'b0100 : data = 4'b0000;
            4'b0101 : data = 4'b0001;
            4'b0110 : data = 4'b0010;
            4'b0111 : data = 4'b0011;
            4'b1000 : data = 4'b0000;
            4'b1001 : data = 4'b0010;
            4'b1010 : data = 4'b0100;
            4'b1011 : data = 4'b0110;
            4'b1100 : data = 4'b0000;
            4'b1101 : data = 4'b0011;
            4'b1110 : data = 4'b0110;
            4'b1111 : data = 4'b1001;
            default : data = 4'b0000;
        endcase
    end

endmodule
