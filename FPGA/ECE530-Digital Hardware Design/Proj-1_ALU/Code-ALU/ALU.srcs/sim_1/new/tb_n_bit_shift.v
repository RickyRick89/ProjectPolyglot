`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2023 08:47:00 AM
// Design Name: 
// Module Name: tb_n_bit_shift
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


module tb_n_bit_shift;

    /*--------- Declare registers --------------------------*/
    reg [4:0] i;       // Loop index for running through test vectors
    reg [4:0] tb_in;        
    reg [4:0] tb_pass_back;
    reg right;

    /*--------- Declare internal wires --------------------------*/
    wire [4:0] tb_out;      // Carry-out bit from the 2-bit full adder

    parameter period=10; // Time period for each test vector
    
    n_bit_shift #(5) uut(.out(tb_out),.in(tb_in),.right(right));
    
    initial
    begin
        tb_pass_back = 5'b11010;
        
        for (i = 0; i < 31; i = i + 1)
        begin
            if (i <= 15)
                right = 1'b0;
            else
                right = 1'b1;
            
            tb_in <= tb_pass_back;
            #period; // Introduce delay before capturing the output
            tb_pass_back <= tb_out;
            # period; // wait
        end
        
        # (period*5) $stop; // stop the simulation
    end
    
endmodule
