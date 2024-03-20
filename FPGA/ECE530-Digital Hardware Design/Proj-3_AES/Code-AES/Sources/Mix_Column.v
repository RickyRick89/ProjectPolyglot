`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 11/23/2023 09:16:07 AM
// Design Name: 
// Module Name: Mix_Column
// Project Name: AES Design
// Target Devices: 
// Tool Versions: 
// Description: Implements the Mix Column operation for AES encryption. It performs
//              polynomial multiplication on the input data using a finite state machine.
// 
// Dependencies: Poly_Mult.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module Mix_Column(d,dn,ld,c,clk,n_rst);
	 // Output and input declarations
    output reg [15:0] d;  // Output data after Mix Column operation
    output reg dn;        // Done signal to indicate completion of operation
    input ld;             // Load signal to start the Mix Column process
    input [15:0] c;       // 16-bit input data for the Mix Column operation
    input clk;            // Clock signal
    input n_rst;          // Active low reset signal

    /*--------- Constants Definition ----------------------*/
    parameter [3:0] const0 = 4'd3, const1 = 4'd2, const2 = 4'd2, const3 = 4'd3;
    
    /*--------- Define FSM states --------------------------*/
    // Finite State Machine (FSM) states for controlling the operation
    parameter	st_init = 4'd1,
				st_wait = 4'd2;

    // State control registers
    reg [3:0] state, next_state;  // Registers to hold the current and the next state
    reg pm_ld;                    // Load signal for polynomial multiplication modules

    /*--------- Wires and Interconnections ----------------*/
    wire pm00_dn, pm01_dn, pm10_dn, pm11_dn, pm20_dn, pm21_dn, pm30_dn, pm31_dn;
    wire [7:0] pm00_out, pm01_out, pm10_out, pm11_out, pm20_out, pm21_out, pm30_out, pm31_out;

    /*--------- Polynomial Multiplier Instantiations ------*/
    // Each module performs a part of the Mix Column operation for AES
    Poly_Mult pm00 (.out(pm00_out), .dn(pm00_dn), .multr(c[15:12]), .multnd(const0), .ld(pm_ld), .clk(clk), .n_rst(n_rst));
    Poly_Mult pm01 (.out(pm01_out), .dn(pm01_dn), .multr(c[11:8]), .multnd(const1), .ld(pm_ld), .clk(clk), .n_rst(n_rst));
	
	Poly_Mult pm10 (.out(pm10_out),.dn(pm10_dn),.multr(c[15:12]),.multnd(const2),.ld(pm_ld),.clk(clk),.n_rst(n_rst));
	Poly_Mult pm11 (.out(pm11_out),.dn(pm11_dn),.multr(c[11:8]),.multnd(const3),.ld(pm_ld),.clk(clk),.n_rst(n_rst));	
	
	Poly_Mult pm20 (.out(pm20_out),.dn(pm20_dn),.multr(c[7:4]),.multnd(const0),.ld(pm_ld),.clk(clk),.n_rst(n_rst));
	Poly_Mult pm21 (.out(pm21_out),.dn(pm21_dn),.multr(c[3:0]),.multnd(const1),.ld(pm_ld),.clk(clk),.n_rst(n_rst));
	
	Poly_Mult pm30 (.out(pm30_out),.dn(pm30_dn),.multr(c[7:4]),.multnd(const2),.ld(pm_ld),.clk(clk),.n_rst(n_rst));
	Poly_Mult pm31 (.out(pm31_out),.dn(pm31_dn),.multr(c[3:0]),.multnd(const3),.ld(pm_ld),.clk(clk),.n_rst(n_rst));
	
    /*--------- FSM State Update Logic --------------------*/
    // Logic for updating the FSM states based on the clock and reset signal
    always @ (negedge clk, negedge n_rst)
    begin
        // Reset logic
        if (n_rst == 1'b0)
        begin
            // On reset, set the FSM to the initial state
            state <= st_init;
            next_state <= st_init;
        end
        else
            // Otherwise, move to the next state
            state <= next_state;
    end

    /*--------- FSM Main Logic ----------------------------*/
    // Main logic of the FSM, executed on the positive edge of the clock or negative edge of the reset signal
    always @ (posedge clk, negedge n_rst)
    begin
        // Reset logic
        if (n_rst == 1'b0)
        begin
            // On reset, initialize the next state, load signal, and done signal
            next_state <= st_init;
            pm_ld <= 0;
            dn <= 0;
        end
        else
        begin
            // FSM case statement for different states
            case (state)
                st_init:
                begin
                    // Initialization state
                    // Clear output data and done signal
                    d <= 0;
                    dn <= 0;
                    // If load signal is high, start polynomial multiplication
                    if (ld)
                    begin
                        pm_ld <= 1;  // Set load signal for polynomial multiplication
                        next_state <= st_wait;  // Move to wait state
                    end
                end
                st_wait:
                begin
                    // Wait state
                    pm_ld <= 0;  // Clear load signal for polynomial multiplication
                    // Check if all polynomial multiplication modules are done
                    if (pm00_dn && pm01_dn && pm10_dn && pm11_dn && pm20_dn && pm21_dn && pm30_dn && pm31_dn)
                    begin
                        // Combine the outputs of the polynomial multiplication modules
                        d[3:0] <= pm30_out ^ pm31_out;
                        d[7:4] <= pm20_out ^ pm21_out;
                        d[11:8] <= pm10_out ^ pm11_out;
                        d[15:12] <= pm00_out ^ pm01_out;
                        dn <= 1;  // Set done signal
                        next_state <= st_init;  // Return to the initial state for the next operation
                    end
                end
            endcase
        end
    end
endmodule