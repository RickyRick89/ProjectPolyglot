// File Description:
// A wrapper for the FIFO primitive for a UART Driver.

module uart_fifo (

  // System Signals:
  input        clock,
  input        reset,    // Active Low reset.

  // Data In:
  input        write,    // Active high.
  input  [9:0] data_in,  // Incoming data.

  // Data Out:
  input        read,     // Active high.
  output [9:0] data_out, // Outgoing data.

  // Status:
  output       empty,    // High when empty.
  output       full      // High when full.

);

  // Only allow writing when the FIFO has room.
  logic  write_enable;
  assign write_enable = full ? 0 : write;

  FIFO18E1 #(
    .ALMOST_FULL_OFFSET(1020),  // Sets almost full threshold. This value was obtained through guessing and checking.
    .DATA_WIDTH        (18),    // Sets data width to 4-36
    .DO_REG            (0),     // Enable output register (1-0) Must be 1 if EN_SYN = FALSE
    .EN_SYN            ("TRUE") // Specifies FIFO as dual-clock (FALSE) or Synchronous (TRUE)
  ) fifo (

    // System Signals:
    .RST       (~reset),       // 1-bit input: Asynchronous Reset
    .RSTREG    (~reset),       // 1-bit input: Output register set/reset

    // Data In:
    .WRCLK     (clock),        // 1-bit input: Write clock
    .WREN      (write_enable), // 1-bit input: Write enable
    .DI        (data_in),      // 32-bit input: Data input

    // Data Out:
    .RDCLK     (clock),        // 1-bit input: Read clock
    .RDEN      (read),         // 1-bit input: Read enable
    .REGCE     (1),            // 1-bit input: Clock enable
    .DO        (data_out),     // 32-bit output: Data output

    // Status:
    .EMPTY     (empty),        // 1-bit output: Empty flag
    .ALMOSTFULL(full),         // 1-bit output: Almost full flag

    // Unused Inputs:
    .DIP(0)                    // 4-bit input: Parity input
  );

endmodule
