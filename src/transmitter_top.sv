module transmitter_top (
  // I/O ports
  input  logic hwclk, reset, //hwclk = 10 MHz
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);


logic [7:0] PISOdata_i;
logic [3:0] count;
logic [1:0] mux_select;
logic count_enable, count_clear, count_overflow, piso_o, tx_data_o, mux_stop, mux_start, parity_o;

// data going into transmitter is PB[7:0] of FPGA
assign PISOdata_i = pb[7:0];
// data coming out is shown on RIGHT[0]
assign right[0] = tx_data_o;

counter count0(
  .clk(hwclk), 
  .nrst(reset), 
  .enable(count_enable), 
  .clear(count_clear), 
  .count(count), 
  .overflow_flag(count_overflow)
);

transmitter_FSM trans_FSM(
  //inputs
  .clk(hwclk),
  .nrst(reset),
  .baud_tick(),
  .tx_valid(),
  .count_overflow(count_overflow),
  .count_data(),
  //outputs
  .start(mux_start),
  .stop(mux_stop),
  .count_en(count_enable),
  .count_clear(count_clear),
  .select(mux_select)
);

tramsmitter_PISO trans_PISO(
  .clk(hwclk),
  .nrst(reset),
  .data_i(PISOdata_i),
  .shift_en(),
  .load(),
  .piso_o(piso_o)
);

transmitter_parityGen trans_parity(
  .data_i(PISOdata_i),
  .parity_en(),
  .parity_bit(parity_o)
);

transmitterMux trans_mux(
  .piso_i(piso_o),
  .start(mux_start),
  .stop(mux_stop),
  .parity_i(parity_o),
  .select(mux_select),
  .tx_data_o(tx_data_o)
);

endmodule