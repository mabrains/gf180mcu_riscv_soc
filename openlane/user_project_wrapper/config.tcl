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

## =========================================================================================================
## ------------------------------------- Setup Config for User Wrapper -------------------------------------
## =========================================================================================================

## =========================== General ===========================
set ::unit 2.4

set ::env(DESIGN_NAME) "user_project_wrapper"
set ::env(VERILOG_FILES) [glob "$::env(DESIGN_DIR)/../../verilog/rtl/defines.v"  "$::env(DESIGN_DIR)/../../verilog/rtl/user_project_wrapper.v"]
set ::env(DESIGN_IS_CORE) "1"

set ::env(VERILOG_FILES_BLACKBOX) "\
     $::env(DESIGN_DIR)/../../verilog/gl/wb_buttons_leds.v      \
     $::env(DESIGN_DIR)/../../verilog/gl/temp_sensor.v          \
     $::env(DESIGN_DIR)/../../verilog/gl/uart_i2c_usb_spi_top.v \
     $::env(DESIGN_DIR)/../../verilog/gl/peri_top.v             \
     $::env(DESIGN_DIR)/../../verilog/gl/pinmux_top.v           \
     $::env(DESIGN_DIR)/../../verilog/gl/analog_wrapper.v       \
     $::env(DESIGN_DIR)/../../verilog/gl/mabrains_logo.v        \
     $::env(DESIGN_DIR)/../../verilog/gl/DSM_core.v             \
     "

set ::env(EXTRA_LEFS) "\
     $::env(DESIGN_DIR)/../../lef/wb_buttons_leds.lef      \
     $::env(DESIGN_DIR)/../../lef/temp_sensor.lef          \
     $::env(DESIGN_DIR)/../../lef/uart_i2c_usb_spi_top.lef \
     $::env(DESIGN_DIR)/../../lef/peri_top.lef             \
     $::env(DESIGN_DIR)/../../lef/pinmux_top.lef           \
     $::env(DESIGN_DIR)/../../lef/analog_wrapper.lef       \
     $::env(DESIGN_DIR)/../../lef/mabrains_logo.lef        \
     $::env(DESIGN_DIR)/../../lef/DSM_core.lef             \
     "

set ::env(EXTRA_GDS_FILES) "\
     $::env(DESIGN_DIR)/../../gds/wb_buttons_leds.gds      \
     $::env(DESIGN_DIR)/../../gds/temp_sensor.gds          \
     $::env(DESIGN_DIR)/../../gds/uart_i2c_usb_spi_top.gds \
     $::env(DESIGN_DIR)/../../gds/peri_top.gds             \
     $::env(DESIGN_DIR)/../../gds/pinmux_top.gds           \
     $::env(DESIGN_DIR)/../../gds/analog_wrapper.gds       \
     $::env(DESIGN_DIR)/../../gds/mabrains_logo.gds        \
     $::env(DESIGN_DIR)/../../gds/DSM_core.gds             \
     "

# set ::env(EXTRA_LIBS) "\
#      $::env(DESIGN_DIR)/../../lib/wb_buttons_leds.lib      \
#      $::env(DESIGN_DIR)/../../lib/temp_sensor.lib          \
#      $::env(DESIGN_DIR)/../../lib/uart_i2c_usb_spi_top.lib \
#      $::env(DESIGN_DIR)/../../lib/peri_top.lib             \
#      $::env(DESIGN_DIR)/../../lib/pinmux_top.lib           \
#      "

