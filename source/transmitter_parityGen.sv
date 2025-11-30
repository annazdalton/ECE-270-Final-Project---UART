// Transmitter Parity Generator
// Anna Dalton (https://github.com/annazdalton)

module transmitter_parityGen(
    input logic [7:0] data_i,
    input logic parity_en;
    output logic parity_bit
);

//even parity
    always_comb begin
        if (parity_en) begin
            //XOR reduction for parity bit
            parity_bit = ^ data_i;
        end else begin
            parity_bit = 1'b0;
        end
     end
endmodule