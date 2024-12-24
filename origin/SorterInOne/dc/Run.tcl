
source .synopsys_dc.setup

# source ./ReadFile.tcl
remove_design -all

analyze -format verilog ../src/Sorter.v -autoread
# link
# report_hierarchy

read_file ../src/Sorter.v

current_design Sorter

for {set param 540} {$param <= 600} {incr param 20} {
  set cycle [expr double($param) / 100] 
  set text "[expr $param / 100]n[expr $param % 100]"
  set moduleName "Sorter"
  source ./Opt.sdc
}

exit
