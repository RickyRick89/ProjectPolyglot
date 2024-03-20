`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/30/2023 05:43:01 PM
// Design Name: 
// Module Name: C
// Project Name: Assignmet 01, Part 3
// Target Devices: 
// Tool Versions: 
// Description: This module takes a 4-bit binary input as the address and returns a corresponding 4-bit binary output for the binary to BCD conversion process.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module C( data, addr);

    /*--------- Declare Module I/O --------------------------*/
    output reg [3:0] data; // Data output
    input [3:0] addr;       // Address input

    /*--------- Always block triggered by addr --------------------------*/
    always @ (addr)
    begin
        //Lookup table
        case (addr)
            /*--------- Define data for each address --------------------------*/
            4'b0000 : data = 4'b0000;
            4'b0001 : data = 4'b0001;
            4'b0010 : data = 4'b0010;
            4'b0011 : data = 4'b0011;
            4'b0100 : data = 4'b0100;
            4'b0101 : data = 4'b1000;
            4'b0110 : data = 4'b1001;
            4'b0111 : data = 4'b1010;
            4'b1000 : data = 4'b1011;
            4'b1001 : data = 4'b1100;
            default : data = 4'b1111;  // Default value
        endcase
    end
endmodule