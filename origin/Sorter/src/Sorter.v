`include "../src/parameter.v"
`include "../src/Sorting_Engine.v"
`include "../src/UM.v"

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
wire [`INPUT_WIDTH-1:0] whole_UM;

Sorting_Engine u_Sorting_Engine (
    // .rst(rst),
    .clk(clk),
    .flag(SM_valid),
    .UM_data(whole_UM),
    .LE_Addr(LE_Addr)
);

UM u_UM (
    .rst(rst),
    .clk(clk),
    .in_valid(UM_valid),
    .in_data(UM_data),
    .UM_addr(UM_addr),
    .whole_UM(whole_UM),
    .out_data(SM_data)
);

// reg [`LOG2_ELEMENT_NUM-1:0] counter;

always@(posedge clk or posedge rst) begin
    if(rst) begin
        SM_addr <= 0; // used as counter at first
        SM_valid <= 0; // 0: UM input, 1: Sorting output
        done <= 0;
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
    end
end

endmodule