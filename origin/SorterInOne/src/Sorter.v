`include "../src/parameter.v"
`include "../src/Block.v"
`include "../src/LED.v"

module Sorter(
    input rst,
    input clk,
    input UM_valid,
    input [`DATA_WIDTH-1:0] UM_data,

    output reg SM_valid,
    output reg [`LOG2_ELEMENT_NUM-1:0] SM_addr,
    output [`DATA_WIDTH-1:0] SM_data,
    output reg done
);

wire [`LOG2_ELEMENT_NUM-1:0] LE_Addr;

wire [`LOG2_ELEMENT_NUM-1:0] UM_addr = (UM_valid)? SM_addr: LE_Addr;

////////////////////////////////////////
////         Sorting_Engine         ////
////////////////////////////////////////
reg [`ELEMENT_NUM-1:0] EVT;
reg [`ELEMENT_NUM-1:0] Data_T [0:`DATA_WIDTH-1];
wire [`ELEMENT_NUM-1:0] mid_evt [0:`DATA_WIDTH-2];
wire [`ELEMENT_NUM-1:0] FO; // Filter Output

reg [`DATA_WIDTH-1:0] UM_M [0:`ELEMENT_NUM-1];

// receive from Unsorted Memory
genvar i, j;
generate
    for (i=0; i<`ELEMENT_NUM; i=i+1) begin : element_num
        // Data_T[0][i] = UM_M[i][`DATA_WIDTH-1];
        for (j=0; j<`DATA_WIDTH; j=j+1) begin : data_width
            always @(UM_M[i][j]) begin
                Data_T[`DATA_WIDTH-j-1][i] = UM_M[i][j];
            end
        end
    end
endgenerate

wire [`ELEMENT_NUM-1:0] neg_Data_0;
assign neg_Data_0 = ~Data_T[0];

// Generate Blocks
Block u_Block_MSB (
    .Data(neg_Data_0),
    .prev_evt(EVT),
    .nxt_evt(mid_evt[0])
);
genvar k;
generate
    for(k=1; k<`DATA_WIDTH-1; k=k+1) begin : n_Blocks
        Block u_Block_k (
            .Data(Data_T[k]),
            .prev_evt(mid_evt[k-1]),
            .nxt_evt(mid_evt[k])
        );
    end
endgenerate
Block u_Block_0 (
    .Data(Data_T[`DATA_WIDTH-1]),
    .prev_evt(mid_evt[`DATA_WIDTH-2]),
    .nxt_evt(FO)
);

// Largest Element Detector
LED u_LED (
    .one_hot_FO(FO),
    .LE_addr(LE_Addr)
);

/////////////////////////////////////////
////         Unsorted Memory         ////
/////////////////////////////////////////

assign SM_data = UM_M[UM_addr];

////////////////////////////////////////
////         Top Controller         ////
////////////////////////////////////////

integer l;

always@(posedge clk or posedge rst) begin
    if(rst) begin
        SM_addr <= 0; // used as counter at first
        SM_valid <= 0; // 0: UM input, 1: Sorting output
        done <= 0;

        for (l=0; l<`ELEMENT_NUM; l=l+1) begin
            UM_M[l] <= 0;
            EVT[l] <= 1;
        end
    end
    else begin
        if(SM_addr == `ELEMENT_NUM - 1) begin
            if(~UM_valid && ~SM_valid) begin
                SM_valid <= 1;
                SM_addr <= 0;
            end
            else if(SM_valid)
                done <= 1;
        end
        else begin
            SM_addr <= SM_addr + 1;
        end

        if(UM_valid) begin
            UM_M[UM_addr] <= UM_data;
        end
        if(SM_valid) begin
            EVT <= (~FO) & EVT;
        end
    end
end

endmodule