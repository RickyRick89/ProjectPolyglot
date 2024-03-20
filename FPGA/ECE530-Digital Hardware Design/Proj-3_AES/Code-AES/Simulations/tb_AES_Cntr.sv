`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Richard Groves
// 
// Create Date: 12/04/2023 12:09:13 PM
// Design Name: 
// Module Name: tb_AES_Cntr
// Project Name: AES Design
// Target Devices: 
// Tool Versions: 
// Description: Testbench for validating the AES Control (AES_Cntr) module. Simulates the
//              AES encryption process using input test vectors and checks the output
//              ciphertext for correctness.
// 
// Dependencies: AES_Cntr.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_AES_Cntr();

    /*--------- Declare Registers --------------------------*/
    reg [15:0] pln_txt;   // Plaintext input register
    reg [15:0] key_in;    // Key input register
    reg [15:0] IV;        // Initialization Vector register
    reg [3:0] rnds;       // Number of AES rounds
    reg ld;               // Load signal
    reg clk;              // Clock signal
    reg n_rst;            // Active low reset signal

    /*--------- Declare Wires ------------------------------*/
    wire [15:0] ciph_txt; // Ciphertext output wire
    wire dn;              // Done signal wire

    integer fd;           // File descriptor for IO operations

    /*--------- Parameter Definitions ----------------------*/
    parameter period = 2; // Clock period definition

    /*--------- UUT Instantiation --------------------------*/
    AES_Cntr uut (
        .ciph_txt(ciph_txt),
        .dn(dn),
        .pln_txt(pln_txt),
        .key_in(key_in),
        .IV(IV),
        .rnds(rnds),
        .ld(ld),
        .clk(clk),
        .n_rst(n_rst)
    );

    /*--------- Clock Generation ---------------------------*/
    // Generate clock signal
    always #(period/2) clk = ~clk;

    /*--------- Test Procedure -----------------------------*/
    initial begin
        // Initialize Inputs
        clk = 0;
        n_rst = 0;
        ld = 0;
        #period;
        n_rst = 1; // Release reset
        #period;

        // Read test vectors from file
        fd = $fopen("test.txt", "r"); // Open the test file for reading
        $fscanf(fd, "%h", pln_txt);
        $fscanf(fd, "%h", key_in);
        $fscanf(fd, "%h", IV);
        $fscanf(fd, "%d", rnds);

        ld = 1; // Set load signal

        #period;
        $fclose(fd); // Close the input file
        ld = 0;

        // Wait for encryption to complete
        wait(dn == 1);
        fd = $fopen("results.txt", "w");
        $fwrite(fd, "%h", ciph_txt); // Write the ciphertext to the output file
        $fclose(fd); // Close the output file
        #(period*2);

        // End the simulation
        $finish;
    end

endmodule