set ::env(EXTRA_SPEFS) [list "wb_buttons_leds"      "$::env(DESIGN_DIR)/../../spef/multicorner/wb_buttons_leds.min.spef"       "$::env(DESIGN_DIR)/../../spef/multicorner/wb_buttons_leds.nom.spef"       "$::env(DESIGN_DIR)/../../spef/multicorner/wb_buttons_leds.max.spef"      \
                             "temp_sensor"          "$::env(DESIGN_DIR)/../../spef/multicorner/temp_sensor.min.spef"           "$::env(DESIGN_DIR)/../../spef/multicorner/temp_sensor.nom.spef"           "$::env(DESIGN_DIR)/../../spef/multicorner/temp_sensor.max.spef"          \
                             "uart_i2c_usb_spi_top" "$::env(DESIGN_DIR)/../../spef/multicorner/uart_i2c_usb_spi_top.min.spef"  "$::env(DESIGN_DIR)/../../spef/multicorner/uart_i2c_usb_spi_top.nom.spef"  "$::env(DESIGN_DIR)/../../spef/multicorner/uart_i2c_usb_spi_top.max.spef" \
                             "peri_top"             "$::env(DESIGN_DIR)/../../spef/multicorner/peri_top.min.spef"              "$::env(DESIGN_DIR)/../../spef/multicorner/peri_top.nom.spef"              "$::env(DESIGN_DIR)/../../spef/multicorner/peri_top.max.spef"             \
                             "pinmux_top"           "$::env(DESIGN_DIR)/../../spef/multicorner/pinmux_top.min.spef"            "$::env(DESIGN_DIR)/../../spef/multicorner/pinmux_top.nom.spef"            "$::env(DESIGN_DIR)/../../spef/multicorner/pinmux_top.max.spef"           \
                             "DSM_core"           "$::env(DESIGN_DIR)/../../spef/multicorner/DSM_core.min.spef"            "$::env(DESIGN_DIR)/../../spef/multicorner/DSM_core.nom.spef"            "$::env(DESIGN_DIR)/../../spef/multicorner/DSM_core.max.spef"]

## =========================== PDK ===========================

set ::env(PDK) "gf180mcuD"
set ::env(PROCESS) "180"
set ::env(STD_CELL_LIBRARY) "gf180mcu_fd_sc_mcu7t5v0"
set ::env(STD_CELL_LIBRARY_OPT) "gf180mcu_fd_sc_mcu7t5v0"

## =========================== CLK ===========================

set ::env(CLOCK_PERIOD) "100"
set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_WIRE_RC_LAYER) "Metal4"

## =========================== SDC ===========================

# set ::env(BASE_SDC_FILE) "$::env(DESIGN_DIR)/user_project_wrapper.sdc"
set ::env(MAX_FANOUT_CONSTRAINT) "10"
set ::env(MAX_TRANSITION_CONSTRAINT) "3"

# =========================== OpenLane FLOW ===========================

set ::env(RUN_CTS) "0"
set ::env(RUN_CVC) "0"
set ::env(RUN_FILL_INSERTION) "0"
set ::env(RUN_HEURISTIC_DIODE_INSERTION) "0"
set ::env(RUN_IRDROP_REPORT) "0"
set ::env(RUN_KLAYOUT) "0"
set ::env(RUN_KLAYOUT_DRC) "0"
set ::env(RUN_KLAYOUT_XOR) "0"
set ::env(RUN_LINTER) "0"
set ::env(RUN_LVS) "0"
set ::env(RUN_MAGIC) "1"
set ::env(RUN_MAGIC_DRC) "0"
set ::env(RUN_SPEF_EXTRACTION) "1"
set ::env(RUN_TAP_DECAP_INSERTION) "0"

# =========================== SYNTH STEP ===========================

