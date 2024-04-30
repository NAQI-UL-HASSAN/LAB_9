module LAB_9 (input logic bit_value, valid_in, reset, clk, [2:0]bit_index,
              output logic en0,en1,  valid_out   ,[6:0]cathode
             );
    logic wr_en, counter_q_an, counter_d_an, clk100Hz, clk_cyc_20;
    logic [3:0]first_4_bit, next_4_bit, decoder_out; 
    logic [4:0]counter_q, counter_d;
    logic [7:0]out, q, d, in_for_divider;

    //ALREADY STORED INPUT
    always_ff @( posedge clk or posedge reset) begin
        if (reset)
            q <= #1 8'b0;
        else if (wr_en)
            q <= #1 d;
    end

    //CALLING MY DATAPATH
    datapath mydatapath(
        .bit_value(bit_value),
        .bit_index(bit_index),
        .out(out),
        .q(q)
    );

    //CONNECTION WITH THE ALREADY STORED VALUE FLIPFLOP
    always_comb begin
        d = out;
    end

    //CLOCK OF 100HZ
    my100Hz myclock(
        .reset(reset),
        .clk(clk),
        .clk100Hz(clk100Hz)
    );

    //COUNTER FOR VALID_OUT
    always_comb counter_d = counter_q + 1;
    always_ff @(posedge clk or posedge reset) begin       
        if (reset)
            counter_q <= 5'd0;
        else if (counter_q == 5'd20) begin
            counter_q <= 5'd0;
            clk_cyc_20 <= 1'b1;
            end
        else
            counter_q <= counter_d;
    end

    //COUNTER FOR ANODE
    always_comb counter_d_an = ~ counter_q_an;

    always_ff @(posedge clk100Hz or posedge reset) begin
        if (reset)
            counter_q_an <= 1'b0;
        else
            counter_q_an <= counter_d_an;
    end

    //MUX FOR ANODE
    always_comb begin
        if (counter_q_an) begin
            en0 = 1'b1;
            en1 = 1'b0;
            end
        else
            en0 = 1'b0;
            en1 = 1'b1;
    end

    //CALLING THE CONTROLLER
    controller mycontroller(
        .valid_in(valid_in),
        .reset(reset),
        .clk(clk),
        .clk_cyc_20(clk_cyc_20),
        .wr_en(wr_en),
        .valid_out(valid_out)
    );
    
    //OUTPUT VALIDITY
    always_comb begin
        if (valid_out)
            in_for_divider = d;
        else
            in_for_divider = q;
    end

    //8BIT to TWO 4BIT CONVERSION
    always_comb begin
        first_4_bit =  in_for_divider [3:0];
        next_4_bit = in_for_divider [7:4];
    end

    //MUX FOR CATHODE
    always_comb begin
        if (clk100Hz)
            decoder_out = first_4_bit;
        else
            decoder_out = next_4_bit;
    end

    //CASES FOR DECODER
    always_comb begin
        case (decoder_out)
            4'b0000: cathode = 7'b0000001;
            4'b0000: cathode = 7'b1001111;
            4'b0000: cathode = 7'b0010010;
            4'b0000: cathode = 7'b0000110;
            4'b0000: cathode = 7'b1001100;
            4'b0000: cathode = 7'b0100100;
            4'b0000: cathode = 7'b0100000;
            4'b0000: cathode = 7'b0001111;
            4'b0000: cathode = 7'b0000000;
            4'b0000: cathode = 7'b0000100;
            4'b0000: cathode = 7'b0001000;
            4'b0000: cathode = 7'b1100000;
            4'b0000: cathode = 7'b0110001;
            4'b0000: cathode = 7'b1000010;
            4'b0000: cathode = 7'b0110000;
            4'b0000: cathode = 7'b0111000;

                default: cathode = 7'b0000000;       
        endcase
    end
endmodule
