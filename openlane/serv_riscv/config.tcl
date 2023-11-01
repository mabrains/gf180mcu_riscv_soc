## ========================================================================================================
## ------------------------------------- Setup Config for serve riscv -------------------------------------
## ========================================================================================================

## =========================== General ===========================

set ::env(DESIGN_NAME) "serv_rf_top"
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/../../verilog/rtl/serv_riscv/*.v  "$::env(DESIGN_DIR)/../../verilog/rtl/defines.v"]
set ::env(DESIGN_IS_CORE) "0"
set ::env(GND_NETS) "vss"
set ::env(VDD_NETS) "vdd"

## =========================== PDK ===========================

set ::env(PDK) "gf180mcuD"
set ::env(PROCESS) "180"
set ::env(PDKPATH) "/home/farag/open_design_environment/foundry/pdks/GF180/gf180mcuD"
set ::env(STD_CELL_LIBRARY) "gf180mcu_fd_sc_mcu7t5v0"
set ::env(STD_CELL_LIBRARY_OPT) "gf180mcu_fd_sc_mcu7t5v0"
set ::env(SCLPATH) "/home/farag/open_design_environment/foundry/pdks/GF180/gf180mcuD/gf180mcu_fd_sc_mcu7t5v0"

## =========================== CLK ===========================

set ::env(CLOCK_PERIOD) "25"
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_BUFFER_FANOUT) "16"
set ::env(CLOCK_WIRE_RC_LAYER) "Metal4"

## =========================== SDC ===========================

set ::env(BASE_SDC_FILE) "$::env(DESIGN_DIR)/base_user_proj_example.sdc"
set ::env(MAX_FANOUT_CONSTRAINT) "10"
set ::env(MAX_TRANSITION_CONSTRAINT) "3"

# =========================== OpenLane FLOW ===========================

set ::env(RUN_CTS) "1"
set ::env(RUN_CVC) "1"
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

set ::env(SYNTH_BIN) "yosys"
set ::env(SYNTH_STRATEGY) "AREA 0"
set ::env(SYNTH_CLOCK_TRANSITION) "0.15"
set ::env(SYNTH_CLOCK_UNCERTAINTY) "0.25"
set ::env(SYNTH_NO_FLAT) "0"
set ::env(SYNTH_READ_BLACKBOX_LIB) "1"
set ::env(SYNTH_SHARE_RESOURCES) "1"
set ::env(SYNTH_SIZING) "0"
set ::env(SYNTH_SPLITNETS) "1"
set ::env(SYNTH_TIMING_DERATE) "0.05"
set ::env(SYNTH_BUFFERING) "1"
set ::env(SYNTH_BUFFER_DIRECT_WIRES) "1"
set ::env(SYNTH_CHECKS_ALLOW_TRISTATE) "1"
set ::env(SYNTH_ELABORATE_ONLY) "0"
set ::env(SYNTH_FLAT_TOP) "0"
set ::env(SYNTH_OPT) "0"
set ::env(IO_PCT) "0.2"

## =========================== FLOORPLAN ===========================

# set ::env(DIE_AREA) "0 0 2800 1760"
# set ::env(FP_SIZING) absolute
# set ::env(FP_ASPECT_RATIO) "1"
set ::env(FP_CORE_UTIL) "30"
# set ::env(FP_PDN_AUTO_ADJUST) "1"
# set ::env(FP_PDN_CHECK_NODES) "0"
# set ::env(FP_PDN_CORE_RING) "0"
# set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) "1"
# set ::env(FP_PDN_ENABLE_RAILS) "0"

## =========================== PL & Rotute ===========================

# set ::env(RUN_DRT) "0"
set ::env(ROUTING_CORES) "8"
set ::env(PL_TARGET_DENSITY) "0.4"
set ::env(PL_ROUTABILITY_DRIVEN) "1"
set ::env(PL_BASIC_PLACEMENT) "0"
set ::env(PL_ESTIMATE_PARASITICS) "1"
set ::env(PL_MAX_DISPLACEMENT_X) "500"
set ::env(PL_MAX_DISPLACEMENT_Y) "100"
set ::env(PL_OPTIMIZE_MIRRORING) "1"
# set ::env(PL_RANDOM_GLB_PLACEMENT) "1"
set ::env(PL_SKIP_INITIAL_PLACEMENT) "0"
# set ::env(GPL_CELL_PADDING) "2"
set ::env(DIODE_PADDING) "2"
set ::env(CELL_PAD) 2

## =========================== RESIZER =========================== 

set ::env(RSZ_MULTICORNER_LIB) "1"
# set ::env(RT_MAX_LAYER) "Metal4"
set ::env(RT_MIN_LAYER) "Metal2"
set ::env(GLB_OPTIMIZE_MIRRORING) "1"
set ::env(GLB_RESIZER_ALLOW_SETUP_VIOS) "0"
set ::env(GLB_RESIZER_DESIGN_OPTIMIZATIONS) "1"
set ::env(GLB_RESIZER_HOLD_MAX_BUFFER_PERCENT) "50"
set ::env(GLB_RESIZER_HOLD_SLACK_MARGIN) "0.05"

## =========================== STA ===========================

set ::env(STA_MULTICORNER_READ_LIBS) "0"
set ::env(STA_REPORT_POWER) "1"
set ::env(STA_WRITE_LIB) "1"

## =========================== CTS ===========================

set ::env(CTS_REPORT_TIMING) "1"
set ::env(CTS_TOLERANCE) "100"

## =========================== DIODE/ANT INSERTION ===========================

set ::env(DIODE_CELL) "gf180mcu_fd_sc_mcu7t5v0__antenna"
set ::env(DIODE_CELL_PIN) "I"
set ::env(DIODE_ON_PORTS) "in"
set ::env(DIODE_PADDING) "2"
set ::env(DPL_CELL_PADDING) "0"
set ::env(GRT_MAX_DIODE_INS_ITERS) "1"
set ::env(GRT_REPAIR_ANTENNAS) "1"
set ::env(HEURISTIC_ANTENNA_INSERTION_MODE) "source"
set ::env(HEURISTIC_ANTENNA_THRESHOLD) "90"

## =========================== Signoff klayout ===========================

set ::env(KLAYOUT_DRC_KLAYOUT_GDS) "0"
set ::env(KLAYOUT_XOR_THREADS) "1"

## =========================== Signoff magic/netgen ===========================

set ::env(PRIMARY_SIGNOFF_TOOL) "magic"
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
set ::env(QUIT_ON_SYNTH_CHECKS) "1"
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

## ===========================================================================================================
