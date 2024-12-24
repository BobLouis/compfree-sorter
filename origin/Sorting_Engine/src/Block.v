`include "../src/parameter.v"

module Block(
    input [`ELEMENT_NUM-1:0] Data,
    input [`ELEMENT_NUM-1:0] prev_evt,
    output [`ELEMENT_NUM-1:0] nxt_evt
);

wire [`ELEMENT_NUM-1:0] Cell_ANDs;
wire Block_OR;

assign Cell_ANDs = Data & prev_evt;
assign Block_OR = | Cell_ANDs;

assign nxt_evt = Block_OR? Cell_ANDs: prev_evt;

endmodule

