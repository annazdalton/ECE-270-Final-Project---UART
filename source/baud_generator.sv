module baud_generator(
    input logic clk, nrst,
    output logic baud_tick
);
    logic [15:0] counter, divisor, counter_n;
    logic baud_tick_n;
    
    //baud rate currently set to 9600, hwclk is 12MHz
    //divisor = clock_Frequency / baud_Rate

    //change divisor value to change baud rate
    assign divisor = 16'd1250;

    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            counter <= 16'd0;
            baud_tick <= 1'b0;
        end else begin
            counter <= counter_n;
            baud_tick <= baud_tick_n;
        end
    end

    always_comb begin
        if(counter == (divisor - 16'd1)) begin
            counter_n = 16'd0;
            baud_tick_n = 1'b1;
        end else begin
            counter_n = counter + 16'd1;
            baud_tick_n = 1'b0;
        end
    end

endmodule