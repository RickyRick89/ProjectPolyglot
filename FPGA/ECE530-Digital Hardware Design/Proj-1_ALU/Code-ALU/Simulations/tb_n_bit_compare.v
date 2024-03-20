`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2023 12:54:07 PM
// Design Name: 
// Module Name: tb_n_bit_compare
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


module tb_n_bit_compare();

    /*--------- Declare registers --------------------------*/
    reg [3:0] i1;       
    reg [3:0] i2;       
    reg [3:0] tb_a;    
    reg [3:0] tb_b;          
    
    /*--------- Declare internal wires --------------------------*/
    wire tb_gt_out;
    wire tb_eq_out;
    wire tb_lt_out;

    parameter period=10; // Time period for each test vector
    
    // Instantiate a 2-bit full adder
    n_bit_compare #(4) uut(.gt_out(tb_gt_out),.eq_out(tb_eq_out),.lt_out(tb_lt_out),.a(tb_a),.b(tb_b));
    
    initial
        // Do nothing
    begin
        for (i1 = 0; i1 < 15; i1 = i1 + 1)
        begin
            tb_a = i1;
            for (i2 = 0; i2 < 15; i2 = i2 + 1)
            begin
                tb_b = i2;
                # period; // wait
            end
        end
        
        # (period*5) $stop; // stop the simulation
    end


endmodule
