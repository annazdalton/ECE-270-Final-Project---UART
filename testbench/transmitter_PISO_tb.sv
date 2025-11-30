`timescale 1ns / 1ps

module transmitter_PISO_tb();

logic clk, nrst, shift_en, load, piso_o;
logic [7:0] data_i;

transmitter_PISO PISOTest(
    .clk(clk),
    .nrst(nrst),
    .data_i(data_i),
    .shift_en(shift_en),
    .load(load),
    .piso_o(piso_o)
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
    #10
    nrst = 1'b0;
    #10
    nrst = 1'b1;
    
    #10
    data_i = 0110_0101;
    load = 1;
    shift_en = 0;
    #10
    shift_en = 1;     

    $dumpfile("transmitter_PISO.vcd");
    $dumpvars(0, transmitter_PISO_tb);

    #200
    $finish;
end

endmodule
