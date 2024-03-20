`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 10/04/2023 04:55:00 PM
// Design Name: Soda Machine Datapath
// Module Name: soda_machine_datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module describes the datapath for a soda machine system. It performs arithmetic operations
//              to manage the total value and compares it against a set value.
// Dependencies:n_bit_adder
//				n_bit_compare
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module soda_machine_datapath(tot_lt_s,tot,chng,s,a,tot_ld,tot_clr,clkin,n_rst);

    /*--------- Declare I/O --------------------------*/
    output tot_lt_s;         // Output indicating if total is less than set value
    output reg [7:0] tot;    // Total value
    output [7:0] chng;    
    input [7:0] s;           // Set value against which total is compared
    input [7:0] a;           // Value to be added to the total
    input tot_ld;            // Load control signal for total
    input tot_clr;           // Clear control signal for total
    input clkin;             // Clock input
    input n_rst;             // Active-low reset signal

    /*--------- Declare registers --------------------------*/
	reg chng_done;

    /*--------- Declare internal wires --------------------------*/
    wire w_gt;               // Greater than output from comparator
    wire w_eq;               // Equal output from comparator
    wire w_lt;               // Less than output from comparator
    wire [7:0] w_tot_new;    // New total value after addition
    wire [7:0] w_chng;    
	wire w_chng_sgn;

    /*--------- Instantiate Adder and Comparator --------------------------*/
    n_bit_adder #(8) add_tot (.s (w_tot_new), .a (tot), .b (a), .cin (1'b0)); // 8-bit adder
    n_bit_compare #(8) comp (.gt_out(w_gt), .eq_out(w_eq), .lt_out(w_lt), .a(tot), .b(s)); // 8-bit comparator
	n_bit_sub #(8) sub (.sub(w_chng),.sgn(w_chng_sgn), .a(tot), .b(s));

    /*--------- Assignments --------------------------*/
    assign tot_lt_s = w_lt;  // Assign the less-than output to tot_lt_s
	assign chng = (w_chng_sgn==1'b0) ? w_chng:
									   8'd0;

    /*--------- Logic --------------------------*/
    always @ (posedge clkin, negedge n_rst)
    begin
        if (n_rst == 1'b0)
        begin
            tot <= 8'd0;   // Reset total value
        end
        else
        begin
            if (tot_ld == 1'b1)
            begin
                tot <= w_tot_new; // Load new total value
            end
            if (tot_clr == 1'b1)
            begin
                tot <= 8'd0; // Clear total value
            end
        end
    end

endmodule
