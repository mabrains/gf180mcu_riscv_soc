// SPDX-FileCopyrightText: 2023 Mabrains Company
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

/*********************************************************************
    Reserved addr Map: [https://caravel-harness.readthedocs.io/en/latest/memory-mapped-io-summary.html]
        Address (bytes)    Function
        0x0000_0000 to 0x0000_3fff  - SRAM (4k words)
        0x1000_0000                   Flash SPI start of program block.
        0x10ff_ffff to 0x1fff_ffff  - SPI flash addressable space      
        0x2000_0000 to 0x2000_0008  - UART MGMT
        0x2100_0000 to 0x2100_000c  - GPIO_MEM_ADR [GPIO input/output, output enable, pullup enable, pulldown enable]
        0x2200_0000 to 0x2300_0008  - Counter/Timer
        0x2400_0000 to 0x2400_0008  - SPI controller configuration
        0x2500_0000 to 0x2500_000c  - Logic Analyzer Data
        0x2500_0010 to 0x2500_001c  - Logic Analyzer Enable
        0x2600_0000 to 0x2600_0008  - User project area GPIO data
        0x2600_000c to 0x2600_00a0  - GPIO_BASE_ADR [User project area GPIO mprj_io[0]: mprj_io[37]]
        0x2600_00a4 to 0x2600_00b4  - GPIO_BASE_ADR [User project area GPIO power[0]: power[3]]
        0x2d00_0000                 - QSPI controller config (reg_spictrl)
        0x2f00_0000                 - PLL clock output destination (reg_pll_out_dest)
        0x2f00_0004                 - Trap output destination (reg_trap_out_dest)
        0x2f00_0008                 - IRQ 7 input source (reg_irq7_source)
        0x8000_0000                 - QSPI controller
        0x9000_0000                 - Storage area SRAM [If external mem added in user area]
        0x3000_0000 to 0x300F_FFFF  - caravel user space.


/*********************************************************************
    ADDR Map:
       0x3000_0000 to 0x3000_0007  - wb_buttons_leds [For WB testing]
       0x3000_0008 to 0x3000_0011  - Temperature-Sensor
       0x3000_0040 to 0x3000_007F  - I2C
       0x3000_0080 to 0x3000_00BF  - USB
       0x3000_00C0 to 0x3000_00FF  - SSPIM
       0x3000_0100 to 0x3000_013F  - UART0
       0x3000_01C0 to 0x3000_01FF  - UART1
       0x3000_0200 to 0x3000_02FF  - PINMUX

***********************************************************************/

`default_nettype none

`include "user_params.svh"

module user_project_wrapper (
`ifdef USE_POWER_PINS
    inout VDD,		// User area 5.0V supply
    inout VSS,		// User area ground
`endif

   // =======================================================
   // ------------------- WB Slave ports --------------------
   // =======================================================    
   input   wire                 wb_clk_i        ,  // System clock
   input   wire                 wb_rst_i        ,  // Regular Reset signal
   input   wire                 wbs_stb_i       ,  // strobe/request
   input   wire                 wbs_cyc_i       ,  // strobe/request
   input   wire                 wbs_we_i        ,  // write enable
   input   wire [3:0]           wbs_sel_i       ,  // byte enable
   input   wire [WB_WIDTH-1:0]  wbs_dat_i       ,  // data in
   input   wire [WB_WIDTH-1:0]  wbs_adr_i       ,  // address

   output  wire                 wbs_ack_o       ,  // acknowlegement
   output  wire [WB_WIDTH-1:0]  wbs_dat_o       ,  // data out

   // =======================================================
   // --------------- Logic Analyzer Signals ----------------
   // =======================================================
   input  [63:0] la_data_in,
   output [63:0] la_data_out,
   input  [63:0] la_oenb,

   // ======================================================
   // -------------------- I/O Signals ---------------------
   // ======================================================
   input  [`MPRJ_IO_PADS-1:0] io_in,
   output [`MPRJ_IO_PADS-1:0] io_out,
   output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Independent clock (on independent integer divider)
    input  wire  user_clock2,  // user Clock

    // User maskable interrupt signals
    output [2:0] user_irq
);

//---------------------------------------------------
// Local Parameter Declaration
// --------------------------------------------------
parameter     WB_WIDTH      = 32; // WB ADDRESS/DARA WIDTH

// ==========================================================
// --------------------- SYSYEM SIGNALS ---------------------
// ==========================================================

wire       sspim_rst_n    ;
wire [1:0] uart_rst_n     ;
wire       i2c_rst_n      ;
wire       usb_rst_n      ;
wire       rtc_clk        ;
wire       usb_clk        ;
wire       xtal_clk       ;
wire       pulse1m_mclk   ;

// ====================================================================
// -------------------- UART-I2C-USB-SPI SLAVE I/F --------------------
// ====================================================================

