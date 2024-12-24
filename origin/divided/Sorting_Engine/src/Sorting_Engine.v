`include "../src/parameter.v"
`include "../src/LDED.v"
`include "../src/Block.v"

module Sorting_Engine(
    input rst,
    input clk_mj,
    input clk_mn,
    input mode, // 0: UM input, 1: Sorting output
    input [`INPUT_WIDTH-1:0] whole_UM,
    output SM_valid,
    output [`LOG2_ELEMENT_NUM-1:0] LE_Addr
);

reg [`ELEMENT_NUM-1:0] EVT;

reg [`ELEMENT_NUM-1:0] Data [0:`DATA_WIDTH-1];
wire [`ELEMENT_NUM-1:0] mid_evt [0:`DATA_WIDTH-2];
wire [`ELEMENT_NUM-1:0] FO_mj; // Filter Output
wire TR_empty;

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
    .nxt_evt(FO_mj)
);

reg [`ELEMENT_NUM-1:0] FO_mj_reg;
reg mj_level;

// Largest and Duplicated Element Detector
LDED u_LDED (
    .rst(rst),
    .clk_mn(clk_mn),
    .FO_mj_reg(FO_mj_reg),
    .mode(mode),
    .mj_level(mj_level),
    .SM_valid(SM_valid),
    .TR_empty(TR_empty),
    .LE_Addr(LE_Addr)
);

// major clock domain: EVT Update Unit
always@(posedge clk_mj) begin
    if(rst) begin
        for(i=0;i<`ELEMENT_NUM;i=i+1) begin
            EVT[i] <= 1;
        end
        FO_mj_reg <= 0;
        mj_level <= 0;
    end
    else begin
        if(mode && TR_empty) begin // Sorting output mode
            EVT <= (~FO_mj) & EVT;
            FO_mj_reg <= FO_mj;
            mj_level <= ~mj_level; // make XOR in clk_mn domain a pulse
        end
    end
end

endmodule
