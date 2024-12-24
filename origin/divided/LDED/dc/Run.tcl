source .synopsys_dc.setup

# source ./ReadFile.tcl
remove_design -all

read_file ../src/LDED.v

current_design LDED

# define clk & clk_mn
# unit = 0.01 ns
set clk_start 31
set clk_end 34
set clk_step 1

# 2step for-loop
for {set clk $clk_start} {$clk <= $clk_end} {incr clk $clk_step} {
    # set cycle to ns
    set cycle [expr double($clk) / 100]

    # file name
    set text "[expr $clk / 100]n[format "%02d" [expr $clk % 100]]"
    set text "${text}"

    set moduleName "LDED"

    # execute sdc file
    source ./Opt.sdc
}

exit
