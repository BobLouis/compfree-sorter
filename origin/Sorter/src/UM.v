`include "../src/parameter.v"

// #(parameter DEPTH = 127, MEM_INIT_FILE = "")

module UM (
    input rst,
    input clk,
    input in_valid,
    input [`DATA_WIDTH-1:0] in_data,
    input [`LOG2_ELEMENT_NUM-1:0] UM_addr,

    output reg [`INPUT_WIDTH-1:0] whole_UM,
    output [`DATA_WIDTH-1:0] out_data
);

reg [`DATA_WIDTH-1:0] UM_M [0:`ELEMENT_NUM-1];

assign out_data = UM_M[UM_addr];

genvar i;
generate
    for (i=0; i<`ELEMENT_NUM; i=i+1) begin : mem_block
        always @(UM_M[i]) begin
            whole_UM[(i+1)*`DATA_WIDTH-1:i*`DATA_WIDTH] = UM_M[i];
        end
    end
endgenerate

integer j;
always @(posedge clk) begin
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