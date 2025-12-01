`timescale 1ns/1ps

module receiver_frameChecker_tb();

logic frame_en, stop_bit;
logic frame_error;

receiver_frameChecker frameTest(
    .frame_en(frame_en),
    .stop_bit(stop_bit),
    .frame_error(frame_error)
);

initial begin
    $dumpfile("receiver_frameChecker.vcd");
    $dumpvars(0, receiver_frameChecker_tb);
    
    //enable off, no error
    frame_en = 0;
    stop_bit = 0;
    #10
    
    stop_bit = 1;
    #10

    //enable on, stop bit is 1, no error
    frame_en = 1;
    stop_bit = 1;
    #10

    //enable on, stop bit is 0, error
    stop_bit = 0;
    #10
    
    //enable off 
    frame_en = 0;
    #10

    $finish;
end

endmodule
