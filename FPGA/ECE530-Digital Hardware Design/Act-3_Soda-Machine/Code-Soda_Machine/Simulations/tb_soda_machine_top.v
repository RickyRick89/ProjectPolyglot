`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2023 02:34:33 PM
// Design Name: 
// Module Name: tb_soda_machine_top
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


module tb_soda_machine_top();
    /*--------- Declare registers --------------------------*/
    reg [4:0] i; 
	reg clk;
    reg [7:0] s;  
    reg [7:0] a;  
    reg n_rst;  
	reg c;
    
    /*--------- Declare internal wires --------------------------*/
	wire w_d;
	wire [7:0] w_chng;
	wire [7:0] w_tot;

    parameter 	period	=	10, // Time period for each test vector
				nickel	=	5,
				dime	=	10,
				quarter	=	25;
	
	
	soda_machine_top uut (.d(w_d),.tot(w_tot),.chng(w_chng),.s(s),.a(a),.c(c),.clkin(clk),.n_rst(n_rst));
	
    initial
    begin
		clk = 1'b0;
		forever
		begin
			clk = ~clk;
			# (period/2); // wait
		end
    end
	
	initial
	begin
		n_rst = 1'b1;
        # (2+period/2); // wait
		n_rst = 1'b0;
        # (period); // wait
		n_rst = 1'b1;
	end
	
	initial
	begin
		c = 1'b0;
		s = 150;
        # (period*3); // wait
		# (2)
        for (i = 0; i < 5; i = i + 1)
        begin
			a = quarter;
			c = 1'b1;
			# (period); // wait
			c = 1'b0;
			# (period*4); // wait
		end
        for (i = 0; i < 5; i = i + 1)
        begin
			a = dime;
			c = 1'b1;
			# (period); // wait
			c = 1'b0;
			# (period*4); // wait
		end
        for (i = 0; i < 3; i = i + 1)
        begin
			a = nickel;
			c = 1'b1;
			# (period); // wait
			c = 1'b0;
			# (period*4); // wait
		end
		
		c = 1'b0;
		s = 200;
        # (period*4); // wait
		n_rst = 1'b0;
        # (period); // wait
		n_rst = 1'b1;
        # (period); // wait
        for (i = 0; i < 4; i = i + 1)
        begin
			a = quarter;
			c = 1'b1;
			# (period); // wait
			c = 1'b0;
			# (period*4); // wait
		end
        for (i = 0; i < 10; i = i + 1)
        begin
			a = dime;
			c = 1'b1;
			# (period); // wait
			c = 1'b0;
			# (period*4); // wait
		end
        for (i = 0; i < 10; i = i + 1)
        begin
			a = nickel;
			c = 1'b1;
			# (period); // wait
			c = 1'b0;
			# (period*4); // wait
		end
	end
	
endmodule
