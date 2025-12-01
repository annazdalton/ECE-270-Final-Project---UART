`timescale 1ns/1ps

module receiver_FSM_tb();

logic clk, nrst, baud_tick, data_i, parity_en_i;
logic shift_en, parity_en, frame_en, data_ready;

receiver_FSM FSMTest(
    .clk(clk),
    .nrst(nrst),
    .baud_tick(baud_tick),
    .data_i(data_i),
    .parity_en_i(parity_en_i),
    .shift_en(shift_en),
    .parity_en(parity_en),
    .frame_en(frame_en),
    .data_ready(data_ready)
);

always begin
    #10
    clk = ~clk;
end

initial begin
    $dumpfile("receiver_FSM.vcd");
    $dumpvars(0, receiver_FSM_tb);
    clk = 0;
    baud_tick = 0;

    //reset
    nrst = 1;
    #10
    nrst = 0;
    #10
    nrst = 1;
    #20

    parity_en_i = 1; 
    data_i = 1; 
    #40
    
    //start bit
    data_i = 0;
    #20
    baud_tick = 1;
    #20
    baud_tick = 0;
    #20
    
    //data bits -> 10100101
    data_i = 1; 
    #20
    baud_tick = 1;
    #20
    baud_tick = 0;
    #20
    
    data_i = 0; 
    #20
    baud_tick = 1;
    #20
    baud_tick = 0;
    #20
    
    data_i = 1;
    #20
    baud_tick = 1;
    #20
    baud_tick = 0;
    #20
    
    data_i = 0; 
    #20
    baud_tick = 1;
    #20
    baud_tick = 0;
    #20
    
    data_i = 0; 
    #20
    baud_tick = 1;
    #20
    baud_tick = 0;
    #20
    
    data_i = 1; 
    #20
    baud_tick = 1;
    #20
    baud_tick = 0;
    #20
    
    data_i = 0;
    #20
    baud_tick = 1;
    #20
    baud_tick = 0;
    #20
    
    data_i = 1; 
    #20
    baud_tick = 1;
    #20
    baud_tick = 0;
    #20
    
    //parity bit
    data_i = 1; //odd parity for 10100101
    #20
    baud_tick = 1;
    #20
    baud_tick = 0;
    #20
    
    //stop bit
    data_i = 1;
    #20
    baud_tick = 1;
    #20
    baud_tick = 0;
    #20

    #100
    $finish;
end
endmodule