// USB I/F
wire                usb_dp_o          ;
wire                usb_dn_o          ;
wire                usb_oen           ;
wire                usb_dp_i          ;
wire                usb_dn_i          ;

// UART I/F   
wire       [1:0]    uart_txd          ;
wire       [1:0]    uart_rxd          ;

// I2CM I/F   
wire                i2cm_clk_o        ;
wire                i2cm_clk_i        ;
wire                i2cm_clk_oen      ;
wire                i2cm_data_oen     ;
wire                i2cm_data_o       ;
wire                i2cm_data_i       ;

// SPIM I/F   
wire                sspim_sck         ; // clock out
wire                sspim_so          ; // serial data out
wire                sspim_si          ; // serial data in
wire    [3:0]       sspim_ssn         ; // cs_n

wire                usb_intr_o        ;
wire                i2cm_intr_o       ;

// ============================================================
// -------------------- Peripheral Reg I/F --------------------
// ============================================================
wire                reg_peri_cs        ;
wire                reg_peri_wr        ;
wire [10:0]         reg_peri_addr      ;
wire [31:0]         reg_peri_wdata     ;
wire [3:0]          reg_peri_be        ;

wire [31:0]         reg_peri_rdata     ;
wire                reg_peri_ack       ;

wire                rtc_intr           ; // RTC interrupt

// ==============================================================
// ---------------- UART-I2C-USB-SPI CONNECTIONS ----------------
// ==============================================================

uart_i2c_usb_spi_top   u_uart_i2c_usb_spi (
`ifdef USE_POWER_PINS
	.VDD(VDD),	// User area 5.0V supply
	.VSS(VSS),	// User area ground
`endif
        // System Signals
        .uart_rstn          (uart_rst_n         ),
        .i2c_rstn           (i2c_rst_n          ),
        .usb_rstn           (usb_rst_n          ),
        .spi_rstn           (sspim_rst_n        ),
    
        .app_clk            (wb_clk_i           ),
        .usb_clk            (usb_clk            ),

        // Reg Bus Interface Signal
        .reg_cs             (wbs_stb_i          ),
        .reg_wr             (wbs_we_i           ),
        .reg_addr           (wbs_adr_i[8:0]     ),
        .reg_wdata          (wbs_dat_i          ),
        .reg_be             (wbs_sel_i          ),

       // Outputs
        .reg_rdata          (wbs_dat_o          ),
        .reg_ack            (wbs_ack_o          ),

       // Pad interface
        .scl_pad_i          (i2cm_clk_i         ),
        .scl_pad_o          (i2cm_clk_o         ),
        .scl_pad_oen_o      (i2cm_clk_oen       ),

        .sda_pad_i          (i2cm_data_i        ),
        .sda_pad_o          (i2cm_data_o        ),
        .sda_padoen_o       (i2cm_data_oen      ),
    
        .i2cm_intr_o        (i2cm_intr_o        ),

        // UART
        .uart_rxd           (uart_rxd           ),
        .uart_txd           (uart_txd           ),

        // USB
        .usb_in_dp          (usb_dp_i           ),
        .usb_in_dn          (usb_dn_i           ),

        .usb_out_dp         (usb_dp_o           ),
        .usb_out_dn         (usb_dn_o           ),
        .usb_out_tx_oen     (usb_oen            ),
    
        .usb_intr_o         (usb_intr_o         ),

        // SPI
        .sspim_sck          (sspim_sck          ), 
        .sspim_so           (sspim_so           ),  
        .sspim_si           (sspim_si           ),  
        .sspim_ssn          (sspim_ssn          )  
    );

// ============================================================
// -------------------- PINMUX CONNECTIONS --------------------
// ============================================================

