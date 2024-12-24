source .synopsys_dc.setup

# source ./ReadFile.tcl
remove_design -all

read_file ../src/Block.v

current_design Block

# define clk & clk_mn
# unit = 0.01 ns
set clk_start 30
set clk_end 30
set clk_step 1

# 2step for-loop
for {set clk $clk_start} {$clk <= $clk_end} {incr clk $clk_step} {
    # set cycle to ns
    set cycle [expr double($clk) / 100]

    # file name
    set text "[expr $clk / 100]n[format "%02d" [expr $clk % 100]]"
    set text "${text}"

    set moduleName "Single_Block"

    # execute sdc file
    source ./Opt.sdc
}

exit
