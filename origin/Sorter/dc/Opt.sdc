#set cycle [expr double($param) / 10]         ;#clock period defined by designer

create_clock -period $cycle [get_ports  clk]
set_fix_hold 				[get_clocks clk]
set_clock_uncertainty  0  [get_clocks clk]
set_clock_latency      0.1  [get_clocks clk]

set_input_delay  0      -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 0    	-clock clk [all_outputs] 
set_load         1     [all_outputs]
set_drive        1     [all_inputs]

set_operating_conditions -min fast  -max fast                     

set_max_fanout 10 [all_inputs]

set_dont_touch_network      [get_clocks clk]

# compile  -map_effort high
compile

# optimize_registers

# #set_max_area 0

# compile

#compile_ultra

#set text "[expr $param / 10]n[expr $param % 10]"

write -format verilog -hierarchy -output "../syn/${moduleName}_syn_${text}.v"
write -format ddc -hierarchy -output "../syn/${moduleName}_syn_${text}.ddc"
write_sdf -version 2.1 "../syn/${moduleName}_syn_${text}.sdf"

report_timing >  ../Report/Report_${text}.txt
report_area   >> ../Report/Report_${text}.txt
report_power  >> ../Report/Report_${text}.txt
