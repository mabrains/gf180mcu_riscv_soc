//////////////////////////////////////////////////////////////////////////////
// SPDX-FileCopyrightText: 2023 , Mabrains Company
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
//
//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Peripheral Top                                              ////
////                                                              ////
////  This file is part of the riscduino cores project            ////
////  https://github.com/dineshannayya/riscduino.git              ////
////                                                              ////
////  Description                                                 ////
////      Hold the All the Misc IP Integration                    ////
////        A. dig2ang                                            ////
////        B. RTC                                                ////
////                                                              ////
////  To Do:                                                      ////
////    nothing                                                   ////
////                                                              ////
////  Author(s):                                                  ////
////      - Dinesh Annayya, dinesha@opencores.org                 ////
////                                                              ////
////  Revision :                                                  ////
////    0.1 - 07 Dec 2022, Dinesh A                               ////
////          initial version                                     ////
////    0.2 - 05 Jan 2023, Dinesh A                               ////
////          Stepper Motor Integration                           ////
//////////////////////////////////////////////////////////////////////

`include "../user_params.svh"

module peri_top (
                    `ifdef USE_POWER_PINS
                       input logic             VDD, // User area 5V supply
                       input logic             VSS, // User area ground
                    `endif

                       // System Signals
                       // Inputs
                       input logic             mclk,
                       input logic             s_reset_n,  // soft reset

		       // Reg Bus Interface Signal
                       input logic             reg_cs,
                       input logic             reg_wr,
                       input logic [10:0]      reg_addr,
                       input logic [31:0]      reg_wdata,
                       input logic [3:0]       reg_be,

                       // Outputs
                       output logic [31:0]     reg_rdata,
                       output logic            reg_ack,

                       // RTC Clock Domain
                       input  logic            rtc_clk,
                       output logic            rtc_intr
 
   ); 

logic         s_reset_ssn;  // Sync Reset

//----------------------------------------
//  Register Response Path Mux
//  --------------------------------------

logic [31:0]  reg_d2a_rdata;
logic         reg_d2a_ack;
logic         reg_d2a_cs;

logic [31:0]  reg_rtc_rdata;
logic         reg_rtc_ack;
logic         reg_rtc_cs;

logic [31:0]  reg_ir_rdata;
logic         reg_ir_ack;
logic         reg_ir_cs;

logic [31:0]  reg_sm_rdata;
logic         reg_sm_ack;
logic         reg_sm_cs;

assign reg_rdata  = (reg_addr[10:7] == `SEL_D2A) ? reg_d2a_rdata :
                    (reg_addr[10:7] == `SEL_RTC) ? reg_rtc_rdata :
                    (reg_addr[10:7] == `SEL_IR)  ? reg_ir_rdata :
                    (reg_addr[10:7] == `SEL_SM)  ? reg_sm_rdata :
                     'h0;
assign reg_ack    = (reg_addr[10:7] == `SEL_D2A) ? reg_d2a_ack   :
                    (reg_addr[10:7] == `SEL_RTC) ? reg_rtc_ack   :
                    (reg_addr[10:7] == `SEL_IR)  ? reg_ir_ack   :
                    (reg_addr[10:7] == `SEL_SM)  ? reg_sm_ack   :
                    1'b0;
assign reg_d2a_cs = (reg_addr[10:7] == `SEL_D2A)  ? reg_cs : 1'b0;
assign reg_rtc_cs = (reg_addr[10:7] == `SEL_RTC)  ? reg_cs : 1'b0;
assign reg_ir_cs  = (reg_addr[10:7] == `SEL_IR)  ? reg_cs : 1'b0;
assign reg_sm_cs  = (reg_addr[10:7] == `SEL_SM)  ? reg_cs : 1'b0;


reset_sync  u_rst_sync (
	  .scan_mode  (1'b0           ),
          .dclk       (mclk           ), // Destination clock domain
          .arst_n     (s_reset_n      ), // active low async reset
          .srst_n     (s_reset_ssn    )
          );


//-----------------------------------------------------------------------
// RTC
//-----------------------------------------------------------------------
rtc_top  u_rtc(
              // System Signals
              // Inputs
              .sys_clk                  ( mclk                      ),
              .rst_n                    (s_reset_ssn                ),

		      // Reg Bus Interface Signal
              .reg_cs                   (reg_rtc_cs                 ),
              .reg_wr                   (reg_wr                     ),
              .reg_addr                 (reg_addr[4:0]              ),
              .reg_wdata                (reg_wdata[31:0]            ),
              .reg_be                   (reg_be[3:0]                ),

              // Outputs
              .reg_rdata                (reg_rtc_rdata              ),
              .reg_ack                  (reg_rtc_ack                ),

              .rtc_clk                  (rtc_clk                    ),
              .rtc_intr                 (rtc_intr                   )
         );

endmodule 
