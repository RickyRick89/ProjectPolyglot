`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 10/04/2023 05:37:52 PM
// Design Name: Soda Machine Finite State Machine
// Module Name: soda_machine_fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module defines the finite state machine (FSM) for the soda machine system. 
//              The FSM determines the control flow based on user input and internal logic.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module soda_machine_fsm(d, tot_ld, tot_clr, tot_lt_s, c, clkin, n_rst);

    /*--------- Declare I/O --------------------------*/
    output reg d;          // Output signal to dispense soda
    output reg tot_ld;     // Load control signal for total value
    output reg tot_clr;    // Clear control signal for total value
    input tot_lt_s;        // Input signal indicating if total is less than set value
    input c;               // Control input for FSM
    input clkin;           // Clock input
    input n_rst;           // Active-low reset signal

    /*--------- Internal Registers --------------------------*/
    reg [3:0] state, next_state;  // Current and next state registers

    /*--------- FSM State Parameters --------------------------*/
    parameter   st_init    = 4'b0001,  // Initialization state
                st_wait    = 4'b0010,  // Waiting for user input
                st_add     = 4'b0100,  // Add value to total
                st_disp    = 4'b1000;  // Dispense soda

    // FSM State Register
    always @(negedge clkin, negedge n_rst)
    begin
        if (n_rst == 1'b0)
            state <= st_init;  // Reset to initial state
        else
            state <= next_state;  // Move to the next determined state
    end
    
    // Next State Logic
    always @(posedge clkin, negedge n_rst)
    begin
        if (n_rst == 1'b0)
            next_state <= st_init;  // Reset to initial state
        else
        begin
            case (state)
            st_init:
                next_state <= st_wait;  // Move to wait state after initialization
            st_wait:
                if (c == 1'b1)
                    next_state <= st_add;  // Add value to total on control signal
                else if (tot_lt_s == 1'b0)
                    next_state <= st_disp;  // Dispense soda if total meets criteria
                else
                    next_state <= st_wait;  // Stay in wait otherwise
            st_add:
                next_state <= st_wait;  // Return to wait state after adding
            st_disp:
                next_state <= st_init;  // Return to initial state after dispensing
            endcase 
        end
    end
    
    // Output Logic based on Current State
    always @(state)
    begin
        case (state)
        st_init:
        begin
            d <= 1'b0;          // No dispense
            tot_ld <= 1'b0;    // No load
            tot_clr <= 1'b1;   // Clear total value
        end
        st_wait:
        begin
            d <= 1'b0;          // No dispense
            tot_ld <= 1'b0;    // No load
            tot_clr <= 1'b0;   // No clear
        end
        st_add:
        begin
            d <= 1'b0;          // No dispense
            tot_ld <= 1'b1;    // Load total value
            tot_clr <= 1'b0;   // No clear
        end
        st_disp:
        begin
            d <= 1'b1;          // Dispense soda
            tot_ld <= 1'b0;    // No load
            tot_clr <= 1'b0;   // No clear
        end
        default:  // Default behavior (Safe behavior in unexpected states)
        begin
            d <= 1'b0;          // No dispense
            tot_ld <= 1'b0;    // No load
            tot_clr <= 1'b0;   // No clear
        end
        endcase 
    end    

endmodule
