# SPDX-FileCopyrightText: 2023 Mabrains Company
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

## ========================================================================================
## ---------------------- Timing Constraint for uart_i2c_usb_spi_top ----------------------
## ========================================================================================

current_design uart_i2c_usb_spi_top

## ======== CLK ========
create_clock -name app_clk -period 100.0000  [get_ports {app_clk}]
create_clock -name usb_clk -period 100.0000  [get_ports {usb_clk}]

set_clock_transition         0.15 [all_clocks]
set_clock_uncertainty -setup 0.4  [all_clocks]
set_clock_uncertainty -hold  0.1  [all_clocks]

set_clock_groups -name async_clock -asynchronous \
 -group [get_clocks {app_clk}]\
 -group [get_clocks {usb_clk}]

## ======== IO delay ========
set_input_delay -max 3.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {i2c_rstn}]
set_input_delay -max 3.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {uart_rstn}]
set_input_delay -max 3.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {usb_rstn}]

set_input_delay -min 1.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {i2c_rstn}]
set_input_delay -min 1.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {uart_rstn}]
set_input_delay -min 1.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {usb_rstn}]

set_input_delay -max 2.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_addr[*]}]
set_input_delay -max 4.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_be[*]}]
set_input_delay -max 3.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_cs}]
set_input_delay -max 3.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_wdata[*]}]
set_input_delay -max 3.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_wr}]

set_input_delay -min 1.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_addr[*]}]
set_input_delay -min 1.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_be[*]}]
set_input_delay -min 1.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_cs}]
set_input_delay -min 1.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_wdata[*]}]
set_input_delay -min 1.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_wr}]

set_output_delay -max  1.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_ack}]
set_output_delay -max  1.0 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_rdata[*]}]

set_output_delay -min  0.5 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_ack}]
set_output_delay -min  0.5 -clock [get_clocks {app_clk}] -add_delay [get_ports {reg_rdata[*]}]


## ======== DRIVE/FANOUT ========

set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]
set cap_load [expr $::env(SYNTH_CAP_LOAD) / 1000.0]
puts "\[INFO\]: Setting load to: $cap_load"
set_load  $cap_load [all_outputs]

set_max_transition 5.00 [current_design]
set_max_capacitance 0.5 [current_design]
set_max_fanout 20 [current_design]

## ======== TIMING_DERATE ========
set ::env(SYNTH_TIMING_DERATE) 0.05
puts "\[INFO\]: Setting timing derate to: [expr {$::env(SYNTH_TIMING_DERATE) * 10}] %"
set_timing_derate -early [expr {1-$::env(SYNTH_TIMING_DERATE)}]
set_timing_derate -late [expr {1+$::env(SYNTH_TIMING_DERATE)}]
