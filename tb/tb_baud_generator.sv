`timescale 1ns / 1ps

module tb_baud_generator();


initial begin
    $dumpfile("baud_generator.vcd");
    $dumpvars(0, tb_baud_generator);
end

endmodule
