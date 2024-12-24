
create_clock -period $cycle [get_ports clk]

set_dont_touch_network      [all_clocks]
set_fix_hold 				[all_clocks]
set_clock_uncertainty  0    [all_clocks]
set_clock_latency      0.1  [all_clocks]
set_ideal_network           [get_ports clk]

# set_clock_groups -asynchronous -group clk -group clk_mn

set_input_delay  0      -clock clk [all_inputs]
set_output_delay 0    	-clock clk [all_outputs]

set_load         1     [all_outputs]
set_drive        1     [all_inputs]

set_operating_conditions -min fast  -max fast
set_max_fanout 10 [all_inputs]


compile


#set text "[expr $param / 10]n[expr $param % 10]"

# write -format verilog -hierarchy -output "../syn/${moduleName}_syn_${text}.v"
# write -format ddc -hierarchy -output "../syn/${moduleName}_syn_${text}.ddc"
# write_sdf -version 2.1 "../syn/${moduleName}_syn_${text}.sdf"

report_timing >  ../Report/Report_${text}.txt
report_area   >> ../Report/Report_${text}.txt
report_power  >> ../Report/Report_${text}.txt
