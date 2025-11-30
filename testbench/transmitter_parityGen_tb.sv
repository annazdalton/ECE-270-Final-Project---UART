`timescale 1ns / 1ps

module transmitter_parityGen_tb();


always begin
    #10
    clk = 1'b0;
    #10
    clk = 1'b1;
end

initial begin
    $dumpfile("transmitter_parityGen.vcd");
    $dumpvars(0, transmitter_parityGen_tb);
    
  

    #200
    $finish;
end

endmodule
