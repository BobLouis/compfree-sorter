
create_clock -period $cycle_mj [get_ports clk_mj]
create_clock -period $cycle_mn [get_ports clk_mn]

set_dont_touch_network      [all_clocks]
set_fix_hold 				[all_clocks]
set_clock_uncertainty  0    [all_clocks]
set_clock_latency      0.1  [all_clocks]
set_ideal_network           [get_ports clk_mj]
set_ideal_network           [get_ports clk_mn]

set clk_mj_inputs   [list clk_mj rst]
set clk_mn_inputs   [list clk_mn UM_valid UM_data]
set clk_mn_outputs  [all_outputs]
# set clk_mn_outputs  [list SM_valid SM_addr SM_data done]

set_clock_groups -asynchronous -group clk_mj -group clk_mn

set_input_delay  0      -clock clk_mj [get_ports $clk_mj_inputs]
set_input_delay  0      -clock clk_mn [get_ports $clk_mn_inputs]
set_output_delay 0    	-clock clk_mn [get_ports $clk_mn_outputs]

set_load         1     [all_outputs]
set_drive        1     [all_inputs]

set_operating_conditions -min fast  -max fast
set_max_fanout 10 [all_inputs]


compile


#set text "[expr $param / 10]n[expr $param % 10]"

write -format verilog -hierarchy -output "../syn/${folder}/${moduleName}_syn_${text}.v"
write -format ddc -hierarchy -output "../syn/${folder}/${moduleName}_syn_${text}.ddc"
write_sdf -version 2.1 "../syn/${folder}/${moduleName}_syn_${text}.sdf"

report_timing >  ../Report/${folder}/Report_${text}.txt
report_area   >> ../Report/${folder}/Report_${text}.txt
report_power  >> ../Report/${folder}/Report_${text}.txt
