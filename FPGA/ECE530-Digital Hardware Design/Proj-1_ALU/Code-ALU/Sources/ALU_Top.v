`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/25/2023 10:32:35 AM
// Design Name: ALU Top Module
// Module Name: ALU_Top
// Project Name: Project 01 - ALU Design
// Target Devices: 
// Tool Versions: 
// Description: Top module integrating various ALU components and handling user input through push buttons and switches.
// Dependencies: freq_div, edge_det_and_synch, alu
// Revision: 0.01
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module ALU_Top(led, sw, pb, clk);

    /*--------- Declare I/O --------------------------*/
    output [3:0] led;           // LED output
    input [3:0] sw;             // Switch input
    input [3:0] pb;             // Push button input
    input clk;                  // Clock input

    /*--------- Declare internal registers --------------------------*/
    reg [3:0] a;                // Operand 'a'
    reg [3:0] b;                // Operand 'b'
    reg [4:0] w_led_mux;        // LED multiplexer

    /*--------- Declare internal wires --------------------------*/
    wire w_n_rst;               // Not reset
    wire w_clock_25khz_out;     // 25kHz clock output from the frequency divider
    wire w_pb1_rise;            // Detect rising edge of push button 1
    wire w_pb1_fall;            // Detect falling edge of push button 1
    wire w_pb2_rise;            // Detect rising edge of push button 2
    wire w_pb2_fall;            // Detect falling edge of push button 2
    wire w_pb3_rise;            // Detect rising edge of push button 3
    wire w_pb3_fall;            // Detect falling edge of push button 3
    wire [3:0] w_alu_out;       // ALU output
    wire w_carry_sgn_out;       // Carry or sign bit output from ALU

    /*--------- Instantiate modules --------------------------*/
    // Instantiating 25kHz frequency divider
    freq_div #(13,5000) freq_div_25khz (.clkout(w_clock_25khz_out), .clkin(clk), .n_rst(w_n_rst));
    // Instantiating edge detectors and synchronizers for push buttons 1, 2, and 3
    edge_det_and_synch pb1_edge_to_pulse (.Rise(w_pb1_rise), .Fall(w_pb1_fall), .Clock_in(w_clock_25khz_out), .n_rst(w_n_rst), .Sig(pb[1]));
    edge_det_and_synch pb2_edge_to_pulse (.Rise(w_pb2_rise), .Fall(w_pb2_fall), .Clock_in(w_clock_25khz_out), .n_rst(w_n_rst), .Sig(pb[2]));
    edge_det_and_synch pb3_edge_to_pulse (.Rise(w_pb3_rise), .Fall(w_pb3_fall), .Clock_in(w_clock_25khz_out), .n_rst(w_n_rst), .Sig(pb[3]));
    // Instantiating ALU module with 4-bit width
    alu #(4) alu_1 (.out(w_alu_out), .carry_sgn(w_carry_sgn_out), .a(a), .b(b), .sel(sw));

    /*--------- Logic operations --------------------------*/
    assign w_n_rst = ~pb[0];
    assign led = (sw[3] == 1'b0) ? w_led_mux[3:0] : {3'b000, w_led_mux[4]};

    /*--------- Always block handling push-button operations and LED output --------------------------*/
    always @(negedge w_clock_25khz_out, negedge w_n_rst)
    begin
        if (w_n_rst == 1'b0)
        begin
            a = 4'b0000;
            b = 4'b0000;
            w_led_mux = 5'b00000;
        end
        else
        begin
            if (w_pb1_rise == 1'b1)
                a = sw;
            if (w_pb2_rise == 1'b1)
                b = sw;
            if (w_pb3_rise == 1'b1)
                w_led_mux = {w_carry_sgn_out, w_alu_out};
        end
    end

endmodule
