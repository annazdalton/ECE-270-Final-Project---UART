module transmitter_PISO(
    input clk, nrst,
    input logic [7:0] data_i,
    input logic shift_en,
    output logic piso_o
);
    logic nextpiso_o;

    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            piso_o <= '0;
        end else begin
            piso_o <= nextpiso_o;
        end
    end

    always_comb begin

    end


endmodule 