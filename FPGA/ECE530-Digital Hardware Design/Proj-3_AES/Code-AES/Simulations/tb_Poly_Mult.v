`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 11/22/2023 02:55:24 PM
// Design Name: 
// Module Name: tb_Poly_Mult
// Project Name: AES Design
// Target Devices: 
// Tool Versions: 
// Description: Testbench for validating the Polynomial Multiplication (Poly_Mult) function
//              used in the AES encryption process. This module simulates the function and
//              checks its outputs to ensure correct polynomial multiplication functionality.
// 
// Dependencies: Poly_Mult.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_Poly_Mult();

    /*--------- Test Signals -----------------------------*/
    reg clk;           // Clock signal
    reg n_rst;         // Active low reset signal
    reg ld;            // Load signal for triggering the polynomial multiplication

    /*--------- Output Wires from Poly_Mult --------------*/
    wire [7:0] w_out;  // Output of the polynomial multiplication
    wire w_dn;         // Done signal indicating completion of operation

    /*--------- Testbench Parameters ---------------------*/
    parameter period = 2; // Clock period definition

    /*--------- Poly_Mult Instance -----------------------*/
    // Instantiate the Polynomial Multiplication module
    Poly_Mult pm (.out(w_out), .dn(w_dn), .multr(8'h0D), .multnd(4'h9), .ld(ld), .clk(clk), .n_rst(n_rst));

    /*--------- Test Sequence ----------------------------*/
    initial
    begin  
        // Initialize load and reset signals
        ld = 1'b0;
        n_rst = 1'b1;
        # (6*period); // Wait for some cycles
        n_rst = 1'b0; // Trigger reset
        # (6*period); // Wait for some cycles
        n_rst = 1'b1; // Release reset
        # (6*period); // Wait for some cycles
        ld = 1'b1; // Set load signal to start polynomial multiplication
        wait(w_dn == 1); // Wait for the done signal
        #10;
        // End the simulation
        $finish;
    end

    /*--------- Clock Generation -------------------------*/
    initial
    begin
        clk = 1'b0; // Initialize clock
        forever
        begin
            clk = ~clk; // Toggle clock
            # (period/2); // Wait for half period
        end
    end

endmodule
