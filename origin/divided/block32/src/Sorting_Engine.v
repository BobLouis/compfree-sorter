`include "../src/parameter.v"
`include "../src/Block.v"

module Sorting_Engine(
    input clk,
    input [`ELEMENT_NUM-1:0] EVT,
    input [`INPUT_WIDTH-1:0] whole_UM,
    output [`LOG2_ELEMENT_NUM-1:0] FO
);

reg [`ELEMENT_NUM-1:0] Data [0:`DATA_WIDTH-1];
wire [`ELEMENT_NUM-1:0] mid_evt [0:`DATA_WIDTH-2];

// receive from Unsorted Memory
integer i; // N cells
integer j; // n Blocks
always@(*) begin
    for(i=0;i<`ELEMENT_NUM;i=i+1) begin
        Data[0][i] = ~whole_UM[(i+1)*(`DATA_WIDTH)-1];
        for (j=1; j<`DATA_WIDTH; j=j+1) begin
            Data[j][i] = whole_UM[(i+1)*(`DATA_WIDTH)-j-1];
        end
    end
end

// Generate Blocks
Block u_Block_MSB (
    .Data(Data[0]),
    .prev_evt(EVT),
    .nxt_evt(mid_evt[0])
);
genvar k;
generate
    for(k=1; k<`DATA_WIDTH-1; k=k+1) begin : n_Blocks
        Block u_Block_k (
            .Data(Data[k]),
            .prev_evt(mid_evt[k-1]),
            .nxt_evt(mid_evt[k])
        );
    end
endgenerate
Block u_Block_0 (
    .Data(Data[`DATA_WIDTH-1]),
    .prev_evt(mid_evt[`DATA_WIDTH-2]),
    .nxt_evt(FO)
);

endmodule
