`include "../src/parameter.v"
`include "../src/LDED.v"
`include "../src/Block.v"

module Sorting_Engine(
    input clk,
    input rst,
    input flag, // 1: input, 0: sorting mode
    input [`ELEMENT_NUM-1:0] bit_data,
    output reg [`LOG2_DATA_WIDTH-1:0] bit_addr,
    output [`LOG2_ELEMENT_NUM-1:0] LE_Addr,
    output SM_valid
);

reg [`ELEMENT_NUM-1:0] EVT;
reg LDED_valid;
reg [`ELEMENT_NUM-1:0] prev_evt, LDED_evt;
wire [`ELEMENT_NUM-1:0] nxt_evt;

Block u_Block (
    .Data(bit_data),
    .prev_evt(prev_evt),
    .nxt_evt(nxt_evt)
);

// Largest and Duplicated Element Detector
// similar to One-Hot Decoder
LDED u_LDED (
    .clk(clk),
    .rst(rst),
    .in_valid(LDED_valid),
    .FO(LDED_evt),
    .out_valid(SM_valid),
    .LE_Addr(LE_Addr)
);

// one left but not reach Block_0 yet, then finish earlier
wire one_one = (|nxt_evt) && (nxt_evt == (nxt_evt & -nxt_evt));

integer i;
// EVT Update Unit and Controller
always@(posedge clk or posedge rst) begin
    if(rst) begin
        for(i=0;i<`ELEMENT_NUM;i=i+1) begin
            EVT[i] <= 1;
            prev_evt[i] <= 1;
        end
        bit_addr <= `DATA_WIDTH - 1;
        LDED_valid <= 0;
        LDED_evt <= 0;
    end
    else if(~flag) begin // flag = 0: Sorting mode
        if(bit_addr == 0 || one_one) begin
            if(SM_valid == 0) begin
                bit_addr <= `DATA_WIDTH - 1;
                EVT <= (~nxt_evt) & EVT;
                prev_evt <= (~nxt_evt) & EVT;
                LDED_evt <= nxt_evt;
                LDED_valid <= 1;
            end
        end
        else begin
            prev_evt <= nxt_evt;
            bit_addr <= bit_addr - 1;
            LDED_valid <= 0;
        end
    end
end

endmodule
