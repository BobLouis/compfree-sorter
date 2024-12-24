`timescale 1ns / 10ps
`define CYCLE_MJ   8.4
`define CYCLE_MN   2.1
`define End_CYCLE 10000

`include "../src/parameter.v"
`define SDFFILE "../syn/n32_N128/Sorter_syn_7j80_1n18.sdf"

module Sorter_tb;

reg rst;
reg clk_mj;
reg clk_mn;
reg UM_valid;
reg [`DATA_WIDTH-1:0] UM_data;

wire SM_valid;
wire [`LOG2_ELEMENT_NUM-1:0] SM_addr;
wire [`DATA_WIDTH-1:0] SM_data;
wire done;

// read from dat
reg [`DATA_WIDTH-1:0] pattern_data [`ELEMENT_NUM-1:0]; // pattern data array
reg [`DATA_WIDTH-1:0] golden_data [`ELEMENT_NUM-1:0];  // golden data array

initial begin
    `ifdef P1
        $display("Pattern 1");
        $readmemh("../../../dat/n32_N128/pattern1.dat", pattern_data, 0, `ELEMENT_NUM-1);
        $readmemh("../../../dat/n32_N128/golden1.dat", golden_data, 0, `ELEMENT_NUM-1);
    `elsif P2
        $display("Pattern 2");
        $readmemh("../../../dat/n32_N128/pattern2.dat", pattern_data, 0, `ELEMENT_NUM-1);
        $readmemh("../../../dat/n32_N128/golden2.dat", golden_data, 0, `ELEMENT_NUM-1);
    `elsif P3
        $display("Pattern 3");
        $readmemh("../../../dat/n32_N128/pattern3.dat", pattern_data, 0, `ELEMENT_NUM-1);
        $readmemh("../../../dat/n32_N128/golden3.dat", golden_data, 0, `ELEMENT_NUM-1);
    `else
        $display("Pattern 0");
        $readmemh("../../../dat/n32_N128/pattern0.dat", pattern_data, 0, `ELEMENT_NUM-1);
        $readmemh("../../../dat/n32_N128/golden0.dat", golden_data, 0, `ELEMENT_NUM-1);
    `endif
end

// Sorter
Sorter u_Sorter (
    .rst(rst),
    .clk_mj(clk_mj),
    .clk_mn(clk_mn),
    .UM_valid(UM_valid),
    .UM_data(UM_data),

    .SM_valid(SM_valid),
    .SM_addr(SM_addr),
    .SM_data(SM_data),
    .done(done)
);

// Sorted Mermory
SM u_SM (
    .rst(rst),
    .clk_mn(clk_mn),
    .SM_valid(SM_valid),
    .SM_addr(SM_addr),
    .SM_data(SM_data)
);

`ifdef SDF
    initial begin
        $sdf_annotate(`SDFFILE, u_Sorter);

        $fsdbDumpfile("Sorter_post.fsdb");
        $fsdbDumpvars();
        $fsdbDumpMDA;
    end
`else
    initial begin
        $fsdbDumpfile("Sorter_pre.fsdb");
        $fsdbDumpvars();
        $fsdbDumpMDA;
  end
`endif

// clk_mj, clk_mn, and rst
always begin #(`CYCLE_MJ/2) clk_mj = ~clk_mj; end
always begin #(`CYCLE_MN/2) clk_mn = ~clk_mn; end

initial begin
    clk_mj = 0;
    clk_mn = 0;
    rst = 1;
    #(`CYCLE_MJ);
    @(posedge clk_mj); #2 rst = 0;
end


integer cycle=0;

always @(posedge clk_mj) begin
    cycle = cycle + 1;
    if(cycle > `End_CYCLE) begin
        $display("------------------------------------");
        $display("--- Failed Waiting done signal ! ---");
        $display("--------- Simulation STOP! ---------");
        $display("------------------------------------");
        $finish;
    end
end

reg [`LOG2_ELEMENT_NUM-1:0] UM_addr;
reg flag;
wire [`LOG2_ELEMENT_NUM-1:0] UM_addr_plus1 = UM_addr + 1;

always@(negedge clk_mn) begin
    if(rst) begin
        UM_valid <= 0;
        UM_addr <= -1; // init = `ELEMENT_NUM-1 
        flag <= 0;
    end
    else begin
        if(UM_addr == `ELEMENT_NUM-1 && flag) begin
            UM_valid <= 0;
        end
        else begin
            flag <= 1;
            UM_valid <= 1;
            UM_addr <= UM_addr + 1;
            UM_data <= pattern_data[UM_addr_plus1];
        end
    end
end

integer k;
integer err;

initial @(posedge done)begin
    err = 0;
    for(k=0;k<`ELEMENT_NUM;k=k+1)begin
        if(u_SM.SM_M[k] == golden_data[k]) begin
            // $display("PASS at %d: output %h matches expected %h", k, u_SM.SM_M[k], golden_data[k]);
        end
        else begin
            $display("ERROR at %d: output %h != expect %h ",k, u_SM.SM_M[k], golden_data[k]);
            err = err + 1;
        end
    end
    // #10 $finish;
    if(err == 0) begin
        $display(" ****************************               ");
        $display(" **                        **       |\__||  ");
        $display(" **  Congratulations !!    **      / O.O  | ");
        $display(" **                        **    /_____   | ");
        $display(" **  Simulation PASS !!    **   /^ ^ ^ \\  |");
        $display(" **                        **  |^ ^ ^ ^ |w| ");
        $display(" ****************************   \\m___m__|_|");
        #10 $finish;
    end
    else begin 
        $display(" ****************************               ");
        $display(" **                        **       |\__||  ");
        $display(" **  OOPS!!                **      / X,X  | ");
        $display(" **                        **    /_____   | ");
        $display(" **  There are %3d errors! **   /^ ^ ^ \\  |", err);
        $display(" **                        **  |^ ^ ^ ^ |W| ");
        $display(" ****************************   \\m___m__|_|");
        #10 $finish;
    end
end


endmodule


module SM ( // Sorted Memory
    input rst,
    input clk_mn, // minor clock
    input SM_valid,
    input [`LOG2_ELEMENT_NUM-1:0] SM_addr,
    input [`DATA_WIDTH-1:0] SM_data
);

reg [`DATA_WIDTH-1:0] SM_M [0:`ELEMENT_NUM-1];
integer i;

always@(negedge clk_mn)
    if(rst) begin
        for (i=0; i<`ELEMENT_NUM; i=i+1) SM_M[i] <= 0;
    end
    else begin
        if(SM_valid) SM_M[SM_addr] <= SM_data;
    end

endmodule