module transmitter_FSM(
    input logic clk, nrst, baud_tick, tx_valid, count_overflow, parity_en,
    input logic [3:0] count_data,
    output logic start, stop, count_en, count_clear,
    output logic select
);

    typedef enum logic [2:0]{  
        IDLE = 0,
        START = 1,
        DATA = 2,
        PARITY = 3,
        STOP = 4
    } state_t;

    state_t state, nextState;

    always_ff @(posedge clk, negedge ~nrst) begin
        if(~nrst) begin
            state <= IDLE;
        end else begin
            state <= nextState;
        end
    end

    always_comb begin
        //defaults to prevent latch
        nextState   = state;
        count_en    = 1'b0;
        count_clear = 1'b0;

        start       = 1'b0;
        stop        = 1'b1;

        select      = 2'b11;

        case(state) 
            IDLE: begin 
                select = 2'b11; // stop/idle
                
                if(tx_valid) begin
                    nextState = START;
                end else begin
                    nextState = IDLE;
                end
            end
            START: begin 
                select = 2'b00; //send start bit to rx

                if(baud_tick) begin
                    nextState = DATA;
                    count_clear = 1'b1; //clear count before data state
                end else begin
                    nextState = START;
                end
            end
            DATA: begin 
                //send data serially output from PISO
                select = 2'b01;
                count_en = baud_tick; //counter only incremnets on baud_tick

                if(baud_tick) begin
                    //if done counting
                    if(count_data == 4'd7) begin
                        if(parity_en) begin
                            nextState = PARITY;
                        end else begin
                            nextState = STOP;
                        end
                        //reset counter
                        count_en = 1'b0;
                        count_clear = 1'b1;
                    end else begin
                        nextState = DATA; //keep sending data out
                    end
                end
            end
            PARITY: begin 
                count_clear = 0;
                count_en = 0;
                //add logic once parity gen is done
                if(baud_tick) begin
                    nextState = STOP
                end else begin
                    nextState = PARITY;
                end
            end
            STOP: begin 
                count_clear = 0;
                count_en = 0;
                if(baud_tick) begin
                    nextState = IDLE;
                end else begin
                    nextState = STOP;
                end
            end
            default: begin
                nextState = IDLE; 
                count_en = 0;
                count_clear = 0;
            end
        endcase
    end
endmodule