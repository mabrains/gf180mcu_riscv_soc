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

`include "../user_params.svh"

module pinmux_top (
      `ifdef USE_POWER_PINS
         input logic             VDD, // User area 5V supply
         input logic             VSS, // User area ground
      `endif      

         // System Signals
         // Inputs
         input logic             mclk,
         input logic             e_reset_n              ,  // external reset
         input logic             p_reset_n              ,  // power-on reset
         input logic             s_reset_n              ,  // soft reset  

         input logic            user_clock1            ,
         input logic            user_clock2            ,
         
         output logic           xtal_clk               ,
         output logic           usb_clk                ,
         output logic           rtc_clk                ,    

         // Global Reset control
         output logic            sspim_rst_n      ,
         output logic [1:0]      uart_rst_n       ,
         output logic            i2cm_rst_n       ,
         output logic            usb_rst_n        ,

          // Reg Bus Interface Signal
         input logic             reg_cs,
         input logic             reg_wr,
         input logic [10:0]      reg_addr,
         input logic [31:0]      reg_wdata,
         input logic [3:0]       reg_be,

         // Outputs
         output logic [31:0]     reg_rdata,
         output logic            reg_ack,

          // Risc configuration
         output logic [2:0]      user_irq,
         input  logic            usb_intr,
         input  logic            i2cm_intr,

         // Digital IO
         output logic [37:0]     digital_io_out,
         output logic [37:0]     digital_io_oen,
         input  logic [37:0]     digital_io_in,

         // USB I/F
         input   logic           usb_dp_o,
         input   logic           usb_dn_o,
         input   logic           usb_oen,
         output   logic          usb_dp_i,
         output   logic          usb_dn_i,

         // UART I/F
         input   logic  [1:0]    uart_txd,
         output  logic  [1:0]    uart_rxd,

         // I2CM I/F
         input   logic           i2cm_clk_o,
         output  logic           i2cm_clk_i,
         input   logic           i2cm_clk_oen,
         input   logic           i2cm_data_oen,
         input   logic           i2cm_data_o,
         output  logic           i2cm_data_i,

         // SPI MASTER
         input   logic           spim_sck,
         input   logic [3:0]     spim_ssn,
         input   logic           spim_miso,
         output  logic           spim_mosi,

         output  logic           pulse1m_mclk,

         // Peripheral Reg Bus Interface Signal
         output logic             reg_peri_cs,
         output logic             reg_peri_wr,
         output logic [10:0]      reg_peri_addr,
         output logic [31:0]      reg_peri_wdata,
         output logic [3:0]       reg_peri_be,

         // Input
         input logic [31:0]       reg_peri_rdata,
         input logic              reg_peri_ack,

         input logic              rtc_intr
   ); 

logic         s_reset_ssn;  // Sync Reset
logic         p_reset_ssn;  // Sync Reset
logic         cfg_gpio_dgmode; // gpio de-glitch mode
logic         pwm_intr;   
/* clock pulse */
//********************************************************
logic           pulse_1ms               ; // 1 Milli Second Pulse for waveform Generator
logic           pulse_1us               ; // 1 Micro Second Pulse for waveform Generator

logic [5:0]     cfg_pwm_enb             ;


//---------------------------------------------------------
// Timer Register                          
// -------------------------------------------------------
logic [2:0]    timer_intr              ;

//---------------------------------------------------
// 6 PWM variabled
//---------------------------------------------------

logic [5:0]     pwm_wfm                 ;


logic [31:0]  gpio_intr                ;
wire  [31:0]  cfg_gpio_dir_sel         ;// decides on GPIO pin is I/P or O/P at pad level, 0 -> Input, 1 -> Output
wire  [31:0]  cfg_multi_func_sel       ;// GPIO Multi function type

wire [31:0]   pad_gpio_in;    // GPIO data input from PAD
wire [31:0]   pad_gpio_out;   // GPIO Data out towards PAD

//----------------------------------------
//  Register Response Path Mux
//  --------------------------------------
logic [31:0]  reg_glbl_rdata;
logic         reg_glbl_ack;

logic [31:0]  reg_gpio_rdata;
logic         reg_gpio_ack;

logic [31:0]  reg_pwm_rdata;
logic         reg_pwm_ack;

logic [31:0]  reg_timer_rdata;
logic         reg_timer_ack;

logic [15:0]  reg_sema_rdata;
logic         reg_sema_ack;

logic [31:0]  reg_ws_rdata;
logic         reg_ws_ack;

// logic [31:0]  reg_d2a_rdata;
// logic         reg_d2a_ack;

logic [7:0]   pwm_gpio_in;

logic         reg_glbl_cs ;
logic         reg_gpio_cs ;
logic         reg_pwm_cs  ;
logic         reg_timer_cs;
logic         reg_sema_cs ;
logic         reg_ws_cs   ;

//---------------------------------------------------------------------

reset_sync  u_rst_sync (
	      .scan_mode  (1'b0           ),
          .dclk      (mclk           ), // Destination clock domain
	      .arst_n     (s_reset_n      ), // active low async reset
          .srst_n    (s_reset_ssn    )
          );

reset_sync  u_prst_sync (
	      .scan_mode  (1'b0           ),
          .dclk      (mclk           ), // Destination clock domain
	      .arst_n     (p_reset_n      ), // active low async reset
          .srst_n    (p_reset_ssn    )
          );


//------------------------------------------------------------------
// Global Register
//------------------------------------------------------------------
glbl_reg u_glbl_reg(
      // System Signals
      // Inputs
          .mclk                         (mclk                    ),
	       .e_reset_n                    (e_reset_n               ),  // external reset
	       .p_reset_n                    (p_reset_ssn             ),  // power-on reset
          .s_reset_n                    (s_reset_ssn             ),

          .user_clock1                  (user_clock1             ),
          .user_clock2                  (user_clock2             ),

          .xtal_clk                     (xtal_clk                ),
          .usb_clk                      (usb_clk                 ),
          .rtc_clk                      (rtc_clk                 ),

          .sspim_rst_n                  (sspim_rst_n             ),
          .uart_rst_n                   (uart_rst_n              ),
          .i2cm_rst_n                   (i2cm_rst_n              ),
          .usb_rst_n                    (usb_rst_n               ),

          .cfg_multi_func_sel           (cfg_multi_func_sel      ),


      // Reg read/write Interface Inputs
         .reg_cs                       (reg_glbl_cs             ),
         .reg_wr                       (reg_wr                  ),
         .reg_addr                     (reg_addr[6:2]           ),
         .reg_wdata                    (reg_wdata               ),
         .reg_be                       (reg_be                  ),

         .reg_rdata                    (reg_glbl_rdata          ),
         .reg_ack                      (reg_glbl_ack            ),

         .user_irq                     (user_irq                ),
         .usb_intr                     (usb_intr                ),
         .i2cm_intr                    (i2cm_intr               ),
         .pwm_intr                     (pwm_intr                ),
         .rtc_intr                     (rtc_intr                ),

         .timer_intr                   (timer_intr             ),
         .gpio_intr                    (gpio_intr              ),

         .cfg_gpio_dgmode               (cfg_gpio_dgmode        )



   ); 

//-----------------------------------------------------------------------
// GPIO Top
//-----------------------------------------------------------------------
gpio_top  u_gpio(
              // System Signals
              // Inputs
		        .mclk                     ( mclk                      ),
              .h_reset_n                (s_reset_ssn                ),
              .cfg_gpio_dgmode          (cfg_gpio_dgmode            ),
              .pulse_1us                (pulse_1us                  ), 

		      // Reg Bus Interface Signal
              .reg_cs                   (reg_gpio_cs                ),
              .reg_wr                   (reg_wr                     ),
              .reg_addr                 (reg_addr[5:2]             ),
              .reg_wdata                (reg_wdata                  ),
              .reg_be                   (reg_be                     ),

              // Outputs
              .reg_rdata                (reg_gpio_rdata             ),
              .reg_ack                  (reg_gpio_ack               ),


              .cfg_gpio_dir_sel         (cfg_gpio_dir_sel           ),
              .pad_gpio_in              (pad_gpio_in                ),
              .pad_gpio_out             (pad_gpio_out               ),
              .pwm_gpio_in              (pwm_gpio_in                ),

              .gpio_intr                (gpio_intr                  )          


                ); 

//-----------------------------------------------------------------------
// PWM Top
//-----------------------------------------------------------------------
pwm_top  u_pwm(
              // System Signals
              // Inputs
		        .mclk                     ( mclk                      ),
              .h_reset_n                (s_reset_ssn                ),

		      // Reg Bus Interface Signal
              .reg_cs                   (reg_pwm_cs                 ),
              .reg_wr                   (reg_wr                     ),
              .reg_addr                 (reg_addr[6:2]              ),
              .reg_wdata                (reg_wdata                  ),
              .reg_be                   (reg_be                     ),

              // Outputs
              .reg_rdata                (reg_pwm_rdata              ),
              .reg_ack                  (reg_pwm_ack                ),

              .pad_gpio                 (pwm_gpio_in                ),
              .pwm_wfm                  (pwm_wfm                    ),
              .pwm_intr                 (pwm_intr                   ) 
           );

//-----------------------------------------------------------------------
// Timer Top
//-----------------------------------------------------------------------
timer_top  u_timer(
              // System Signals
              // Inputs
		        .mclk                     (mclk                     ),
              .h_reset_n                (s_reset_ssn              ),

		      // Reg Bus Interface Signal
              .reg_cs                   (reg_timer_cs               ),
              .reg_wr                   (reg_wr                     ),
              .reg_addr                 (reg_addr[3:2]              ),
              .reg_wdata                (reg_wdata                  ),
              .reg_be                   (reg_be                     ),

              // Outputs
              .reg_rdata                (reg_timer_rdata            ),
              .reg_ack                  (reg_timer_ack              ),

              .pulse_1us                (pulse_1us                  ), 
              .pulse_1ms                (pulse1m_mclk               ), 
              .timer_intr               (timer_intr                 ) 
           );

//-----------------------------------------------------------------------
// Semaphore Register
//-----------------------------------------------------------------------
semaphore_reg  u_semaphore(
              // System Signals
              // Inputs
		        .mclk                     ( mclk                      ),
              .h_reset_n                (s_reset_ssn                ),

		      // Reg Bus Interface Signal
              .reg_cs                   (reg_sema_cs                ),
              .reg_wr                   (reg_wr                     ),
              .reg_addr                 (reg_addr[5:2]              ),
              .reg_wdata                (reg_wdata[15:0]            ),
              .reg_be                   (reg_be[1:0]                ),

              // Outputs
              .reg_rdata                (reg_sema_rdata             ),
              .reg_ack                  (reg_sema_ack               )
         );

//----------------------------------------------------------------------
// Pinmux 
//----------------------------------------------------------------------

pinmux u_pinmux (

            // Digital IO
            .digital_io_out          (digital_io_out      ),
            .digital_io_oen          (digital_io_oen      ),
            .digital_io_in           (digital_io_in       ),

            .xtal_clk                (xtal_clk            ),

            // Config
            .cfg_gpio_dir_sel        (cfg_gpio_dir_sel    ),
            .cfg_multi_func_sel      (cfg_multi_func_sel  ),

            .cfg_pwm_enb             (cfg_pwm_enb         ),  
                                                      
            .pwm_wfm                 (pwm_wfm             ),

            .pad_gpio_in             (pad_gpio_in         ),  // GPIO data input from PAD
            .pad_gpio_out            (pad_gpio_out        ),  // GPIO Data out towards PAD

            // USB I/F
            .usb_dp_o                (usb_dp_o            ),
            .usb_dn_o                (usb_dn_o            ),
            .usb_oen                 (usb_oen             ),
            .usb_dp_i                (usb_dp_i            ),
            .usb_dn_i                (usb_dn_i            ),

            // UART I/F
            .uart_txd                (uart_txd            ),
            .uart_rxd                (uart_rxd            ),

            // I2CM I/F
            .i2cm_clk_o              (i2cm_clk_o          ),
            .i2cm_clk_i              (i2cm_clk_i          ),
            .i2cm_clk_oen            (i2cm_clk_oen        ),
            .i2cm_data_oen           (i2cm_data_oen       ),
            .i2cm_data_o             (i2cm_data_o         ),
            .i2cm_data_i             (i2cm_data_i         ),

            // SPI MASTER
            .spim_sck                (spim_sck            ),
            .spim_ssn                (spim_ssn            ),
            .spim_miso               (spim_miso           ),
            .spim_mosi               (spim_mosi           )
                                                
   );


//-------------------------------------------------
// Register Block Selection Logic
//-------------------------------------------------
reg [3:0] reg_blk_sel;

always @(posedge mclk or negedge s_reset_ssn)
begin
   if(s_reset_ssn == 1'b0) begin
     reg_blk_sel <= 'h0;
   end
   else begin
      if(reg_cs) reg_blk_sel <= reg_addr[10:7];
   end
end

assign reg_rdata = (reg_blk_sel    == `SEL_GLBL)  ? {reg_glbl_rdata} : 
	                (reg_blk_sel    == `SEL_GPIO)  ? {reg_gpio_rdata} :
	                (reg_blk_sel    == `SEL_PWM)   ? {reg_pwm_rdata}  :
	                (reg_blk_sel    == `SEL_TIMER) ? reg_timer_rdata  : 
	                (reg_blk_sel    == `SEL_SEMA)  ? {16'h0,reg_sema_rdata} : 
	                (reg_blk_sel    == `SEL_WS)    ? reg_ws_rdata     : 
	                (reg_blk_sel[3] == `SEL_PERI)  ? reg_peri_rdata   : 'h0;

assign reg_ack   = (reg_blk_sel    == `SEL_GLBL)  ? reg_glbl_ack   : 
	                (reg_blk_sel    == `SEL_GPIO)  ? reg_gpio_ack   : 
	                (reg_blk_sel    == `SEL_PWM)   ? reg_pwm_ack    : 
	                (reg_blk_sel    == `SEL_TIMER) ? reg_timer_ack  : 
	                (reg_blk_sel    == `SEL_SEMA)  ? reg_sema_ack   : 
	                (reg_blk_sel    == `SEL_WS)    ? reg_ws_ack     : 
	                (reg_blk_sel[3] == `SEL_PERI)  ? reg_peri_ack   : 1'b0;

assign reg_glbl_cs  = (reg_addr[10:7] == `SEL_GLBL) ? reg_cs : 1'b0;
assign reg_gpio_cs  = (reg_addr[10:7] == `SEL_GPIO) ? reg_cs : 1'b0;
assign reg_pwm_cs   = (reg_addr[10:7] == `SEL_PWM)  ? reg_cs : 1'b0;
assign reg_timer_cs = (reg_addr[10:7] == `SEL_TIMER)? reg_cs : 1'b0;
assign reg_sema_cs  = (reg_addr[10:7] == `SEL_SEMA) ? reg_cs : 1'b0;
assign reg_ws_cs    = (reg_addr[10:7] == `SEL_WS)   ? reg_cs : 1'b0;
assign reg_peri_cs  = (reg_addr[10]   == `SEL_PERI) ? reg_cs : 1'b0;

assign  reg_peri_wr    = reg_wr;
assign  reg_peri_addr  = reg_addr;
assign  reg_peri_wdata = reg_wdata;
assign  reg_peri_be    = reg_be;

endmodule 


