`include "../src/parameter.v"

module LDED( // Largest and Duplicate Element Detector
    input rst,
    input clk_mn,
    input [`ELEMENT_NUM-1:0] FO_mj_reg,
    input mode,
    input mj_level,
    output SM_valid,
    output reg TR_empty, // reg, output to mj
    output reg [`LOG2_ELEMENT_NUM-1:0] LE_Addr // wire
);

// assume clk_mj > 4 * clk_mn ??

reg mn_level_sync[0:2];
wire mn_pulse = mn_level_sync[1] ^ mn_level_sync[2]; // XOR

reg [`ELEMENT_NUM-1:0] Temp_Reg;
reg [`ELEMENT_NUM-1:0] TR_nxt;

// wait for mn_pulse, which means FO_mj_reg is stable
wire [`ELEMENT_NUM-1:0] TR_comb = (mn_pulse)? FO_mj_reg: Temp_Reg;

wire one_one = (|TR_comb) && (TR_comb == (TR_comb & -TR_comb));
assign SM_valid = |TR_comb;

// minor clock domain
always@(posedge clk_mn) begin
    if(rst) begin
        Temp_Reg <= 0;
        TR_empty <= 1;
    end
    else if(mode) begin // Sorting output mode
        Temp_Reg <= TR_nxt;

        // if there is one left in TR, then next cycle set empty=1
        TR_empty <= (!SM_valid || one_one)? 1: 0;
    end
end

always@(posedge clk_mn) begin
    mn_level_sync[0] <= mj_level; // mn_level_sync[0] may be metastable
    mn_level_sync[1] <= mn_level_sync[0]; // mn_level_sync[1] won't be metastable
    mn_level_sync[2] <= mn_level_sync[1];
end

always@(*) begin
    // assume ELEMENT_NUM = 16
    // 16 ELEMENT DECODER
    TR_nxt = TR_comb;
    casez(TR_comb)
        16'b????_????_????_???1: begin LE_Addr = 0;	    TR_nxt[0]	= 0; end
        16'b????_????_????_??10: begin LE_Addr = 1;	    TR_nxt[1]	= 0; end
        16'b????_????_????_?100: begin LE_Addr = 2;	    TR_nxt[2]	= 0; end
        16'b????_????_????_1000: begin LE_Addr = 3;	    TR_nxt[3]	= 0; end
        16'b????_????_???1_0000: begin LE_Addr = 4;	    TR_nxt[4]	= 0; end
        16'b????_????_??10_0000: begin LE_Addr = 5;	    TR_nxt[5]	= 0; end
        16'b????_????_?100_0000: begin LE_Addr = 6;	    TR_nxt[6]	= 0; end
        16'b????_????_1000_0000: begin LE_Addr = 7;	    TR_nxt[7]	= 0; end
        16'b????_???1_0000_0000: begin LE_Addr = 8;	    TR_nxt[8]	= 0; end
        16'b????_??10_0000_0000: begin LE_Addr = 9;	    TR_nxt[9]	= 0; end
        16'b????_?100_0000_0000: begin LE_Addr = 10;	TR_nxt[10]	= 0; end
        16'b????_1000_0000_0000: begin LE_Addr = 11;	TR_nxt[11]	= 0; end
        16'b???1_0000_0000_0000: begin LE_Addr = 12;	TR_nxt[12]	= 0; end
        16'b??10_0000_0000_0000: begin LE_Addr = 13;	TR_nxt[13]	= 0; end
        16'b?100_0000_0000_0000: begin LE_Addr = 14;	TR_nxt[14]	= 0; end
        16'b1000_0000_0000_0000: begin LE_Addr = 15;	TR_nxt[15]	= 0; end
        default: begin LE_Addr = 0;	TR_nxt	= 0; end
    endcase
end

endmodule