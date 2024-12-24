`include "../src/parameter.v"

module Block(
    input [`ELEMENT_NUM-1:0] Data,
    input [`ELEMENT_NUM-1:0] prev_evt,
    output [`ELEMENT_NUM-1:0] nxt_evt
);

wire [`ELEMENT_NUM-1:0] Cell_ANDs;
wire Block_OR;

// 1 NOT = 1 NAND
// 1 AND = 2 NAND
// 1 OR  = 3 NAND

// 16 AND = 32 NAND
assign Cell_ANDs = Data & prev_evt;

// 15 OR = 45 NAND
assign Block_OR = | Cell_ANDs;

// MUX: 1 NOT + 2 AND + 1 OR = 8 NAND => 16 MUX = 128 NAND
assign nxt_evt = Block_OR? Cell_ANDs: prev_evt;

// Total 32 blocks => (32+45+128)*32 = 6560

//205

endmodule

// Area?
// 1 NAND = 4 CMOS
// 1 NOT = 2 CMOS = 0.5 NAND
// 1 AND = 6 CMOS = 1.5 NAND
// 1 OR  = 6 CMOS = 1.5 NAND

// => (16*1.5 + 15*1.5 + (0.5 + 2*1.5 + 1.5)*16) * 32
//  = (24 + 22.5 + 80)*32
//  = 2606.5
