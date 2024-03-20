`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 02:41:40 PM
// Design Name: 
// Module Name: tb_Mix_Column
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


module tb_Mix_Column();
    // Inputs
    reg [15:0] input_data;
    reg ld;
    reg clk;
    reg n_rst;

    // Output
    wire [15:0] output_data;
    wire data_ready;

    // Instantiate the Mix_Column module
    Mix_Column uut (
        .c(input_data), 
        .ld(ld),
        .clk(clk), 
        .n_rst(n_rst), 
        .d(output_data),
        .dn(data_ready)
    );

    // Clock generation
    always #1 clk = ~clk; // Generate a clock with a period of 10ns

    initial begin
        // Initialize Inputs
        clk = 0;
        n_rst = 0;
        ld = 0;
        input_data = 0;

        // Reset the module
        #20;
        n_rst = 1;
        #20;

        // Apply test cases
        input_data = 16'h1234;
        ld = 1;
        #4;
        ld = 0;
        wait(data_ready);
        #20;
        $display("Test Case 1: Input: %h, Output: %h", input_data, output_data);

        $finish;
    end

endmodule
