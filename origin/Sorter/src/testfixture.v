`timescale 1ns / 100ps

`define CYCLE   5.6
`define End_CYCLE 10000

`include "../src/parameter.v"
`define SDFFILE "../syn/Sorter_syn_5n60.sdf"

module Sorter_tb;

reg rst;
reg clk;
reg UM_valid;
reg [`DATA_WIDTH-1:0] UM_data;

wire SM_valid;
wire [`LOG2_ELEMENT_NUM-1:0] SM_addr;
wire [`DATA_WIDTH-1:0] SM_data;
wire done;

// Sorter
Sorter u_Sorter (
    .rst(rst),
    .clk(clk),
    .UM_valid(UM_valid),
    .UM_data(UM_data),

    .SM_valid(SM_valid),
    .SM_addr(SM_addr),
    .SM_data(SM_data),
    .done(done)
);

`ifdef SDF
  initial $sdf_annotate(`SDFFILE, u_Sorter);
`endif

// Sorted Mermory
SM u_SM (
    .rst(rst),
    .clk(clk),
    .SM_valid(SM_valid),
    .SM_addr(SM_addr),
    .SM_data(SM_data)
);

// read from dat
reg [`DATA_WIDTH-1:0] pattern_data [`ELEMENT_NUM-1:0]; // pattern data array
reg [`DATA_WIDTH-1:0] golden_data [`ELEMENT_NUM-1:0];  // golden data array

initial begin
    $readmemh("../../../dat/n32_N16/pattern0.dat", pattern_data, 0, `ELEMENT_NUM-1);
    $readmemh("../../../dat/n32_N16/golden0.dat", golden_data, 0, `ELEMENT_NUM-1);
end

// clk and rst
always begin #(`CYCLE/2) clk = ~clk; end

initial begin
    clk = 0;
    rst = 1;
    #(`CYCLE);
    @(posedge clk); #2 rst = 0;
end


integer cycle=0;

always @(posedge clk) begin
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

always@(negedge clk) begin
    if(rst) begin
        UM_valid <= 0;
        UM_addr <= -1;
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
reg [`LOG2_ELEMENT_NUM-1:0] err = 0;

initial @(posedge done)begin
    for(k=0;k<`ELEMENT_NUM;k=k+1)begin
        if(u_SM.SM_M[k] == golden_data[k]) begin
            $display("PASS at %d: output %h matches expected %h", k, u_SM.SM_M[k], golden_data[k]);
        end
        else begin
            $display("ERROR at %d: output %h != expect %h ",k, u_SM.SM_M[k], golden_data[k]);
            err = err + 1;
        end
    end
    #10 $finish;
    // if(err == 0) begin
    //     $display(" ****************************               ");
    //     $display(" **                        **       |\__||  ");
    //     $display(" **  Congratulations !!    **      / O.O  | ");
    //     $display(" **                        **    /_____   | ");
    //     $display(" **  Simulation PASS !!    **   /^ ^ ^ \\  |");
    //     $display(" **                        **  |^ ^ ^ ^ |w| ");
    //     $display(" ****************************   \\m___m__|_|");
    //     #10 $finish;
    // end
    // else begin 
    //     $display(" ****************************               ");
    //     $display(" **                        **       |\__||  ");
    //     $display(" **  OOPS!!                **      / X,X  | ");
    //     $display(" **                        **    /_____   | ");
    //     $display(" **  There are %3d errors! **   /^ ^ ^ \\  |", err);
    //     $display(" **                        **  |^ ^ ^ ^ |W| ");
    //     $display(" ****************************   \\m___m__|_|");
    //     #10 $finish;
    // end
end


initial begin
    $dumpfile("sorter_wave.fsdb");
    $dumpvars(0, Sorter_tb); 
end

endmodule


module SM ( // Sorted Memory
    input rst,
    input clk,
    input SM_valid,
    input [`LOG2_ELEMENT_NUM-1:0] SM_addr,
    input [`DATA_WIDTH-1:0] SM_data
);

reg [`DATA_WIDTH-1:0] SM_M [0:`ELEMENT_NUM-1];
integer i;

// initial begin
//     for (i=0; i<`ELEMENT_NUM; i=i+1) SM_M[i] = 0;
// end

always@(negedge clk)
    if(rst) begin
        for (i=0; i<`ELEMENT_NUM; i=i+1) SM_M[i] <= 0;
    end
    else begin
        if(SM_valid) SM_M[SM_addr] <= SM_data;
    end

endmodule