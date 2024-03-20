

function [15:0] Shift_Row;
	input [15:0] b;
    // The Shift_Row function rearranges the 16-bit input 'b' into a new sequence.
    // This function is typically used in cryptographic applications for data scrambling.
    // The bits of 'b' are rearranged as follows:
    // - The first 4 bits (b[15:12]) remain in place.
    // - The next 4 bits (b[11:8]) are moved to the end (b[3:0]).
    // - The middle 4 bits (b[7:4]) are moved to the second position (b[7:4]).
    // - The last 4 bits (b[3:0]) are moved to the third position (b[11:8]).
    
	begin
	   Shift_Row = {b[15:12],b[3:0],b[7:4],b[11:8]};
	end

endfunction

function [3:0] S_Box_Function;
    input [3:0] in;
    // The S_Box_Function is a substitution function that maps a 4-bit input to a 4-bit output.
    // It is typically used in cryptographic algorithms for non-linear substitution.
    // Each possible 4-bit input value (from 0 to 15) is mapped to a specific 4-bit output.
    // This mapping is defined explicitly in the function body using a series of operators.
    begin
        S_Box_Function = (in == 4'b0000) ? 4'b1110 :
                         (in == 4'b0001) ? 4'b0100 :
                         (in == 4'b0010) ? 4'b1101 :
                         (in == 4'b0011) ? 4'b0001 :
                         (in == 4'b0100) ? 4'b0010 :
                         (in == 4'b0101) ? 4'b1111 :
                         (in == 4'b0110) ? 4'b1011 :
                         (in == 4'b0111) ? 4'b1000 :
                         (in == 4'b1000) ? 4'b0011 :
                         (in == 4'b1001) ? 4'b1010 :
                         (in == 4'b1010) ? 4'b0110 :
                         (in == 4'b1011) ? 4'b1100 :
                         (in == 4'b1100) ? 4'b0101 :
                         (in == 4'b1101) ? 4'b1001 :
                         (in == 4'b1110) ? 4'b0000 :
                         4'b0111; // The case for (in == 4'b1111)
    end
endfunction

function [3:0] Nibble_Sub;
    input [3:0] a;
    // Nibble_Sub is a wrapper function that applies the S_Box_Function to a 4-bit input 'a'.
    // It is used for substituting a 4-bit 'nibble' (half-byte) using the S-Box lookup defined in S_Box_Function.
    // This function is typically part of a larger cryptographic algorithm where such substitutions are common.
    begin
        Nibble_Sub = S_Box_Function(a);
    end
endfunction

function [15:0] K_Exp;
    input [15:0] key_in;
    input [3:0] i;
    // K_Exp is a key expansion function used in cryptographic algorithms.
    // It generates a 16-bit output from a 16-bit input key 'key_in' and a 4-bit iteration number 'i'.
    // The function performs a series of XOR operations and nibble substitutions to transform the input key.
    // The transformation depends on the iteration number 'i', with a different operation for 'i' equal to 0.

    reg [15:0] result;

    begin   
        // Conditional logic based on iteration number 'i'.
        if (i == 0) begin
            result = key_in;
        end else begin
            result[15:12] = key_in[15:12] ^ Nibble_Sub(key_in[3:0]) ^ i;
            
            result[11:8] = key_in[11:8] ^ result[15:12]; 
            
            result[7:4] = key_in[7:4] ^ result[11:8];
            
            result[3:0] = key_in[3:0] ^ result[7:4];
        end

        K_Exp = result;
    end
endfunction