set ::env(SYNTH_STRATEGY) "AREA 0"
set ::env(SYNTH_CLOCK_TRANSITION) "0.15"
set ::env(SYNTH_CLOCK_UNCERTAINTY) "0.25"
set ::env(SYNTH_NO_FLAT) "0"
set ::env(SYNTH_READ_BLACKBOX_LIB) "1"
set ::env(SYNTH_SHARE_RESOURCES) "1"
set ::env(SYNTH_SIZING) "0"
set ::env(SYNTH_SPLITNETS) "1"
set ::env(SYNTH_TIMING_DERATE) "0.05"
set ::env(SYNTH_BUFFERING) "0"
set ::env(SYNTH_BUFFER_DIRECT_WIRES) "0"
set ::env(SYNTH_CHECKS_ALLOW_TRISTATE) "1"
set ::env(SYNTH_ELABORATE_ONLY) "1"
set ::env(SYNTH_FLAT_TOP) "0"
set ::env(SYNTH_OPT) "0"
set ::env(IO_PCT) "0.2"
set ::env(SYNTH_USE_PG_PINS_DEFINES) "USE_POWER_PINS"
set ::env(VDD_NETS) [list {vdd}]
set ::env(GND_NETS) [list {vss}]
set ::env(VDD_NET) "vdd"
set ::env(GND_NET) "vss"
set ::env(VDD_PIN) "vdd"
set ::env(GND_PIN) "vss"

## =========================== FLOORPLAN ===========================

set ::env(FP_PIN_ORDER_CFG) "$::env(DESIGN_DIR)/pin_order.cfg"
set ::env(FP_DEF_TEMPLATE) "$::env(DESIGN_DIR)/fixed_dont_change/user_project_wrapper.def"
set ::env(DIE_AREA) "0 0 2980.2 2980.2"
set ::env(CORE_AREA) "12 12 2968.2 2968.2"
set ::env(FP_SIZING) "absolute"
# set ::env(FP_CORE_UTIL) "30"
set ::env(FP_PDN_MACRO_HOOKS) "wb_buttons_leds vdd vss vdd vss, temp_sensor vdd vss vdd vss, u_uart_i2c_usb_spi  vdd vss vdd vss, u_peri vdd vss vdd vss, u_pinmux vdd vss vdd vss"
set ::env(FP_PDN_CHECK_NODES) "0"
set ::env(FP_PDN_CORE_RING) "1"
set ::env(FP_PDN_CORE_RING_VWIDTH) "3.1"
set ::env(FP_PDN_CORE_RING_HWIDTH) "3.1"
set ::env(FP_PDN_CORE_RING_VOFFSET) "14"
set ::env(FP_PDN_CORE_RING_HOFFSET) "16"
set ::env(FP_PDN_CORE_RING_VSPACING) "1.7"
set ::env(FP_PDN_CORE_RING_HSPACING) "1.7"
set ::env(FP_IO_VEXTEND) [expr 2*$::unit]
set ::env(FP_IO_HEXTEND) [expr 2*$::unit]
set ::env(FP_IO_VLENGTH) $::unit
set ::env(FP_IO_HLENGTH) $::unit
set ::env(FP_IO_VTHICKNESS_MULT) "4"
set ::env(FP_IO_HTHICKNESS_MULT) "4"

set ::env(FP_PDN_ENABLE_RAILS) "0"
set ::env(FP_PDN_HORIZONTAL_HALO) "10"
set ::env(FP_PDN_VERTICAL_HALO) "10"
set ::env(FP_PDN_VOFFSET) "5"
set ::env(FP_PDN_HOFFSET) "5"
set ::env(FP_PDN_VPITCH) "90"
set ::env(FP_PDN_HPITCH) "90"
set ::env(FP_PDN_VWIDTH) "3.1"
set ::env(FP_PDN_HWIDTH) "3.1"
set ::env(FP_PDN_VSPACING) [expr 5 * $::env(FP_PDN_CORE_RING_VWIDTH)]
set ::env(FP_PDN_HSPACING) "26.9"
set ::env(PDN_STRIPE) {vdd vss}
set ::env(FP_PDN_ENABLE_MACROS_GRID) "1"

## =========================== PL & Rotute ===========================

