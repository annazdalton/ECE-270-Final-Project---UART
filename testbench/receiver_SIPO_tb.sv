`timescale 1ns/1ps

module receiver_SIPO_tb();

logic clk, nrst, shift_en, data_i;
logic [7:0] sipo_o;

receiver_SIPO SIPOTest(
    .clk(clk),
    .nrst(nrst),
    .shift_en(shift_en),
    .data_i(data_i),
    .sipo_o(sipo_o)
);

always begin
    #10
    clk = 1'b0;
    #10
    clk = 1'b1;
end

initial begin
    $dumpfile("receiver_SIPO.vcd");
    $dumpvars(0, receiver_SIPO_tb);
    
    clk = 1'b0;

    //reset
    nrst = 1'b1;
    #10
    nrst = 1'b0;
    #10
    nrst = 1'b1;
    
    
    //ensure shift_en works
    shift_en = 0;
    data_i = 1; 
    #20
    data_i = 0;
    #20

    //data: 10100101 
    shift_en = 1;
    data_i = 1; 
    #20
    data_i = 0; 
    #20
    data_i = 1; 
    #20
    data_i = 0; 
    #20
    data_i = 0; 
    #20
    data_i = 1; 
    #20
    data_i = 0; 
    #20
    data_i = 1; 
    #20
    
    shift_en = 0;
    #40
    $finish;
end

endmodule