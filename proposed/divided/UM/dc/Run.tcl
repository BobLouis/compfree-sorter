
source .synopsys_dc.setup

# source ./ReadFile.tcl
remove_design -all

# analyze -format verilog ../src/Sorter.v -autoread
# link
# report_hierarchy

read_file ../src/UM.v

current_design UM

set clk_start  40
set clk_end    48
set clk_step   2

for {set param $clk_start} {$param <= $clk_end} {incr param $clk_step} {
  set cycle [expr double($param) / 100] 
  set text [format "%dn%02d" [expr $param / 100] [expr $param % 100]]
  set moduleName "UM"
  set folder "n32_N16"

  source ./Opt.sdc
}

exit