set ::env(MACRO_PLACEMENT_CFG) "$::env(DESIGN_DIR)/macro.cfg"
set ::env(ROUTING_CORES) "8"
# set ::env(PL_TARGET_DENSITY) "0.3"
set ::env(PL_ROUTABILITY_DRIVEN) "1"
set ::env(PL_BASIC_PLACEMENT) "0"
set ::env(PL_ESTIMATE_PARASITICS) "1"
set ::env(PL_MAX_DISPLACEMENT_X) "500"
set ::env(PL_MAX_DISPLACEMENT_Y) "100"
set ::env(PL_OPTIMIZE_MIRRORING) "1"
set ::env(PL_SKIP_INITIAL_PLACEMENT) "0"
set ::env(DIODE_PADDING) "2"
set ::env(CELL_PAD) 2
set ::env(GRT_ALLOW_CONGESTION) "1"

## =========================== RESIZER =========================== 

set ::env(RSZ_MULTICORNER_LIB) "1"
set ::env(RT_MIN_LAYER) "Metal2"
set ::env(RT_MAX_LAYER) "Metal5"
set ::env(GLB_OPTIMIZE_MIRRORING) "1"
set ::env(GLB_RESIZER_ALLOW_SETUP_VIOS) "0"
set ::env(GLB_RESIZER_DESIGN_OPTIMIZATIONS) "0"
set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) "0"
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS)  "0"
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS)  "0"
set ::env(GLB_RESIZER_HOLD_MAX_BUFFER_PERCENT) "50"
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) "0.05"
set ::env(GLB_RESIZER_MAX_WIRE_LENGTH) "500"
set ::env(PL_RESIZER_MAX_WIRE_LENGTH) "500"

## =========================== STA ===========================

set ::env(STA_MULTICORNER_READ_LIBS) "0"
set ::env(STA_REPORT_POWER) "1"
set ::env(STA_WRITE_LIB) "1"

## =========================== CTS ===========================

set ::env(CTS_REPORT_TIMING) "1"
set ::env(CTS_TOLERANCE) "100"

## =========================== DIODE/ANT INSERTION ===========================

set ::env(DIODE_INSERTION_STRATEGY) "0"
set ::env(DIODE_ON_PORTS) "none"
set ::env(DIODE_PADDING) "2"
set ::env(DPL_CELL_PADDING) "0"
set ::env(GRT_MAX_DIODE_INS_ITERS) "0"
set ::env(GRT_REPAIR_ANTENNAS) "0"
set ::env(HEURISTIC_ANTENNA_INSERTION_MODE) "source"
set ::env(HEURISTIC_ANTENNA_THRESHOLD) "90"

## =========================== Signoff klayout ===========================

set ::env(KLAYOUT_DRC_KLAYOUT_GDS) "0"
set ::env(KLAYOUT_XOR_THREADS) "1"

## =========================== Signoff magic/netgen ===========================

# set ::env(SIGNOFF_SDC_FILE) "$::env(DESIGN_DIR)/signoff.sdc"
set ::env(MAGIC_CONVERT_DRC_TO_RDB) "1"
set ::env(MAGIC_DEF_LABELS) "1"
set ::env(MAGIC_DEF_NO_BLOCKAGES) "1"
set ::env(MAGIC_DISABLE_HIER_GDS) "1"
set ::env(MAGIC_DRC_USE_GDS) "1"
set ::env(MAGIC_EXT_USE_GDS) "0"
set ::env(MAGIC_GDS_ALLOW_ABSTRACT) "0"
set ::env(MAGIC_GDS_POLYGON_SUBCELLS) "0"
set ::env(MAGIC_GENERATE_GDS) "1"
set ::env(MAGIC_GENERATE_LEF) "1"
set ::env(MAGIC_GENERATE_MAGLEF) "1"
set ::env(MAGIC_INCLUDE_GDS_POINTERS) "0"
set ::env(MAGIC_LEF_WRITE_USE_GDS) "0"
set ::env(MAGIC_PAD) "0"
set ::env(MAGIC_WRITE_FULL_LEF) "0"
set ::env(MAGIC_ZEROIZE_ORIGIN) "0"
set ::env(USE_ARC_ANTENNA_CHECK) "1"
set ::env(LVS_CONNECT_BY_LABEL) "0"
set ::env(LVS_INSERT_POWER_PINS) "1"

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

## ===========================================================================================================

