module datapath (input logic q, bit_value, [2:0]bit_index, 
                 output logic [7:0]out
                );
logic [7:0]mask_crytr_out, mask_crytr;

    //MUX FOR BIT_INDEX
    always_comb begin
        case (bit_index)

            3'b000 : mask_crytr = 8'b00000001;
            3'b001 : mask_crytr = 8'b00000010;
            3'b010 : mask_crytr = 8'b00000100;
            3'b011 : mask_crytr = 8'b00001000;
            3'b100 : mask_crytr = 8'b00010000;
            3'b101 : mask_crytr = 8'b00100000;
            3'b110 : mask_crytr = 8'b01000000;
            3'b111 : mask_crytr = 8'b10000000;

            default: mask_crytr = 8'b00000000;
        endcase
    end

    //MUX FOR BIT_VALUE
    always_comb begin
        if (bit_value)
            mask_crytr_out = mask_crytr;
        else
            mask_crytr_out = 8'b00000000;
    end
    
    //XOR FOR BIT CHANGE
    always_comb begin
        out = q ^ mask_crytr_out;
    end
endmodule