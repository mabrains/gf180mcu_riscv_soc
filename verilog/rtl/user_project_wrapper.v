// SPDX-FileCopyrightText: 2020 Efabless Corporation
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

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdd,		// User area 5.0V supply
    inout vss,		// User area ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [63:0] la_data_in,
    output [63:0] la_data_out,
    input  [63:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

/*--------------------------------------*/
/* User project is instantiated  here   */
/*--------------------------------------*/

serv_rf_top serv_rf_top(
`ifdef USE_POWER_PINS
	.vdd(vdd),	// // User area 5.0V supply
	.vss(vss),	// User area ground
`endif

    // ================================= Main signals =================================
    .clk(wb_clk_i),                         // clk        : Clock signal
    .i_rst(wb_rst_i),                       // i_rst      : Synchronous reset

    // ================================= Wishbone Slave =================================
    // .wbs_cyc_i(wbs_cyc_i),
    // .wbs_stb_i(wbs_stb_i),
    // .wbs_we_i(wbs_we_i),
    // .wbs_sel_i(wbs_sel_i),
    // .wbs_adr_i(wbs_adr_i),
    // .wbs_dat_i(wbs_dat_i),
    // .wbs_ack_o(wbs_ack_o),

    .o_dbus_dat(wbs_dat_o),                     // o_dbus_dat:  Data bus write data                   === OUT === 32 bit

    // ================================= Logic Analyzer =================================
    .o_ibus_adr(la_data_out[31:0]),             // o_ibus_adr:  Instruction bus address               === OUT === 32 bit
    .o_dbus_adr(la_data_out[63:32]),            // o_dbus_adr:  Data bus address                      === OUT === 32 bit

    .i_ibus_rdt(la_data_in[31:0]),              // i_ibus_rdt:  Instruction bus read data             === IN  === 32 bit
    .i_dbus_rdt(la_data_in[63:32]),             // i_dbus_rdt:  Data bus return data                  === IN  === 32 bit

    .i_timer_irq (la_oenb[0]),                  // i_timer_irq: Timer interrupt                       === IN  === 1  bit
    .i_ibus_ack (la_oenb[1]),                   // i_ibus_ack : Instruction bus cycle ack             === IN  === 1  bit
    .i_dbus_ack (la_oenb[2]),                   // i_dbus_ack : Data bus return data valid            === IN  === 1  bit
    .i_ext_ready (la_oenb[3]),                  // i_ext_ready: Extension interface RD contents valid === IN  === 1  bit
    .i_ext_rd (la_oenb[35:4]),                  // i_ext_rd   : Extension interface RD contents       === IN  === 32 bit

    // ================================= IO Pads =================================

    .o_ibus_cyc(io_out[0]),                     // o_ibus_cyc : Instruction bus active cycle          === OUT === 1  bit
    .o_dbus_sel(io_out[4:1]),                   // o_dbus_sel : Data bus write data byte select mask  === OUT === 4  bit
    .o_dbus_we(io_out[5]),                      // o_dbus_we  : Data bus write transaction            === OUT === 1  bit
    .o_ext_rs1(io_out[37:6]),                   // o_ext_rs1  : Extension interface RS1 contents      === OUT === 32 bit

    .o_ext_rs2(io_oeb[31:0]),                   // o_ext_rs2  : Extension interface RS2 contents      === OUT === 32 bit
    .o_ext_funct3(io_oeb[34:32]),               // o_ext_func3: Extension interface funct3 contents   === OUT === 3  bit
    .o_mdu_valid(io_oeb[35]),                   // o_mdu_valid: MDU request                           === OUT === 1  bit
    .o_dbus_cyc(io_oeb[36])                     // o_dbus_cyc : Data bus active cycle                 === OUT === 1  bit

);

endmodule	// user_project_wrapper

`default_nettype wire
