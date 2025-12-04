`timescale 1ns/1ps

module receiver_uut_tb();

logic clk, nrst;
logic data_i, parity_en_i, data_ready, parity_error, frame_error;
logic [7:0] data_o;

receiver_uut topTest(
    .hwclk(clk),
    .reset(nrst),
    .data_i(data_i),
    .parity_en_input(parity_en_i),
    .SIPOdata_o(data_o),
    .data_ready(data_ready),
    .parity_error(parity_error),
    .frame_error(frame_error)
);


//12MHz clk - period is 83.33 ns
always begin
    #41.66
    clk = ~clk;
end

initial begin
    $dumpfile("receiver_uut.vcd");
    $dumpvars(0, receiver_uut_tb);
    clk = 1;
    
    //reset
    nrst = 1;
    #10
    nrst = 0;
    #10
    nrst = 1;
    #20
   
    parity_en_i = 1'b1; 
     
    //start bit
    data_i = 0;
    #150000 //data needs to be shifted in right after first baud pulse           
    
    //data -> 10100101
    data_i = 1; 
    #104166          
    data_i = 0; 
    #104166          
    data_i = 1; 
    #104166          
    data_i = 0; 
    #104166          
    data_i = 0; 
    #104166          
    data_i = 1; 
    #104166          
    data_i = 0; 
    #104166          
    data_i = 1;
    #104166          
    
    //parity bit 
    data_i = 0;
    #104166          
    
    //stop bit
    data_i = 1;
    #104166          
    
    #2000000;
    $finish;
end
endmodule