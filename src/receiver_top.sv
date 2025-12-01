module receiver_top(
    //I/O ports
    input logic hwclk, reset, //hwclk = 10 MHz
    output logic [20:0] pb,
    output logic [7:0] left, right,
        ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
    output logic red, green, blue,

    //UART ports
    output logic [7:0] txdata,
    input logic [7:0] rxdata,
    output logic txclk, rxclk,
    input logic txready, rxready
);

    logic [7:0] SIPOdata_o;
    logic shift_en, parity_en_input, parity_en, frame_en, data_ready;
    logic parity_error, frame_error;
    logic baud_tick;
    logic data_i;

    //simulated serial data input from push button
    assign data_i = pb[0];

    //simulated parity enable signal
    assign parity_en_input = pb[18];
    
    //data leaving receiver is left[7:0] of FPGA
    assign left[7:0] = SIPOdata_o;
    
    //display status on right LEDs
    assign right[0] = data_ready;
    assign right[1] = parity_error;
    assign right[2] = frame_error;
    assign right [7:3] = 5'b0;

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

