`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 08/31/2023 02:19:44 PM
// Design Name: 
// Module Name: tb_Comp_Mul_2bit
// Project Name: Activity 01, Part 2
// Target Devices: 
// Tool Versions: 
// Description: This testbench module employs a loop structure to iterate through all possible input combinations for the Comp_Mul_2bit module.
// 
// Dependencies: Comp_Mul_2bit.v
// 
// Revision: 0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TB_Comp_Mul_2bit();

    reg [5:0] i;          // Loop index
    reg [1:0] tb_a;       // First 2-bit input for testbench
    reg [1:0] tb_b;       // Second 2-bit input for testbench
    reg tb_sel;           // Selector for testbench
    wire [2:0] tb_out;    // Output from UUT

    parameter period=10;  // Simulation time for each test vector
    
    // Instantiate the unit under test (UUT)
    Comp_Mul_2bit uut(.out (tb_out), .a (tb_a), .b (tb_b), .sel (tb_sel));
    
    initial
        // Do nothing
    begin
        for (i = 0; i <= 31; i = i + 1)
        begin
            {tb_sel, tb_a, tb_b} = i;
            # period; // wait
        end
        
        # (period*5) $stop; // stop the simulation
    end
    
endmodule
