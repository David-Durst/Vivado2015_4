create_clock -period 2.000 -name clk -waveform {0.000 1.000} [get_ports CLK]
set_input_delay -clock clk 0 [get_ports -filter {NAME!~CLK && DIRECTION=~IN}]
set_output_delay -clock clk 0 [get_ports -filter {NAME!~CLK && DIRECTION=~OUT}]
set_clock_latency 0 [get_clocks clk]




