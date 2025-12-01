`timescale 1ns/1ps

module receiver_parityChecker_tb();

logic [7:0] sipo_i;
logic parity_en, parity_bit;
logic parity_error;

receiver_parityChecker parityTest(
    .sipo_i(sipo_i),
    .parity_en(parity_en),
    .parity_bit(parity_bit),
    .parity_error(parity_error)
);

initial begin
    $dumpfile("receiver_parityChecker.vcd");
    $dumpvars(0, receiver_parityChecker_tb);
    
    //no error -> enable off
    parity_en = 0;
    sipo_i = 8'hFF;
    parity_bit = 0;
    #10

    //no error
    parity_en = 1;
    sipo_i = 8'b0000_0000;
    parity_bit = 0;
    #10

    //no error
    sipo_i = 8'b0000_0001;
    parity_bit = 1;
    #10;

    //no error
    sipo_i = 8'b1010_1010;
    parity_bit = 0;
    #10;
    
    //error
    sipo_i = 8'b0000_0001;
    parity_bit = 0;
    #10;
    
    //error
    sipo_i = 8'b1010_1010;
    parity_bit = 1;
    #10;

    $finish;
end

endmodule
