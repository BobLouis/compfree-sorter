
source .synopsys_dc.setup

# source ./ReadFile.tcl
remove_design -all

# analyze -format verilog ../src/Sorter.v -autoread
# link
# report_hierarchy

read_file ../src/Sorting_Engine.v

current_design Sorting_Engine

set clk_start  50
set clk_end    62
set clk_step   2

for {set param $clk_start} {$param <= $clk_end} {incr param $clk_step} {
  set cycle [expr double($param) / 100] 
  set text [format "%dn%02d" [expr $param / 100] [expr $param % 100]]
  set moduleName "Sorting_Engine"
  set folder "n32_N16"

  source ./Opt.sdc
}

exit
