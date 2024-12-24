`include "../src/parameter.v"
`include "../src/Sorting_Engine.v"
`include "../src/UM.v"

module Sorter(
    input rst,
    input clk_mj,
    input clk_mn,
    input UM_valid,
    input [`DATA_WIDTH-1:0] UM_data,

    output SM_valid,
    output reg [`LOG2_ELEMENT_NUM-1:0] SM_addr,
    output [`DATA_WIDTH-1:0] SM_data,
    output reg done
);

wire [`LOG2_ELEMENT_NUM-1:0] LE_Addr;

wire [`LOG2_ELEMENT_NUM-1:0] UM_addr = (UM_valid)? SM_addr: LE_Addr;
wire [`INPUT_WIDTH-1:0] whole_UM;
reg mode; // 0: UM input, 1: Sorting output

Sorting_Engine u_Sorting_Engine (
    .rst(rst),
    .clk_mj(clk_mj),
    .clk_mn(clk_mn),
    .mode(mode),
    .whole_UM(whole_UM),
    .SM_valid(SM_valid),
    .LE_Addr(LE_Addr)
);

UM u_UM (
    .rst(rst),
    .clk_mn(clk_mn),
    .in_valid(UM_valid),
    .in_data(UM_data),
    .UM_addr(UM_addr),
    .whole_UM(whole_UM),
    .out_data(SM_data)
);

// reg [`LOG2_ELEMENT_NUM-1:0] counter;

always@(posedge clk_mn or posedge rst) begin
    if(rst) begin
        SM_addr <= 0; // used as counter at first
        mode <= 0; // 0: UM input, 1: Sorting output
        done <= 0;
    end
    else begin
        if(SM_addr == `ELEMENT_NUM - 1) begin
            // UM input finish, and not yet turn into sorting output mode
            if(~UM_valid && ~mode) begin
                mode <= 1;
                SM_addr <= 0;
            end
            else if(SM_valid)
                done <= 1;
        end
        else if(UM_valid || SM_valid) begin
            SM_addr <= SM_addr + 1;
        end
    end
end

endmodule