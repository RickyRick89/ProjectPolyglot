`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2023 10:37:37 AM
// Design Name: 
// Module Name: tb_ALU_Top
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


module tb_ALU_Top;

    reg clk;
    reg [3:0] pb;
    reg [3:0] sw;
    reg [4:0] i; 
    wire [3:0] led;

    // Instantiate the ALU_Top module
    ALU_Top uut (
        .clk(clk),
        .pb(pb),
        .sw(sw),
        .led(led)
    );

    // Clock generation
    always begin
        #1 clk = ~clk; // Assuming a 10ns period for simplicity
    end
    
    // Testbench stimulus
    initial begin
        // Initialize signals
        clk = 0;
        pb = 4'b0000;
        sw = 4'b0000;

        // Test reset functionality
        pb[0] = 1;
        #10;
        pb[0] = 0;
        #10;
        
        // Wait for a few clock cycles
        #15;


        // Test different ALU operations using switches
        // Assuming sw[2:0] determines the ALU operation and sw[3] determines LED output
        for (i = 0; i < 8; i = i + 1) begin
            sw[2:0] = i;

            // Simulate push button presses
            pb[1] = 1; #12000; pb[1] = 0; #10;
            pb[2] = 1; #12000; pb[2] = 0; #10;
            pb[3] = 1; #12000; pb[3] = 0; #10;
        end

        // Finish the simulation
        $finish;
    end

endmodule

