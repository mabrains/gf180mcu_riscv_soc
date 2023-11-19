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

## =============================================================================================
## --------------------------------- Setup Config for peri_top ---------------------------------
## =============================================================================================


## =========================== General ===========================

set ::env(DESIGN_NAME) "wb_buttons_leds"
set ::env(DESIGN_IS_CORE) "0"
set ::env(VERILOG_INCLUDE_DIRS) [glob $::env(DESIGN_DIR)/../../verilog/rtl/ ]
# Local sources + no2usb sources
set ::env(VERILOG_FILES) "\
     $::env(DESIGN_DIR)/../../verilog/rtl/wb_buttons_leds/wb_buttons_leds.v \
     "

## =========================== PDK ===========================

set ::env(PDK) "gf180mcuD"
set ::env(PROCESS) "180"
set ::env(STD_CELL_LIBRARY) "gf180mcu_fd_sc_mcu7t5v0"
set ::env(STD_CELL_LIBRARY_OPT) "gf180mcu_fd_sc_mcu7t5v0"

## =========================== CLK ===========================

set ::env(CLOCK_PERIOD) "100"
set ::env(CLOCK_PORT) "clk"

## =========================== SDC ===========================

set ::env(MAX_FANOUT_CONSTRAINT) "10"
set ::env(MAX_TRANSITION_CONSTRAINT) "6"

# =========================== OpenLane FLOW ===========================

set ::env(RUN_CTS) "1"
set ::env(RUN_CVC) "0"
set ::env(RUN_FILL_INSERTION) "1"
set ::env(RUN_HEURISTIC_DIODE_INSERTION) "1"
set ::env(RUN_IRDROP_REPORT) "1"
set ::env(RUN_KLAYOUT) "1"
set ::env(RUN_KLAYOUT_DRC) "0"
set ::env(RUN_KLAYOUT_XOR) "1"
set ::env(RUN_LINTER) "1"
set ::env(RUN_LVS) "1"
set ::env(RUN_MAGIC) "1"
set ::env(RUN_MAGIC_DRC) "1"
set ::env(RUN_SPEF_EXTRACTION) "1"
set ::env(RUN_TAP_DECAP_INSERTION) "1"

# =========================== SYNTH STEP ===========================

set ::env(SYNTH_NO_FLAT) "1"
set ::env(SYNTH_READ_BLACKBOX_LIB) "1"
set ::env(SYNTH_SHARE_RESOURCES) "1"
set ::env(SYNTH_SIZING) "0"
set ::env(SYNTH_SPLITNETS) "1"
set ::env(SYNTH_BUFFERING) "0"
set ::env(SYNTH_CHECKS_ALLOW_TRISTATE) "1"
set ::env(SYNTH_FLAT_TOP) "0"
set ::env(IO_PCT) "0.2"
set ::env(SYNTH_USE_PG_PINS_DEFINES) "USE_POWER_PINS"
set ::env(SYNTH_DEFINES) [list SYNTHESIS]
set ::env(VDD_NETS) [list {VDD}]
set ::env(GND_NETS) [list {VSS}]

## =========================== FLOORPLAN ===========================

set ::env(DIE_AREA) "0 0 100 100"
set ::env(FP_SIZING) "absolute"
set ::env(FP_CORE_UTIL) "50"
set ::env(FP_PDN_CORE_RING) "0"

## =========================== PL & Rotute ===========================

set ::env(ROUTING_CORES) "8"
set ::env(PL_TARGET_DENSITY) "0.45"
set ::env(PL_BASIC_PLACEMENT) "0"
set ::env(PL_SKIP_INITIAL_PLACEMENT) "0"
set ::env(DIODE_PADDING) "2"
set ::env(CELL_PAD) "4"
set ::env(GRT_ADJUSTMENT) "0.2"

## =========================== RESIZER =========================== 

set ::env(RT_MIN_LAYER) "Metal2"
set ::env(RT_MAX_LAYER) "Metal4"
set ::env(GLB_RESIZER_ALLOW_SETUP_VIOS) "0"
set ::env(GLB_RESIZER_DESIGN_OPTIMIZATIONS) "1"
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) "0.05"
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) "1"
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS)  "1"
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS)  "1"
set ::env(GLB_RESIZER_MAX_WIRE_LENGTH) "500"
set ::env(PL_RESIZER_MAX_WIRE_LENGTH) "500"

# =========================== STA ===========================

set ::env(STA_REPORT_POWER) "1"
set ::env(STA_WRITE_LIB) "1"

## =========================== CTS ===========================

set ::env(CTS_CLK_MAX_WIRE_LENGTH) "250"
set ::env(CTS_REPORT_TIMING) "1"
set ::env(CTS_TOLERANCE) "100"
set ::env(CTS_SINK_CLUSTERING_SIZE) "16"

## =========================== DIODE/ANT INSERTION ===========================

set ::env(DIODE_ON_PORTS) "None"
set ::env(DIODE_PADDING) "2"
set ::env(DPL_CELL_PADDING) "0"
set ::env(GRT_MAX_DIODE_INS_ITERS) "1"
set ::env(GRT_REPAIR_ANTENNAS) "1"

## =========================== Signoff klayout ===========================

set ::env(KLAYOUT_DRC_KLAYOUT_GDS) "0"
set ::env(KLAYOUT_XOR_THREADS) "4"

## =========================== Signoff magic/netgen ===========================

set ::env(MAGIC_CONVERT_DRC_TO_RDB) "1"
set ::env(MAGIC_DEF_LABELS) "1"
set ::env(MAGIC_DEF_NO_BLOCKAGES) "1"
set ::env(MAGIC_DISABLE_HIER_GDS) "1"
set ::env(MAGIC_DRC_USE_GDS) "1"
set ::env(MAGIC_EXT_USE_GDS) "0"
set ::env(MAGIC_GDS_ALLOW_ABSTRACT) "0"
set ::env(MAGIC_GENERATE_GDS) "1"
set ::env(MAGIC_GENERATE_LEF) "1"
set ::env(MAGIC_GENERATE_MAGLEF) "1"
set ::env(MAGIC_WRITE_FULL_LEF) "0"
set ::env(USE_ARC_ANTENNA_CHECK) "1"
set ::env(LVS_CONNECT_BY_LABEL) "0"
set ::env(LVS_INSERT_POWER_PINS) "0"

## =========================== Signoff RC ===========================

set ::env(SPEF_EXTRACTOR) "openrcx"
set ::env(RCX_MERGE_VIA_WIRE_RES) "1"

## =========================== ERRORS ===========================

set ::env(QUIT_ON_LINTER_ERRORS) "1"
set ::env(QUIT_ON_LINTER_WARNINGS) "0"
set ::env(QUIT_ON_ASSIGN_STATEMENTS) "0"
set ::env(QUIT_ON_SYNTH_CHECKS) "0"
set ::env(QUIT_ON_ILLEGAL_OVERLAPS) "1"
set ::env(QUIT_ON_TIMING_VIOLATIONS) "1"
set ::env(QUIT_ON_SETUP_VIOLATIONS) "1"
set ::env(QUIT_ON_HOLD_VIOLATIONS) "1"
set ::env(QUIT_ON_UNMAPPED_CELLS) "1"
set ::env(QUIT_ON_LONG_WIRE) "0"
set ::env(QUIT_ON_TR_DRC) "1"
set ::env(QUIT_ON_MAGIC_DRC) "1"
set ::env(QUIT_ON_LVS_ERROR) "1"
set ::env(QUIT_ON_XOR_ERROR) "1"
set ::env(QUIT_ON_SLEW_VIOLATIONS) "0"

## ========================================================================================
