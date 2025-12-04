module receiver_uut(
    input logic hwclk, reset,
    input logic data_i, parity_en_input,
    output logic [7:0] SIPOdata_o,
    output logic data_ready, parity_error, frame_error
);

    logic shift_en, parity_en, frame_en;
    logic baud_tick;

    baud_generator baudgen(
        .clk(hwclk),
        .nrst(reset),
        .baud_tick(baud_tick)
    );

    receiver_FSM recFSM(
        .clk(hwclk),
        .nrst(reset),
        .baud_tick(baud_tick),
        .data_i(data_i),
        .parity_en_i(parity_en_input),
        .shift_en(shift_en),
        .parity_en(parity_en),
        .frame_en(frame_en),
        .data_ready(data_ready)
    );

    receiver_SIPO recSIPO(
        .clk(hwclk),
        .nrst(reset),
        .shift_en(shift_en),
        .data_i(data_i),
        .sipo_o(SIPOdata_o)
    );
    
    receiver_parityChecker recParity(
        .sipo_i(SIPOdata_o),
        .parity_en(parity_en),
        .parity_bit(data_i),
        .parity_error(parity_error)
    );

    receiver_frameChecker recFrame(
        .frame_en(frame_en),
        .stop_bit(data_i),
        .frame_error(frame_error)
    );
endmodule