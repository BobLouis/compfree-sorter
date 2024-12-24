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

// genvar i;
// generate
//     for(i=0; i<`ELEMENT_NUM; i=i+1) begin : N_Cells
//         Cell u_Cell (
//             .data_bit(Data[i]),
//             .previous(prev_evt[i]),
//             .block_or(Block_OR),
//             .out_and(Cell_ANDs[i]),
//             .next(nxt_evt[i])
//         );
//     end
// endgenerate

endmodule

