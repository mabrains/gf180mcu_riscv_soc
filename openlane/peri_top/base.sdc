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

## ============================================================================
## ---------------------- Timing Constraint for peri_top ----------------------
## ============================================================================

current_design peri_top

## ======== CLK ========
create_clock -name mclk -period    20.0000  [get_ports {mclk}]
create_clock -name rtc_clk -period 100.0000 [get_ports {rtc_clk}]

set_clock_groups \
   -name clock_group \
   -logically_exclusive \
   -group [get_clocks {mclk}]\
   -group [get_clocks {rtc_clk}]\
   -comment {Async Clock group}

set_clock_transition  0.1500 [all_clocks]
set_clock_uncertainty 0.2500 [all_clocks]
set_propagated_clock [all_clocks]

## ======== CLK Skew Adjust ========
set_case_analysis 0 [get_ports {cfg_cska_peri[0]}]
set_case_analysis 0 [get_ports {cfg_cska_peri[1]}]
set_case_analysis 0 [get_ports {cfg_cska_peri[2]}]
set_case_analysis 0 [get_ports {cfg_cska_peri[3]}]

# set_dont_touch { u_skew_peri.* }

## ======== IO delay ========
set_input_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {s_reset_n}]
set_input_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {s_reset_n}]

## RTC - Sys Clk
set_input_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_addr[*]}]
set_input_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_be[*]}]
set_input_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_cs}]
set_input_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_wdata[*]}]
set_input_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_wr}]

set_input_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_addr[*]}]
set_input_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_be[*]}]
set_input_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_cs}]
set_input_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_wdata[*]}]
set_input_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_wr}]

set_output_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_ack}]
set_output_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_rdata[*]}]

set_output_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_ack}]
set_output_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_rdata[*]}]

### DAC I/F
set_output_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {cfg_dac0_mux_sel[*]}]
set_output_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {cfg_dac1_mux_sel[*]}]
set_output_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {cfg_dac2_mux_sel[*]}]
set_output_delay -max 4.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {cfg_dac3_mux_sel[*]}]

set_output_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {cfg_dac0_mux_sel[*]}]
set_output_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {cfg_dac1_mux_sel[*]}]
set_output_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {cfg_dac2_mux_sel[*]}]
set_output_delay -min 1.0000 -clock [get_clocks {mclk}] -add_delay [get_ports {cfg_dac3_mux_sel[*]}]

### RTC clock domain
set_output_delay -max 4.0000 -clock [get_clocks {rtc_clk}] -add_delay [get_ports {inc_date_d}]
set_output_delay -max 4.0000 -clock [get_clocks {rtc_clk}] -add_delay [get_ports {inc_time_s}]
set_output_delay -max 4.0000 -clock [get_clocks {rtc_clk}] -add_delay [get_ports {rtc_intr}]

set_output_delay -min 1.0000 -clock [get_clocks {rtc_clk}] -add_delay [get_ports {inc_date_d}]
set_output_delay -min 1.0000 -clock [get_clocks {rtc_clk}] -add_delay [get_ports {inc_time_s}]
set_output_delay -min 1.0000 -clock [get_clocks {rtc_clk}] -add_delay [get_ports {rtc_intr}]

## ======== DRIVE/FANOUT ========
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]
set_max_fanout 10.0000 [current_design]

## ======== TIMING_DERATE ========
set ::env(SYNTH_TIMING_DERATE) 0.05
puts "\[INFO\]: Setting timing derate to: [expr {$::env(SYNTH_TIMING_DERATE) * 10}] %"
set_timing_derate -early [expr {1-$::env(SYNTH_TIMING_DERATE)}]
set_timing_derate -late [expr {1+$::env(SYNTH_TIMING_DERATE)}]
