`include "../src/parameter.v"
`include "../src/Block.v"
`include "../src/LED.v"

module Sorting_Engine(
    input rst,
    input clk,
    input flag,
    input [`ELEMENT_NUM-1:0] Data_in,
    // input [`INPUT_WIDTH-1:0] UM_data,
    output [`LOG2_ELEMENT_NUM-1:0] LE_Addr
);

reg [`ELEMENT_NUM-1:0] EVT;
reg [`ELEMENT_NUM-1:0] Data [0:`DATA_WIDTH-1];
wire [`ELEMENT_NUM-1:0] mid_evt [0:`DATA_WIDTH-2];
wire [`ELEMENT_NUM-1:0] FO; // Filter Output

integer i;

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

// Largest Element Detector
// one hot Decoder
LED u_LED (
    .one_hot_FO(FO),
    .LE_addr(LE_Addr)
);

reg [`LOG2_DATA_WIDTH-1:0]counter;

// EVT Update Unit
always@(posedge clk) begin
    if(rst) begin
        counter <= 0;
        for(i=0;i<`ELEMENT_NUM;i=i+1) begin
            EVT[i] <= 1;
        end
    end
    else begin
        if(~flag) begin
           counter <= counter + 1;
           Data[counter] <= Data_in;
        end
        else begin
            EVT <= (~FO) & EVT;
        end

    end
end

endmodule
