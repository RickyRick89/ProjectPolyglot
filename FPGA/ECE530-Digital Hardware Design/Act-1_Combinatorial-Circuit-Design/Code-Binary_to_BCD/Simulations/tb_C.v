`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/30/2023 05:48:23 PM
// Design Name: 
// Module Name: tb_C
// Project Name: Assignmet 01, Part 3
// Target Devices: 
// Tool Versions: 
// Description: This testbench module is designed to evaluate the correctness of the "C" module, a component of converting binary to BCD.
//              It loops through all possible 4-bit addresses (ranging from 0 to 15).
// 
// Dependencies: C.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_C();
    /*--------- Declare registers and wires --------------------------*/
    reg [4:0] i;
    reg [3:0] addr;
    wire [3:0] w_data;
    
    /*--------- Declare simulation period --------------------------*/
    parameter period=10;
    
    /*--------- Instantiate the unit under test (uut) --------------------------*/
    C uut (.data(w_data), .addr(addr));
    
    /*--------- Initial block for simulation --------------------------*/
    initial					 
    begin
        // Loop through all possible addresses
        for (i = 0; i <= 15; i = i + 1)
        begin
            addr = i;  // Set the address
            # period;  // Wait for 'period' time units
        end
        
        // Stop the simulation after 5*'period' time units
        # (period*5) $stop;
    end
endmodule
