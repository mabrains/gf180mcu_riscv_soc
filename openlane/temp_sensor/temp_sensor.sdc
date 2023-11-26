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

current_design temp_sensor

## ======== CLK ========
create_clock -name clk -period    100.00  [get_ports {clk}]

set_clock_transition  0.15 [all_clocks]
set_clock_uncertainty 0.25 [all_clocks]
set_propagated_clock [all_clocks]

## ======== I/O delay ========
set_input_delay -min 5.0  -clock [get_clocks {clk}] -add_delay [get_ports {io_in[*]}]
set_input_delay -max 10.0 -clock [get_clocks {clk}] -add_delay [get_ports {io_in[*]}]

set_output_delay -min  5.0  -clock [get_clocks {clk}] -add_delay [get_ports {io_out[*]}]
set_output_delay -max  10.0 -clock [get_clocks {clk}] -add_delay [get_ports {io_out[*]}]

## ======== DRIVE/FANOUT ========
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_8 -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]

set_max_transition 5.00 [current_design]
set_max_capacitance 1.0 [current_design]
set_max_fanout 20 [current_design]
