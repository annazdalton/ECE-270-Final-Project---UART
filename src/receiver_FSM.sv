module receiver_FSM(
    input logic clk, nrst,
    input logic baud_tick, data_i, parity_en_i,
    output logic shift_en, parity_en, frame_en,
    output logic data_ready
);
    // typedef enum logic [2:0]{
    //     IDLE = 0,
    //     START = 1,
    //     DATA = 2,
    //     PARITY = 3,
    //     STOP = 4
    // } state_t;

    logic [2:0] state, nextState;
    logic [3:0] bit_count, nextCount;

    always_ff @(posedge clk, negedge nrst) begin
        if(~nrst) begin
            state <= 3'd0;
            bit_count <= '0;
        end else begin  
            state <= nextState;
            bit_count <= nextCount;
        end
    end

    always_comb begin
        shift_en = 1'b0;
        parity_en = 1'b0;
        frame_en = 1'b0;
        data_ready = 1'b0;
        nextState = state;
        nextCount = bit_count;

        case(state)
            3'd0: begin //IDLE
                nextCount = '0;
                if (data_i == 1'b0) begin nextState = 3'd1; end
                else begin nextState = 3'd0; end
            end
            3'd1: begin //START
                if (baud_tick == 1'b0) begin
                    nextState = 3'd1;
                end else if (baud_tick == 1'b1 && data_i == 1'b0) begin 
                    nextState = 3'd2; 
                    nextCount = '0;
                end
                else if(baud_tick == 1'b1 && data_i == 1'b1) begin 
                    nextState = 3'd0; 
                end
            end    
            3'd2: begin //DATA
                if (baud_tick == 1'b1 && bit_count == 4'd7 && parity_en_i == 1'b1) begin
                    shift_en = 1'b1;
                    nextState = 3'd3;
                    nextCount = '0;
                end else if (baud_tick == 1'b1 && bit_count < 4'd7) begin
                    shift_en = 1'b1;
                    nextState = 3'd2;
                    nextCount = bit_count + 4'd1;
                end else if (baud_tick == 1'b1 && bit_count == 4'd7 && parity_en_i == 1'b0) begin
                    shift_en = 1'b1;
                    nextState = 3'd4;
                    nextCount = '0;
                end else if (baud_tick == 1'b0) begin
                    nextState = 3'd2;
                end
            end
            3'd3: begin //PARITY
                if (baud_tick == 1'b0) begin
                    nextState = 3'd3;
                end else begin
                    parity_en = 1'b1;
                    nextState = 3'd4;
                end
            end
            3'd4: begin //STOP
                if (baud_tick == 1'b0) begin
                    nextState = 3'd4;
                end else begin
                    frame_en = 1'b1;
                    data_ready = 1'b1;
                    nextState = 3'd0;
                end
            end
            default: begin nextState = 3'd0; end
        endcase
    end

endmodule

