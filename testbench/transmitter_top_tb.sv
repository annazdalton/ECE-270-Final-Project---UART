`timescale 1ns / 1ps

module transmitter_top_tb();

logic clk, nrst;
logic [19:0] pb;
logic [7:0] right;

transmitter_top topTest(
    .hwclk(clk),
    .reset(nrst),
    .pb(pb),
    .left(),
    .right(right),
    .ss7(),
    .ss6(),
    .ss5(),
    .ss4(),
    .ss3(),
    .ss2(),
    .ss1(),
    .ss0(),
    .txdata(),
    .rxdata(),
    .txclk(),
    .rxclk(),
    .txready(),
    .rxready()
);

always begin
    #10
    clk = ~clk;
end

initial begin
    $dumpfile("transmitter_top.vcd");
    $dumpvars(0, transmitter_top_tb);
    clk = 1;

    //reset
    nrst = 1;
    #10
    nrst = 0;
    #10
    nrst = 1;
    #20

    #100
    $finish;
end
endmodule