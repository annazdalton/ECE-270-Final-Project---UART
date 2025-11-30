`timescale 1ns / 1ps

module baud_generator_tb();

logic clk, nrst, baud_tick;

baud_generator baud_test(
    .clk(clk),
    .nrst(nrst),
    .baud_tick(baud_tick)
);

always begin
    #10
    clk = 1'b0;
    #10
    clk = 1'b1;
end

initial begin
    clk = 1'b0;

    //reset
    nrst = 1'b1;
    #2
    nrst = 1'b0;
    #2 
    nrst = 1'b1;

    $dumpfile("baud_generator.vcd");
    $dumpvars(0, baud_generator_tb);
end

endmodule
