###############################################################################
# Created by write_sdc
# Sun Nov 19 16:25:32 2023
###############################################################################
current_design temp_sensor
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 100.0000 [get_ports {io_in[0]}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_in[1]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_in[1]}]
set_input_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_in[2]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_in[2]}]
set_input_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_in[3]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_in[3]}]
set_input_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_in[4]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_in[4]}]
set_input_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_in[5]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_in[5]}]
set_input_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_in[6]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_in[6]}]
set_input_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_in[7]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_in[7]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_out[0]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_out[0]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_out[1]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_out[1]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_out[2]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_out[2]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_out[3]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_out[3]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_out[4]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_out[4]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_out[5]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_out[5]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_out[6]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_out[6]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {io_out[7]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {io_out[7]}]
###############################################################################
# Environment
###############################################################################
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {io_in[7]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {io_in[6]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {io_in[5]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {io_in[4]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {io_in[3]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {io_in[2]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {io_in[1]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {io_in[0]}]
###############################################################################
# Design Rules
###############################################################################
set_max_transition 5.0000 [current_design]
set_max_capacitance 1.0000 [current_design]
set_max_fanout 20.0000 [current_design]
