`timescale 1ns / 1ps

module transmitter_FSM_tb();

logic clk, nrst, baud_tick, tx_valid, parity_en;
logic [3:0] count_data;
logic start, stop, count_en, count_clear;
logic [1:0] select;

transmitter_FSM FSMTest(
    .clk(clk),
    .nrst(nrst),
    .baud_tick(baud_tick),
    .tx_valid(tx_valid),
    .parity_en(parity_en),
    .count_data(count_data),
    .start(start),
    .stop(stop),
    .count_en(count_en),
    .count_clear(count_clear),
    .select(select)
);

always begin
    #10
    clk = ~clk;
end

always begin
    #20
    baud_tick = ~baud_tick;
end

initial begin
    $dumpfile("transmitter_FSM.vcd");
    $dumpvars(0, transmitter_FSM_tb);
    clk = 1;
    baud_tick = 1;

    //reset
    nrst = 1;
    #10
    nrst = 0;
    #10
    nrst = 1;
    #20

    tx_valid = 0;
    #10
    tx_valid = 1; 
    
    parity_en = 1;

    #60
    count_data = 4'd0;
    #20
    count_data = 4'd1;
    #20
    count_data = 4'd2;
    #20
    count_data = 4'd3;
    #20
    count_data = 4'd4;
    #20
    count_data = 4'd5;
    #20
    count_data = 4'd6;
    #20
    count_data = 4'd7;
    #20

    #100
    $finish;
end
endmodule