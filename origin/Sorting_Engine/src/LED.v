`include "../src/parameter.v"

module LED( // Largest Element Detector
    input [`ELEMENT_NUM-1:0] one_hot_FO,
    output reg [`LOG2_ELEMENT_NUM-1:0] LE_addr
);

// wire one_one = (one_hot_FO != 0) && (one_hot_FO == (one_hot_FO & -one_hot_FO));
// wire mul_one = (one_hot_FO != 0) && !one_one;

// assume no duplicates
// assume N = 16
always@(*) begin
    case(one_hot_FO)
        16'h0001: LE_addr = 0;
        16'h0002: LE_addr = 1;
        16'h0004: LE_addr = 2;
        16'h0008: LE_addr = 3;
        
        16'h0010: LE_addr = 4;
        16'h0020: LE_addr = 5;
        16'h0040: LE_addr = 6;
        16'h0080: LE_addr = 7;
        
        16'h0100: LE_addr = 8;
        16'h0200: LE_addr = 9;
        16'h0400: LE_addr = 10;
        16'h0800: LE_addr = 11;
        
        16'h1000: LE_addr = 12;
        16'h2000: LE_addr = 13;
        16'h4000: LE_addr = 14;
        16'h8000: LE_addr = 15;
        default: LE_addr = 0;
    endcase
end

endmodule