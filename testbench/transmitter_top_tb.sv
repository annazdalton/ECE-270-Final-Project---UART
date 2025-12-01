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

//12MHz clk - period is 83.33 ns
always begin
    #41.66
    clk = ~clk;
end

initial begin
    $dumpfile("transmitter_top.vcd");
    $dumpvars(0, transmitter_top_tb);
    clk = 0;

    //reset
    nrst = 1;
    pb = '0;
    #500
    nrst = 0;
    #500
    nrst = 1;
    #500

    pb[7:0] = 8'b10100101;

    // parity_en on pb[18], tx_valid on pb[19]
    pb[18]    = 1'b0; // 0 = no parity, 1 = enable parity
    pb[19]    = 1'b0;

    //assert tx_valid for one clock
    #500;
    pb[19]    = 1'b1; // tx_valid pulse
    #100;
    pb[19]    = 1'b0;

    #2_000_000; // 2 ms in ns
    $finish;
end
endmodule