pinmux_top u_pinmux(
`ifdef USE_POWER_PINS
	.VDD(VDD),	// User area 5.0V supply
	.VSS(VSS),	// User area ground
`endif
        // System Signals
        .mclk               (wb_clk_i              ),
        .e_reset_n          (wb_rst_i              ),
        .p_reset_n          (wb_rst_i              ),
        .s_reset_n          (wb_rst_i              ),

        .user_clock1        (wb_clk_i              ),
        .user_clock2        (user_clock2           ),

        .rtc_clk            (rtc_clk              ),
        .usb_clk            (usb_clk              ),
        .xtal_clk           (xtal_clk             ),

        // Reset Control
        .sspim_rst_n        (sspim_rst_n           ),
        .uart_rst_n         (uart_rst_n            ),
        .i2cm_rst_n         (i2c_rst_n             ),
        .usb_rst_n          (usb_rst_n             ),

        // Risc configuration
        .user_irq           (user_irq              ),
        .usb_intr           (usb_intr_o            ),
        .i2cm_intr          (i2cm_intr_o           ),
        .rtc_intr           (rtc_intr              ),

        // Reg Bus Interface Signal
        .reg_cs             (wbs_stb_i           ),
        .reg_wr             (wbs_we_i            ),
        .reg_addr           (wbs_adr_i[10:0]     ),
        .reg_wdata          (wbs_dat_i           ),
        .reg_be             (wbs_sel_i           ),

        // Outputs
        .reg_rdata          (wbs_dat_o           ),
        .reg_ack            (wbs_ack_o           ),

        // Digital IO
        .digital_io_out     (io_out[37:21]       ),
        .digital_io_oen     (io_oeb[37:21]       ),
        .digital_io_in      (io_in [37:21]       ),

        // USB I/F
        .usb_dp_o           (usb_dp_o              ),
        .usb_dn_o           (usb_dn_o              ),
        .usb_oen            (usb_oen               ),
        .usb_dp_i           (usb_dp_i              ),
        .usb_dn_i           (usb_dn_i              ),

        // UART I/F
        .uart_txd           (uart_txd              ),
        .uart_rxd           (uart_rxd              ),

        // I2CM I/F
        .i2cm_clk_o         (i2cm_clk_o            ),
        .i2cm_clk_i         (i2cm_clk_i            ),
        .i2cm_clk_oen       (i2cm_clk_oen          ),
        .i2cm_data_oen      (i2cm_data_oen         ),
        .i2cm_data_o        (i2cm_data_o           ),
        .i2cm_data_i        (i2cm_data_i           ),

        // SPI MASTER
        .spim_sck           (sspim_sck             ),
        .spim_ssn           (sspim_ssn             ),
        .spim_miso          (sspim_so              ),
        .spim_mosi          (sspim_si              ),
    
        // timer
        .pulse1m_mclk       (pulse1m_mclk          ),    

    // Peripheral Reg Bus Interface Signal
        .reg_peri_cs        (reg_peri_cs           ),
        .reg_peri_wr        (reg_peri_wr           ),
        .reg_peri_addr      (reg_peri_addr         ),
        .reg_peri_wdata     (reg_peri_wdata        ),
        .reg_peri_be        (reg_peri_be           ),

    // Outputs
        .reg_peri_rdata     (reg_peri_rdata        ),
        .reg_peri_ack       (reg_peri_ack          )

    );

// ================================================================
// -------------------- Peripheral CONNECTIONS --------------------
// ================================================================

peri_top u_peri(
`ifdef USE_POWER_PINS
	.VDD(VDD),	// User area 5.0V supply
	.VSS(VSS),	// User area ground
`endif

        // System Signals
        // Inputs
          .mclk                    (wb_clk_i           ),
          .s_reset_n               (wb_rst_i           ),

        // Peripheral Reg Bus Interface Signal
          .reg_cs                  (reg_peri_cs        ),
          .reg_wr                  (reg_peri_wr        ),
          .reg_addr                (reg_peri_addr      ),
          .reg_wdata               (reg_peri_wdata     ),
          .reg_be                  (reg_peri_be        ),

       // Outputs
          .reg_rdata               (reg_peri_rdata     ),
          .reg_ack                 (reg_peri_ack       ),

          // RTC clock domain
          .rtc_clk                 (rtc_clk            ),
          .rtc_intr                (rtc_intr           )

   );

// ================================================================
// ------------------WB-BUTTONS_LEDS CONNECTIONS ------------------
// ================================================================

wb_buttons_leds wb_buttons_leds (
`ifdef USE_POWER_PINS
	.VDD(VDD),	// User area 5.0V supply
	.VSS(VSS),	// User area ground
`endif

    // clock & reset
    .clk(wb_clk_i),
    .reset(wb_rst_i),

    // wishbone
    .i_wb_cyc   (wbs_cyc_i),
    .i_wb_stb   (wbs_stb_i),
    .i_wb_we    (wbs_we_i),
    .i_wb_addr  (wbs_adr_i),
    .i_wb_data  (wbs_dat_i[1:0]),
    .o_wb_ack   (wbs_ack_o),
    .o_wb_data  (wbs_dat_o),

    // buttons & leds
    .buttons    (io_in[6:5]),
    .leds       (io_out[8:7]),
    .led_enb    (io_oeb[8:7])
);

// =============================================================
// ------------------ TEMP SENSOR CONNECTIONS ------------------
// =============================================================

temp_sensor temp_sensor(
`ifdef USE_POWER_PINS
	.VDD(VDD),	// User area 5.0V supply
	.VSS(VSS),	// User area ground
`endif

    // clock & reset
    .clk(wb_clk_i),
    .reset(wb_rst_i),

    // wishbone
    .i_wb_cyc   (wbs_cyc_i),
    .i_wb_stb   (wbs_stb_i),
    .i_wb_we    (wbs_we_i),
    .i_wb_addr  (wbs_adr_i),
    .o_wb_ack   (wbs_ack_o),
    .o_wb_data  (wbs_dat_o[7:0]),

    // buttons & leds
    .io_in(io_in[14:9]),
    .io_out(io_out[20:13]),
    .io_oeb(io_oeb[20:13])
);

endmodule : user_project_wrapper

