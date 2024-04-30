module controller (input logic valid_in, clk_cyc_20, clk, reset,
                   output logic wr_en, valid_out
);
    parameter S0 = 0, S1 = 1;
    logic CS, NS;
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            CS <= S0;
        else
            CS <= NS;
    end
    always_comb begin
        case (CS)
            S0 : if (valid_in) NS = S1;
                 else NS = S0;
            S1 : if (clk_cyc_20) NS = S0;
                 else NS = S1;
                 default: NS = S0;
        endcase
    end
    always_comb begin
        case (CS)
           S0 : if(valid_in)begin   
                    wr_en = 0;
                    valid_out = 0;
                 end
                else  begin 
                    wr_en = 0;
                    valid_out = 0;
                    end
           S1 : if (clk_cyc_20)   begin 
                wr_en = 1;
                valid_out = 1;
                end
                else begin
                wr_en = 0;
                valid_out = 0;
                end
            default: valid_out = 0;
         
        endcase
    end
endmodule