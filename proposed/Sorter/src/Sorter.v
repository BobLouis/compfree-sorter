`include "../src/parameter.v"
`include "../src/Sorting_Engine.v"
`include "../src/UM.v"

module Sorter(
    input rst,
    input clk,
    input UM_valid,
    input [`DATA_WIDTH-1:0] UM_data,
    output SM_valid,
    output reg [`LOG2_ELEMENT_NUM-1:0] SM_addr,
    output [`DATA_WIDTH-1:0] SM_data,
    output reg done
);

wire [`LOG2_ELEMENT_NUM-1:0] LE_Addr;

wire [`LOG2_ELEMENT_NUM-1:0] UM_addr = (UM_valid)? SM_addr: LE_Addr;
wire [`ELEMENT_NUM-1:0] bit_data;
wire [`LOG2_DATA_WIDTH-1:0] bit_addr;

Sorting_Engine u_Sorting_Engine (
    .rst(rst),
    .clk(clk),
    .flag(UM_valid),
    .bit_data(bit_data), // input
    .bit_addr(bit_addr), // output
    .LE_Addr(LE_Addr),
    .SM_valid(SM_valid)
);

UM u_UM (
    .rst(rst),
    .clk(clk),
    .in_valid(UM_valid),
    .in_data(UM_data),
    .UM_addr(UM_addr),
    .bit_addr(bit_addr), // input
    .bit_data(bit_data), // output
    .out_data(SM_data)
);

// reg [`LOG2_ELEMENT_NUM-1:0] counter;

always@(posedge clk or posedge rst) begin
    if(rst) begin
        SM_addr <= 0; // used as counter at first
        done <= 0;
    end
    else begin
        if(SM_addr == `ELEMENT_NUM - 1) begin
            if(~UM_valid && ~SM_valid) begin
                SM_addr <= 0;
            end
            else if(SM_valid)
                done <= 1;
        end
        else begin
            if(SM_valid || UM_valid) begin
                SM_addr <= SM_addr + 1;
            end
        end
    end
end

endmodule