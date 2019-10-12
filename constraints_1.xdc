create_clock -period 1.000 -name clk -waveform {0.000 0.500} [get_ports CLK]
set_input_delay 0 [get_ports -filter {NAME!~CLK && DIRECTION=~OUT}]
set_output_delay 0 [get_ports -filter {NAME!~CLK && DIRECTION=~OUT}]





