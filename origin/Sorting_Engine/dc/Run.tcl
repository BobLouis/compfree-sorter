
source .synopsys_dc.setup

# source ./ReadFile.tcl
remove_design -all

analyze -format verilog ../src/Sorting_Engine.v -autoread
# link
# report_hierarchy

read_file ../src/Sorting_Engine.v

current_design Sorting_Engine

for {set param 510} {$param <= 530} {incr param 10} {
  set cycle [expr double($param) / 100] 
  set text "[expr $param / 100]n[expr $param % 100]"
  set moduleName "Sorting_Engine"
  source ./Opt.sdc
}

exit
