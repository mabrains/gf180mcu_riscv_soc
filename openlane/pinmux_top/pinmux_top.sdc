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
## --------------------- Timing Constraint for pinmux_top ---------------------
## ============================================================================

current_design pinmux_top

## ======== CLK ========
create_clock -name mclk        -period 100.0000 [get_ports {mclk}]
create_clock -name user_clock1 -period 100.0000 [get_ports {user_clock1}]
create_clock -name user_clock2 -period 100.0000 [get_ports {user_clock2}]
create_clock -name rtc_clk     -period 100.0000 [get_pins {u_glbl_reg.u_clkbuf_rtc.u_buf/Z}]

set_clock_groups \
   -name clock_group \
   -logically_exclusive \
   -group [get_clocks {mclk}]\
   -group [get_clocks {user_clock1}]\
   -group [get_clocks {user_clock2}]\
   -group [get_clocks {rtc_clk}]\
   -comment {Async Clock group}

set_clock_transition         0.15 [all_clocks]
set_clock_uncertainty -setup 0.50 [all_clocks]
set_clock_uncertainty -hold  0.25 [all_clocks]
set_propagated_clock [all_clocks]

## ======== I/O delay ========
set_input_delay -max 10.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_addr[*]}]
set_input_delay -max 10.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_be[*]}]
set_input_delay -max 10.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_cs}]
set_input_delay -max 10.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_wdata[*]}]
set_input_delay -max 10.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_wr}]

set_input_delay -min 7.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_addr[*]}]
set_input_delay -min 7.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_be[*]}]
set_input_delay -min 7.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_cs}]
set_input_delay -min 7.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_wdata[*]}]
set_input_delay -min 7.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_wr}]

set_output_delay -max 10.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_ack}]
set_output_delay -max 10.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_rdata[*]}]

set_output_delay -min 7.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_ack}]
set_output_delay -min 7.00 -clock [get_clocks {mclk}] -add_delay [get_ports {reg_rdata[*]}]

## ======== DRIVE/FANOUT ========
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]

set_max_transition 5.00 [current_design]
set_max_capacitance 1.0 [current_design]
set_max_fanout 20 [current_design]
