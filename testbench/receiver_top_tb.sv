`timescale 1ns/1ps

module receiver_top_tb();

logic clk, nrst;
logic [20:0] pb;
logic [7:0] left, right;
logic data_in;

receiver_top topTest(
    .hwclk(clk),
    .reset(nrst),
    .pb(pb),
    .left(left),
    .right(right),
    .ss7(),
    .ss6(),
    .ss5(),
    .ss4(),
    .ss3(),
    .ss2(),
    .ss1(),
    .ss0(),
    .red(),
    .green(),
    .blue(),
    .txdata(),
    .rxdata(),
    .txclk(),
    .rxclk(),
    .txready(),
    .rxready()
);

assign pb[0] = data_in;

//12MHz clk - period is 83.33 ns
always begin
    #41.66
    clk = ~clk;
end

initial begin
    $dumpfile("receiver_top.vcd");
    $dumpvars(0, receiver_top_tb);
    clk = 0;

    //reset
    nrst = 1;
    pb[20:1] = '0;
    data_in = 1;
    #500
    nrst = 0;
    #500
    nrst = 1;
    #500

    //parity_en on pb[18]
    pb[18] = 1'b1; 
    
    data_in = 1; 
    #10000
    
    //start bit
    data_in = 0;
    #100
    
    //data -> 10100101
    data_in = 1; 
    #100
    data_in = 0; 
    #100
    data_in = 1; 
    #100
    data_in = 0; 
    #100
    data_in = 0; 
    #100
    data_in = 1; 
    #100
    data_in = 0; 
    #100
    data_in = 1;
    #100
    
    //parity bit 
    data_in = 1;
    #100
    
    //stop bit
    data_in = 1;
    #100
    
    #500000;
    $finish;
end
endmodule