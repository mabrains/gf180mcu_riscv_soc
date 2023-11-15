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

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

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
    inout VDD,		// User area 5.0V supply
    inout VSS,		// User area ground
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
    inout VDD,		// User area 5.0V supply
    inout VSS,		// User area ground
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

        .cfg_strap_pad_ctrl (!wb_rst_i             ),

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
        .digital_io_out     (io_out                ),
        .digital_io_oen     (io_oeb                ),
        .digital_io_in      (io_in                 ),

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
    inout VDD,		// User area 5.0V supply
    inout VSS,		// User area ground
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

endmodule : user_project_wrapper

