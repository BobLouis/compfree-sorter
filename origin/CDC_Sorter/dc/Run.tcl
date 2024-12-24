source .synopsys_dc.setup

# source ./ReadFile.tcl
remove_design -all

analyze -format verilog ../src/Sorter.v -autoread
read_file ../src/Sorter.v

current_design Sorter

# define clk_mj & clk_mn
# unit = 0.01 ns
set clk_mj_start 853
set clk_mj_end 855
set clk_mj_step 2

set clk_mn_start 126
set clk_mn_end 130
set clk_mn_step 2

# 2step for-loop
for {set clk_mj $clk_mj_start} {$clk_mj <= $clk_mj_end} {incr clk_mj $clk_mj_step} {
    for {set clk_mn $clk_mn_start} {$clk_mn <= $clk_mn_end} {incr clk_mn $clk_mn_step} {
        
        # set cycle to ns
        set cycle_mj [expr double($clk_mj) / 100]
        set cycle_mn [expr double($clk_mn) / 100]

        # file name
        set text_mj [format "%dj%02d" [expr $clk_mj / 100] [expr $clk_mj % 100]]
        set text_mn [format "%dn%02d" [expr $clk_mn / 100] [expr $clk_mn % 100]]
        set text "${text_mj}_${text_mn}"

        set moduleName "Sorter"

        # folder named by parameter
        set folder "n32_N256"

        # execute sdc file
        source ./Opt.sdc
    }
}

exit
