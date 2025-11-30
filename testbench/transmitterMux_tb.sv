`timescale 1ns / 1ps

module transmitterMux_tb();

logic piso_i, start, stop, parity_i;
logic [1:0] select;
logic tx_data_o;

transmitterMux muxTest(
    .piso_i(piso_i),
    .start(start),
    .stop(stop),
    .parity_i(parity_i),
    .select(select),
    .tx_data_o(tx_data_o)
);

initial begin
    $dumpfile("transmitterMux.vcd");
    $dumpvars(0, transmitterMux_tb);

    select = '0;
    piso_i = 1;
    start = 1;
    stop = 1;
    parity_i = 1;
    #10

    //test 00
    select = 2'b00;
    #10
    start = 0;
    #10
    start = 1;
    #10
    //test 01
    select = 2'b01;
    #10
    piso_i = 0;
    #10
    piso_i = 1;
    #10
    //test 10
    select = 2'b10;
    #10
    parity_i = 0;
    #10
    parity_i = 1;
    #10
    //test 11
    select = 2'b11;
    #10
    stop = 0;
    #10
    stop = 1;
    #10
    
    #10
    $finish;
end

endmodule
