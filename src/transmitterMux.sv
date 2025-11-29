module transmitterMux(
    input logic piso_i, start, stop, parity_i,
    input logic [1:0] select,
    output logic tx_data_o
);
    always_comb begin
        if(select = 1'b00) begin
            tx_data_o = start;
        end else if (select = 1'b01) begin
            tx_data_o = piso_i;
        end else if (select = 1'b10) begin
            tx_data_o = parity_i;
        end else begin //select =  11
            tx_data_o = stop; 
        end
    end

endmodule 