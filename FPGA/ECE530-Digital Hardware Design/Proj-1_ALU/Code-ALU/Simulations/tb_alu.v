`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
//
// Create Date: 09/25/2023 09:45:53 AM
// Design Name: tb_alu Testbench
// Module Name: tb_alu
// Project Name: Project 01 - ALU Design
// Target Devices: 
// Tool Versions: 
// Description: Testbench to test the ALU module.
//
// Dependencies: alu module
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_alu();

    /*--------- Declare Test Input Registers --------------------------*/
    reg [4:0] i1;        // Loop index for 'a' input testing
    reg [4:0] i2;        // Loop index for 'b' input testing
    reg [4:0] i3;        // Loop index for 'sel' input testing
    reg [3:0] tb_a;      // 'a' input to ALU
    reg [3:0] tb_b;      // 'b' input to ALU
    reg [3:0] tb_sel;    // 'sel' input to ALU

    /*--------- Declare ALU Outputs --------------------------*/
    wire [3:0] tb_out;      // ALU output
    wire tb_carry_sgn;      // ALU carry or sign flag

    // Test duration parameter
    parameter period=10;    // Time period for each test vector

    /*--------- Instantiate the ALU for Testing --------------------------*/
    alu #(4) uut (.out(tb_out), .carry_sgn(tb_carry_sgn), .a(tb_a), .b(tb_b), .sel(tb_sel));
    
    /*--------- Test Stimulus Logic --------------------------*/
    initial begin
        // Iterate through all possible combinations of a, b, and select inputs
        for (i1 = 0; i1 <= 15; i1 = i1 + 1) begin
            tb_a = i1;
            for (i2 = 0; i2 <= 15; i2 = i2 + 1) begin
                tb_b = i2;
                for (i3 = 0; i3 <= 15; i3 = i3 + 1) begin
                    tb_sel = i3;
                    # period; // Delay to let the ALU process inputs
                end
            end
        end
        
        # (period*5) $stop; // End the simulation
    end

endmodule
