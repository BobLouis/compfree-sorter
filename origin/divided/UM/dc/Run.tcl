source .synopsys_dc.setup

# source ./ReadFile.tcl
remove_design -all

read_file ../src/UM.v

current_design UM

# define clk & clk_mn
# unit = 0.01 ns
set clk_start 45
set clk_end 60
set clk_step 5

# 2step for-loop
for {set clk $clk_start} {$clk <= $clk_end} {incr clk $clk_step} {
    # set cycle to ns
    set cycle [expr double($clk) / 100]

    # file name
    set text "[expr $clk / 100]n[format "%02d" [expr $clk % 100]]"
    set text "${text}"

    set moduleName "UM"

    # folder named by parameter
    set folder "n32_N16"
    
    # execute sdc file
    source ./Opt.sdc
}

exit
