`include "../src/parameter.v"

module LDED( // Largest and Duplicate Element Detector
    input clk,
    input rst,
    input in_valid,
    input [`ELEMENT_NUM-1:0] FO,
    output out_valid,
    output reg [`LOG2_ELEMENT_NUM-1:0] LE_Addr
);


reg [`ELEMENT_NUM-1:0] Temp_Reg, TR_nxt;
assign out_valid = |Temp_Reg;

always@(posedge clk or posedge rst) begin
    if(rst) begin
        Temp_Reg <= 0;
    end
    else begin
        if(in_valid) begin
            Temp_Reg <= FO;
        end
        else begin
            Temp_Reg <= TR_nxt;
        end
    end
end

always@(*) begin
    // assume ELEMENT_NUM = 16
    // 16 ELEMENT DECODER
    TR_nxt = Temp_Reg;
    casez(Temp_Reg)
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

// integer i,j;
// reg test0;
// reg [`LOG2_ELEMENT_NUM-1:0] LE_Addr_i,LE_Addr_j;
// reg [`ELEMENT_NUM-1:0] TR_nxt_i, TR_nxt_j;
// always@(*) begin
//     TR_nxt = Temp_Reg;
//     test0 = 0
//     for (i = 7;i >= 0;i = i - 1) begin
//         if(Temp_Reg[i] == 1) begin
//             LE_Addr_i   = i;
//             TR_nxt_i[i] = 0;
//             test0 = 1;
//         end
//     end
//     for (j = 15;j >= 7;j = j - 1) begin
//         if(Temp_Reg[j] == 1) begin
//             LE_Addr_j   = j;
//             TR_nxt_j[j] = 0;
//         end
//     end
//     if(test0 == 1)begin
//         LE_Addr = LE_Addr_i;
//         TR_nxt = TR_nxt_i;
//     end
//     else begin
//         LE_Addr = LE_Addr_j;
//         TR_nxt = TR_nxt_j;
//     end
// end