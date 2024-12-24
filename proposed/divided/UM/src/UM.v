`include "../src/parameter.v"

// #(parameter DEPTH = 127, MEM_INIT_FILE = "")

module UM (
    input rst,
    input clk,
    input in_valid,
    input [`DATA_WIDTH-1:0] in_data,
    input [`LOG2_ELEMENT_NUM-1:0] UM_addr,
    input [`LOG2_DATA_WIDTH-1:0] bit_addr,

    output reg [`ELEMENT_NUM-1:0] bit_data,
    output [`DATA_WIDTH-1:0] out_data
);

reg [`DATA_WIDTH-1:0] UM_M [0:`ELEMENT_NUM-1];
reg [`ELEMENT_NUM-1:0] temp_bit;

assign out_data = UM_M[UM_addr];

integer i;
always @(*) begin
    for(i = 0; i < `ELEMENT_NUM; i=i+1) begin
        temp_bit[i] = UM_M[i][bit_addr];
    end
    if(bit_addr == `DATA_WIDTH - 1)
        bit_data = ~temp_bit; // signed number need to reverse MSB
    else
        bit_data = temp_bit;
end

integer j;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        for (j=0; j<`ELEMENT_NUM; j=j+1) UM_M[j] <= 0;
    end
    else begin
        if(in_valid) begin
            UM_M[UM_addr] <= in_data;
        end
    end
end

endmodule