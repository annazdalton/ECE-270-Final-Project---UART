`timescale 1ns / 1ps

module transmitter_parityGen_tb();


logic [7:0] data_i;
logic       parity_en;
logic       parity_bit;

transmitter_parityGen parityTest(
    .data_i(data_i),
    .parity_en(parity_en),
    .parity_bit(parity_bit)
);

initial begin
    $dumpfile("transmitter_parityGen.vcd");
    $dumpvars(0, transmitter_parityGen_tb);
    
    //test enable off
    parity_en = 0;
    data_i    = 8'hFF;
    #10

    //even number of 1s, parity_bit = 0
    parity_en = 1;
    data_i    = 8'b0000_0000;
    #10

    //odd number of 1s, parity = 1
    data_i = 8'b0000_0001;
    #10;

    //even number of 1s, parity = 0
    data_i = 8'b1010_1010;
    #10;

    $finish;
end

endmodule
