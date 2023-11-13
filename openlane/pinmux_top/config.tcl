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

## ===============================================================================================
## --------------------------------- Setup Config for pinmux_top ---------------------------------
## ===============================================================================================


## =========================== General ===========================

set ::env(DESIGN_NAME) "pinmux_top"
set ::env(DESIGN_IS_CORE) "0"
# Local sources + no2usb sources
set ::env(VERILOG_FILES) "\
     $::env(DESIGN_DIR)/../../verilog/rtl/lib/clk_skew_adjust.gv \
     $::env(DESIGN_DIR)/../../verilog/rtl/pinmux/pinmux_top.sv     \
     $::env(DESIGN_DIR)/../../verilog/rtl/pinmux/pinmux.sv     \
     $::env(DESIGN_DIR)/../../verilog/rtl/pinmux/glbl_reg.sv  \
     $::env(DESIGN_DIR)/../../verilog/rtl/pinmux/pseudorandom.sv \
     $::env(DESIGN_DIR)/../../verilog/rtl/gpio/gpio_top.sv  \
     $::env(DESIGN_DIR)/../../verilog/rtl/gpio/gpio_reg.sv  \
     $::env(DESIGN_DIR)/../../verilog/rtl/gpio/gpio_intr.sv \
     $::env(DESIGN_DIR)/../../verilog/rtl/gpio/gpio_dglicth.sv \
     $::env(DESIGN_DIR)/../../verilog/rtl/pwm/pwm_top.sv   \
     $::env(DESIGN_DIR)/../../verilog/rtl/pwm/pwm_core.sv   \
     $::env(DESIGN_DIR)/../../verilog/rtl/pwm/pwm_glbl_reg.sv   \
     $::env(DESIGN_DIR)/../../verilog/rtl/pwm/pwm_blk_reg.sv   \
     $::env(DESIGN_DIR)/../../verilog/rtl/pwm/pwm_cfg_dglitch.sv   \
     $::env(DESIGN_DIR)/../../verilog/rtl/pwm/pwm.sv       \
     $::env(DESIGN_DIR)/../../verilog/rtl/timer/timer_top.sv \
     $::env(DESIGN_DIR)/../../verilog/rtl/timer/timer_reg.sv \
     $::env(DESIGN_DIR)/../../verilog/rtl/timer/timer.sv     \
     $::env(DESIGN_DIR)/../../verilog/rtl/pinmux/semaphore_reg.sv  \
     $::env(DESIGN_DIR)/../../verilog/rtl/ws281x/ws281x_top.sv \
     $::env(DESIGN_DIR)/../../verilog/rtl/ws281x/ws281x_driver.sv \
     $::env(DESIGN_DIR)/../../verilog/rtl/ws281x/ws281x_reg.sv \
     $::env(DESIGN_DIR)/../../verilog/rtl/pinmux/strap_ctrl.sv \
     $::env(DESIGN_DIR)/../../verilog/rtl/pinmux/glbl_rst_reg.sv \
     $::env(DESIGN_DIR)/../../verilog/rtl/dig2ana/dig2ana_reg.sv \
     $::env(DESIGN_DIR)/../../verilog/rtl/lib/pulse_gen_type1.sv   \
     $::env(DESIGN_DIR)/../../verilog/rtl/lib/pulse_gen_type2.sv   \
     $::env(DESIGN_DIR)/../../verilog/rtl/lib/registers.v          \
     $::env(DESIGN_DIR)/../../verilog/rtl/lib/ctech_cells.sv     \
     $::env(DESIGN_DIR)/../../verilog/rtl/lib/reset_sync.sv     \
     $::env(DESIGN_DIR)/../../verilog/rtl/lib/sync_fifo.sv     \
     $::env(DESIGN_DIR)/../../verilog/rtl/lib/clk_ctl.v     \
     "

## =========================== PDK ===========================

set ::env(PDK) "gf180mcuD"
set ::env(PROCESS) "180"
set ::env(STD_CELL_LIBRARY) "gf180mcu_fd_sc_mcu7t5v0"
set ::env(STD_CELL_LIBRARY_OPT) "gf180mcu_fd_sc_mcu7t5v0"

## =========================== CLK ===========================

set ::env(CLOCK_PERIOD) "25"
set ::env(CLOCK_PORT) "mclk"

## =========================== SDC ===========================

set ::env(MAX_FANOUT_CONSTRAINT) "20"
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
set ::env(SYNTH_BUFFERING) "1"
set ::env(SYNTH_CHECKS_ALLOW_TRISTATE) "1"
set ::env(SYNTH_FLAT_TOP) "0"
set ::env(IO_PCT) "0.05"
set ::env(SYNTH_USE_PG_PINS_DEFINES) "USE_POWER_PINS"
set ::env(SYNTH_DEFINES) [list SYNTHESIS  YCR_DBG_EN]
set ::env(VDD_NETS) [list {VDD}]
set ::env(GND_NETS) [list {VSS}]

## =========================== FLOORPLAN ===========================

# set ::env(FP_PIN_ORDER_CFG) "$::env(DESIGN_DIR)/pin_order.cfg"
set ::env(DIE_AREA) "0 0 1200 1000"
set ::env(FP_SIZING) "absolute"
set ::env(FP_CORE_UTIL) "50"
set ::env(FP_PDN_CORE_RING) "0"

# set ::env(FP_PDN_VWIDTH) "6.2"
# set ::env(FP_PDN_HWIDTH) "6.2"
# set ::env(FP_PDN_VPITCH) "100"
# set ::env(FP_PDN_HPITCH) "100"

set ::env(FP_PDN_CHECK_NODES) "0"
set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) "1"

# set ::env(FP_IO_VEXTEND) 4
# set ::env(FP_IO_HEXTEND) 4

## =========================== PL & Rotute ===========================

set ::env(ROUTING_CORES) "8"
set ::env(PL_TARGET_DENSITY) "0.45"
set ::env(PL_BASIC_PLACEMENT) "0"
set ::env(PL_SKIP_INITIAL_PLACEMENT) "0"
set ::env(DIODE_PADDING) "2"
set ::env(CELL_PAD) "8"
set ::env(GRT_ADJUSTMENT) "0.1"

## =========================== RESIZER =========================== 

set ::env(RT_MIN_LAYER) "Metal2"
set ::env(RT_MAX_LAYER) "Metal5"
set ::env(GLB_RESIZER_ALLOW_SETUP_VIOS) "0"
set ::env(GLB_RESIZER_DESIGN_OPTIMIZATIONS) "1"
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) "0.05"
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) "1"
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS)  "1"
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS)  "1"
set ::env(GLB_RESIZER_MAX_WIRE_LENGTH) "500"
set ::env(PL_RESIZER_MAX_WIRE_LENGTH) "500"

# set ::env(GLB_RESIZER_MAX_CAP_MARGIN) "10"
# set ::env(PL_RESIZER_MAX_CAP_MARGIN) "10"
# set ::env(GLB_RESIZER_MAX_SLEW_MARGIN) "5"
# set ::env(PL_RESIZER_MAX_SLEW_MARGIN) "5"

set ::env(GLB_RESIZER_HOLD_MAX_BUFFER_PERCENT) "100"
set ::env(GLB_RESIZER_SETUP_MAX_BUFFER_PERCENT) "100"
set ::env(PL_RESIZER_HOLD_MAX_BUFFER_PERCENT)  "100"
set ::env(PL_RESIZER_SETUP_MAX_BUFFER_PERCENT) "100"

## =========================== STA ===========================

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
#LVS Issue - DEF Base looks to having issue
set ::env(MAGIC_EXT_USE_GDS) "1"
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
