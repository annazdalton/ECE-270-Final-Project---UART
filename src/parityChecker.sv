//using even parity
module parityCheck(
    input logic [7:0] sipo_i,
    input logic parity_en, parity_bit, //parity_bit is data_i from transmitter
    output logic parity_error
);
    always_comb begin
        parity_error = 1'b0;
        if(parity_en) begin
            parity_error = ^{sipo_i, parity_bit};
        end
    end
endmodule
