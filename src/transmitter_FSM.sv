module transmitter_FSM(
    input logic clk, nrst, baud_tick, tx_valid, parity_en,
    input logic [3:0] count_data,
    output logic start, stop, count_en, count_clear, shift_en, load,
    output logic [1:0] select
);

    // typedef enum logic [2:0]{  
    //     IDLE = 0,
    //     LOAD = 1,
    //     START = 2,
    //     DATA = 3,
    //     PARITY = 4,
    //     STOP = 5
    // } state_t;

    //state_t state, nextState;
    logic [2:0] state, nextState;

    always_ff @(posedge clk, negedge nrst) begin
        if(~nrst) begin
            state <= '0; //idle
        end else begin
            state <= nextState;
        end
    end

    always_comb begin
        //defaults to prevent latch
        nextState = state;

        count_en = 1'b0;
        count_clear = 1'b0;

        start = 1'b0;
        stop = 1'b1;

        select = 2'b11;
        load = 1'b0;
        shift_en = 1'b0;

        case(state) 
            3'b0: begin 
                select = 2'b11; // stop/idle
                
                if(tx_valid) begin
                    nextState = 3'd1;
                end else begin
                    nextState = 3'd0;
                end
            end
            3'd1: begin
                load = 1'b1;
                select = 2'b11;
                nextState = 3'd2;
            end
            3'd2: begin 
                select = 2'b00; //send start bit to rx

                if(baud_tick) begin
                    nextState = 3'd3;
                    count_clear = 1'b1; //clear count before data state
                end else begin
                    nextState = 3'd2;
                end
            end
            3'd3: begin 
                //send data serially output from PISO
                select = 2'b01;

                if(baud_tick) begin
                    shift_en = 1'b1;
                    count_en = 1'b1;
                    //if done counting
                    if(count_data == 4'd7) begin
                        //reset counter
                        count_en = 1'b0;
                        count_clear = 1'b1;
                        if(parity_en) begin
                            nextState = 3'd4;
                        end else begin
                            nextState = 3'd5;
                        end
                    end else begin
                        nextState = 3'd3; //keep sending data out
                    end
                end
            end
            3'd4: begin 
                select = 2'b10; //parity output via mux

                if(baud_tick) begin
                    nextState = 3'd5;
                end else begin
                    nextState = 3'd4;
                end
            end
            3'd5: begin 
                select = 2'b11; // send stop to rx

                if(baud_tick) begin
                    nextState = 3'd0;
                end else begin
                    nextState = 3'd5;
                end
            end
            default: begin
                nextState = '0; 
            end
        endcase
    end
endmodule