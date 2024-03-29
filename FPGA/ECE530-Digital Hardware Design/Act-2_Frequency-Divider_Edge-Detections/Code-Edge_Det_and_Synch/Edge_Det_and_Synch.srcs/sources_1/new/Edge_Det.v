`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 09/13/2023 03:40:27 PM
// Design Name: 
// Module Name: Edge_Det
// Project Name: Assignment 02
// Target Devices: 
// Tool Versions: 
// Description: This module detects the rising and falling edges between two input signals, in_1 and in_2. 
//              A rising edge is detected when in_1 is high and in_2 is low, setting the 'rise' output high.
//              A falling edge is detected when in_1 is low and in_2 is high, setting the 'fall' output high.
//              In all other cases, both 'rise' and 'fall' outputs are set low.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Edge_Det(rise,fall,in_1,in_2);


    /*--------- Declare I/O --------------------------*/
    output reg rise;	// Output signal that goes high when a rising edge is detected
    output reg fall;	// Output signal that goes high when a falling edge is detected
    input in_1;			// First input signal
    input in_2;			// Second input signal

    /*--------- Declare internal registers --------------------------*/
    reg [1:0] concat; // Concatenated input signals for edge detection
    
    /*--------- Edge Detection Logic --------------------------*/
    always @ (in_1 or in_2)
    begin
        concat = {in_1, in_2}; // Concatenate the input signals
        
        // Detect rising and falling edges based on the concatenated input signals
        case(concat)
            2'b10 :
            begin
                rise = 1'b1; // Rising edge detected
                fall = 1'b0; // No falling edge
            end
            2'b01 :
            begin
                rise = 1'b0; // No rising edge
                fall = 1'b1; // Falling edge detected
            end
            default :
            begin
                rise = 1'b0; // No rising edge
                fall = 1'b0; // No falling edge
            end
        endcase
    end

endmodule
