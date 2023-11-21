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
// SPDX-FileContributor: Created by Dinesh Annayya <dinesha@opencores.org>
//
//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Global Register                                             ////
////                                                              ////
////  This file is part of the riscduino cores project            ////
////  https://github.com/dineshannayya/riscduino.git              ////
////                                                              ////
////  Description                                                 ////
////      Hold all the Global and PinMux Register                 ////
////                                                              ////
////  To Do:                                                      ////
////    nothing                                                   ////
////                                                              ////
////  Author(s):                                                  ////
////      - Dinesh Annayya, dinesha@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//

module glbl_reg (
                       // System Signals
                       // Inputs
		               input logic             mclk                   ,
	                   input logic             e_reset_n              ,  // external reset
	                   input logic             p_reset_n              ,  // power-on reset
                       input logic             s_reset_n              ,  // soft reset

                       input logic            user_clock1            ,
                       input logic            user_clock2            ,
                       input logic            xtal_clk               ,

                       output logic            usb_clk                ,
                       output logic            rtc_clk                ,

                       // Global Reset control
                       output logic            sspim_rst_n            ,
                       output logic  [1:0]     uart_rst_n             ,
                       output logic            i2cm_rst_n             ,
                       output logic            usb_rst_n              ,

		       // Reg Bus Interface Signal
                       input logic             reg_cs                 ,
                       input logic             reg_wr                 ,
                       input logic [4:0]       reg_addr               ,
                       input logic [31:0]      reg_wdata              ,
                       input logic [3:0]       reg_be                 ,

                       // Outputs
                       output logic [31:0]     reg_rdata              ,
                       output logic            reg_ack                ,

		      // Risc configuration
                       output logic [2:0]      user_irq               ,
		               input  logic            usb_intr               ,
		               input  logic            i2cm_intr              ,
		               input  logic            pwm_intr              ,
		               input  logic            rtc_intr              ,

                       output  logic [31:0]    cfg_multi_func_sel     ,// multifunction pins
                        

		               input   logic [2:0]      timer_intr            ,
		               input   logic [31:0]     gpio_intr             ,

                       output logic          cfg_gpio_dgmode    
   ); 


                       
//-----------------------------------------------------------------------
// Internal Wire Declarations
//-----------------------------------------------------------------------

// logic          sw_rd_en               ;
logic          sw_wr_en;
logic [4:0]    sw_addr; // addressing 16 registers
logic [31:0]   sw_reg_wdata;
logic [3:0]    wr_be  ;

logic [31:0]   reg_out;
logic [31:0]   reg_1;  // Global Reg-0
logic [31:0]   reg_2;  // Global Reg-1
logic [31:0]   reg_3;  // Global Interrupt Mask
logic [31:0]   reg_4;  // Global Interrupt Status
logic [31:0]   reg_5;  // Multi Function Sel
logic [31:0]   reg_6;  // 
logic [31:0]   reg_9;  // Random Number
logic [31:0]   reg_15; // MailBox Reg
logic [31:0]   reg_16;  // Software Reg-0  - p_reset
logic [31:0]   reg_17;  // Software Reg-1  - p_reset
logic [31:0]   reg_18;  // Software Reg-2  - p_reset
logic [31:0]   reg_19;  // Software Reg-3  - p_reset
logic [31:0]   reg_20;  // Software Reg-4  - s_reset
logic [31:0]   reg_21;  // Software Reg-5  - s_reset
logic [31:0]   reg_22;  // Software Reg-6  - s_reset
logic [31:0]   reg_23;  // Software Reg-7  - s_reset

// logic           cs_int;
logic [3:0]     cfg_mon_sel;

assign       sw_addr       = reg_addr ;
// assign       sw_rd_en      = reg_cs & !reg_wr;
assign       sw_wr_en      = reg_cs & reg_wr;
assign       wr_be         = reg_be;
assign       sw_reg_wdata  = reg_wdata;


always @ (posedge mclk or negedge s_reset_n)
begin : preg_out_Seq
   if (s_reset_n == 1'b0) begin
      reg_rdata  <= 'h0;
      reg_ack    <= 1'b0;
   end else if (reg_cs && !reg_ack) begin
      reg_rdata <= reg_out ;
      reg_ack   <= 1'b1;
   end else begin
      reg_ack        <= 1'b0;
   end
end



//-----------------------------------------------------------------------
// register read enable and write enable decoding logic
//-----------------------------------------------------------------------

// wire   sw_wr_en_0  = sw_wr_en  & (sw_addr == 5'h0);
wire   sw_wr_en_1  = sw_wr_en  & (sw_addr == 5'h1);
wire   sw_wr_en_2  = sw_wr_en  & (sw_addr == 5'h2);
wire   sw_wr_en_3  = sw_wr_en  & (sw_addr == 5'h3);
wire   sw_wr_en_4  = sw_wr_en  & (sw_addr == 5'h4);
wire   sw_wr_en_5  = sw_wr_en  & (sw_addr == 5'h5);
wire   sw_wr_en_6  = sw_wr_en  & (sw_addr == 5'h6);
wire   sw_wr_en_7  = sw_wr_en  & (sw_addr == 5'h7);
wire   sw_wr_en_8  = sw_wr_en  & (sw_addr == 5'h8);
// wire   sw_wr_en_9  = sw_wr_en  & (sw_addr == 5'h9);
wire   sw_wr_en_10 = sw_wr_en  & (sw_addr == 5'hA);
// wire   sw_wr_en_11 = sw_wr_en  & (sw_addr == 5'hB);
// wire   sw_wr_en_12 = sw_wr_en  & (sw_addr == 5'hC);
wire   sw_wr_en_13 = sw_wr_en  & (sw_addr == 5'hD);
// wire   sw_wr_en_14 = sw_wr_en  & (sw_addr == 5'hE);
wire   sw_wr_en_15 = sw_wr_en  & (sw_addr == 5'hF);
wire   sw_wr_en_16 = sw_wr_en  & (sw_addr == 5'h10);
wire   sw_wr_en_17 = sw_wr_en  & (sw_addr == 5'h11);
wire   sw_wr_en_18 = sw_wr_en  & (sw_addr == 5'h12);
wire   sw_wr_en_19 = sw_wr_en  & (sw_addr == 5'h13);
wire   sw_wr_en_20 = sw_wr_en  & (sw_addr == 5'h14);
wire   sw_wr_en_21 = sw_wr_en  & (sw_addr == 5'h15);
wire   sw_wr_en_22 = sw_wr_en  & (sw_addr == 5'h16);
wire   sw_wr_en_23 = sw_wr_en  & (sw_addr == 5'h17);
// wire   sw_wr_en_24 = sw_wr_en  & (sw_addr == 5'h18);
// wire   sw_wr_en_25 = sw_wr_en  & (sw_addr == 5'h19);
// wire   sw_wr_en_26 = sw_wr_en  & (sw_addr == 5'h1A);
// wire   sw_wr_en_27 = sw_wr_en  & (sw_addr == 5'h1B);
// wire   sw_wr_en_28 = sw_wr_en  & (sw_addr == 5'h1C);
// wire   sw_wr_en_29 = sw_wr_en  & (sw_addr == 5'h1D);
// wire   sw_wr_en_30 = sw_wr_en  & (sw_addr == 5'h1E);
// wire   sw_wr_en_31 = sw_wr_en  & (sw_addr == 5'h1F);

// wire   sw_rd_en_0  = sw_rd_en  & (sw_addr == 5'h0);
// wire   sw_rd_en_1  = sw_rd_en  & (sw_addr == 5'h1);
// wire   sw_rd_en_2  = sw_rd_en  & (sw_addr == 5'h2);
// wire   sw_rd_en_3  = sw_rd_en  & (sw_addr == 5'h3);
// wire   sw_rd_en_4  = sw_rd_en  & (sw_addr == 5'h4);
// wire   sw_rd_en_5  = sw_rd_en  & (sw_addr == 5'h5);
// wire   sw_rd_en_6  = sw_rd_en  & (sw_addr == 5'h6);
// wire   sw_rd_en_7  = sw_rd_en  & (sw_addr == 5'h7);
// wire   sw_rd_en_8  = sw_rd_en  & (sw_addr == 5'h8);
// wire   sw_rd_en_9  = sw_rd_en  & (sw_addr == 5'h9);
// wire   sw_rd_en_10 = sw_rd_en  & (sw_addr == 5'hA);
// wire   sw_rd_en_11 = sw_rd_en  & (sw_addr == 5'hB);
// wire   sw_rd_en_12 = sw_rd_en  & (sw_addr == 5'hC);
// wire   sw_rd_en_13 = sw_rd_en  & (sw_addr == 5'hD);
// wire   sw_rd_en_14 = sw_rd_en  & (sw_addr == 5'hE);
// wire   sw_rd_en_15 = sw_rd_en  & (sw_addr == 5'hF);
// wire   sw_rd_en_16 = sw_rd_en  & (sw_addr == 5'h10);
// wire   sw_rd_en_17 = sw_rd_en  & (sw_addr == 5'h11);
// wire   sw_rd_en_18 = sw_rd_en  & (sw_addr == 5'h12);
// wire   sw_rd_en_19 = sw_rd_en  & (sw_addr == 5'h13);
// wire   sw_rd_en_20 = sw_rd_en  & (sw_addr == 5'h14);
// wire   sw_rd_en_21 = sw_rd_en  & (sw_addr == 5'h15);
// wire   sw_rd_en_22 = sw_rd_en  & (sw_addr == 5'h16);
// wire   sw_rd_en_23 = sw_rd_en  & (sw_addr == 5'h17);
// wire   sw_rd_en_24 = sw_rd_en  & (sw_addr == 5'h18);
// wire   sw_rd_en_25 = sw_rd_en  & (sw_addr == 5'h19);
// wire   sw_rd_en_26 = sw_rd_en  & (sw_addr == 5'h1A);
// wire   sw_rd_en_27 = sw_rd_en  & (sw_addr == 5'h1B);
// wire   sw_rd_en_28 = sw_rd_en  & (sw_addr == 5'h1C);
// wire   sw_rd_en_29 = sw_rd_en  & (sw_addr == 5'h1D);
// wire   sw_rd_en_30 = sw_rd_en  & (sw_addr == 5'h1E);
// wire   sw_rd_en_31 = sw_rd_en  & (sw_addr == 5'h1F);

//-----------------------------------------------------------------------
// Individual register assignments
//-----------------------------------------------------------------------

//------------------------------------------
// reg-1: GLBL_CFG_0
//------------------------------------------
wire [31:0] cfg_rst_ctrl = reg_1;

ctech_buf u_buf_sspim_rst     (.A(cfg_rst_ctrl[2]),.X(sspim_rst_n));
ctech_buf u_buf_uart0_rst     (.A(cfg_rst_ctrl[3]),.X(uart_rst_n[0]));
ctech_buf u_buf_i2cm_rst      (.A(cfg_rst_ctrl[4]),.X(i2cm_rst_n));
ctech_buf u_buf_usb_rst       (.A(cfg_rst_ctrl[5]),.X(usb_rst_n));
ctech_buf u_buf_uart1_rst     (.A(cfg_rst_ctrl[6]),.X(uart_rst_n[1]));

//-----------------------------------------------------------------------
//   reg-3 : Global Interrupt Mask
//-----------------------------------------------------------------------

gen_32b_reg  u_reg_3	(
	      //List of Inputs
	      .reset_n    (s_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_3    ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_3         )
	      );

//-----------------------------------------------------------------------
//   reg-4 : Global Interrupt Status
//-----------------------------------------------------------------

logic usb_intr_s,usb_intr_ss;   // Usb Interrupt Double Sync
logic i2cm_intr_s,i2cm_intr_ss; // I2C Interrupt Double Sync
logic rtc_intr_s,rtc_intr_ss;

always @ (posedge mclk or negedge s_reset_n)
begin  
   if (s_reset_n == 1'b0) begin
     usb_intr_s       <= 'h0;
     usb_intr_ss      <= 'h0;
     i2cm_intr_s      <= 'h0;
     i2cm_intr_ss     <= 'h0;
     rtc_intr_s       <= 'h0;
     rtc_intr_ss      <= 'h0;

   end else begin
     usb_intr_s   <= usb_intr;
     usb_intr_ss  <= usb_intr_s;
     i2cm_intr_s  <= i2cm_intr;
     i2cm_intr_ss <= i2cm_intr_s;
     rtc_intr_s   <= rtc_intr;
     rtc_intr_ss  <= rtc_intr_s;

   end
end

wire [31:0] hware_intr_req = {gpio_intr[31:8], 1'b0,rtc_intr_ss,pwm_intr,usb_intr_ss, i2cm_intr_ss,timer_intr[2:0]};

// Interrupt can be set by hware req or by writting reg_10
wire [31:0]  intr_req = {{({8{sw_wr_en_10 & reg_ack & wr_be[3]}} & sw_reg_wdata[31:24]) | hware_intr_req[31:24] },
                        {({8{sw_wr_en_10 & reg_ack & wr_be[2]}} & sw_reg_wdata[23:16]) | hware_intr_req[23:16] },
                        {({8{sw_wr_en_10 & reg_ack & wr_be[1]}} & sw_reg_wdata[15:8])  | hware_intr_req[15:8]  },
                        {({8{sw_wr_en_10 & reg_ack & wr_be[0]}} & sw_reg_wdata[7:0])   | hware_intr_req[7:0]  }};


generic_intr_stat_reg #(.WD(32),
	                .RESET_DEFAULT(0)) u_reg4 (
		 //inputs
		 .clk         (mclk              ),
		 .reset_n     (s_reset_n         ),
	     .reg_we      ({{8{sw_wr_en_4 & reg_ack & wr_be[3]}},
                        {8{sw_wr_en_4 & reg_ack & wr_be[2]}},
                        {8{sw_wr_en_4 & reg_ack & wr_be[1]}},
                        {8{sw_wr_en_4 & reg_ack & wr_be[0]}}}),		 
		 .reg_din    (sw_reg_wdata[31:0] ),
		 .hware_req  (intr_req           ),
		 
		 //outputs
		 .data_out    (reg_4[31:0]       )
	      );

//-----------------------------------------------------------------------
// Logic for cfg_multi_func_sel :Enable GPIO to act as multi function pins 
//-----------------------------------------------------------------------
assign  cfg_multi_func_sel = reg_5[31:0]; // to be used for read

// bit[31] '1' - uart master enable on power up
// bit[30] '1' - Riscv Tap enable on power up

gen_32b_reg  #(32'hC000_0000) u_reg_5	(
	      //List of Inputs
	      .reset_n    (s_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_5    ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_5        )
	      );


//-----------------------------------------
// Reg-6: Clock Control
// ----------------------------------------
gen_32b_reg  u_reg_6	(
	      //List of Inputs
	      .reset_n    (s_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_6   ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_6       )
	      );
wire [7:0] cfg_rtc_clk_ctrl     = reg_6[7:0];
wire [7:0] cfg_usb_clk_ctrl     = reg_6[15:8];

//------------------------------------------
// reg_9: Random Number Generator
//------------------------------------------

pseudorandom u_random (
  .rst_n     ( s_reset_n     ), 
  .clk       ( mclk          ), 
  .next      ( reg_ack       ), 
  .random    ( reg_9         )  
);

//-----------------------------------------
// MailBox Register
// ----------------------------------------

gen_32b_reg u_reg_15	(
	      //List of Inputs
	      .reset_n    (s_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_15   ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_15       )
	      );

//-----------------------------------------
// Software Reg-0
// ----------------------------------------

gen_32b_reg  u_reg_16	(
	      //List of Inputs
	      .reset_n    (p_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_16    ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_16       )
	      );

//-----------------------------------------
// Software Reg-1
// ----------------------------------------

gen_32b_reg  u_reg_17	(
	      //List of Inputs
	      .reset_n    (p_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_17    ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_17       )
	      );

//-----------------------------------------
// Software Reg-2
// ----------------------------------------

gen_32b_reg  u_reg_18	(
	      //List of Inputs
	      .reset_n    (p_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_18    ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_18       )
	      );

//-----------------------------------------
// Software Reg-3
// ----------------------------------------

gen_32b_reg  u_reg_19	(
	      //List of Inputs
	      .reset_n    (s_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_19   ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_19       )
	      );

//-----------------------------------------
// Software Reg-4
// ----------------------------------------

gen_32b_reg  u_reg_20	(
	      //List of Inputs
	      .reset_n    (s_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_20   ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_20       )
	      );

//-----------------------------------------
// Software Reg-5
// ----------------------------------------

gen_32b_reg  u_reg_21	(
	      //List of Inputs
	      .reset_n    (s_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_21    ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_21       )
	      );

//-----------------------------------------
// Software Reg-6: 
// ----------------------------------------

gen_32b_reg  u_reg_22	(
	      //List of Inputs
	      .reset_n    (s_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_22    ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_22       )
	      );

//-----------------------------------------
// Software Reg-7
// ----------------------------------------

gen_32b_reg  u_reg_23	(
	      //List of Inputs
	      .reset_n    (s_reset_n     ),
	      .clk        (mclk          ),
	      .cs         (sw_wr_en_23   ),
	      .we         (wr_be         ),		 
	      .data_in    (sw_reg_wdata  ),
	      
	      //List of Outs
	      .data_out   (reg_23       )
	      );


//-----------------------------------------------------------------------
// Register Read Path Multiplexer instantiation
//-----------------------------------------------------------------------

always_comb
begin 
  reg_out [31:0] = 32'h0;

  case (sw_addr [4:0])
    5'b00000 : reg_out [31:0] = 'h0    ;     
    5'b00001 : reg_out [31:0] = reg_1  ;    
    5'b00010 : reg_out [31:0] = reg_2  ;     
    5'b00011 : reg_out [31:0] = reg_3  ;    
    5'b00100 : reg_out [31:0] = reg_4  ;    
    5'b00101 : reg_out [31:0] = reg_5  ;    
    5'b00110 : reg_out [31:0] = reg_6  ;    
    5'b00111 : reg_out [31:0] = 'h0    ;    
    5'b01000 : reg_out [31:0] = 'h0    ;    
    5'b01001 : reg_out [31:0] = reg_9  ;    
    5'b01010 : reg_out [31:0] = reg_4  ; // Interrupt Set   
    5'b01011 : reg_out [31:0] = 'h0 ;   
    5'b01100 : reg_out [31:0] = 'h0 ;   
    5'b01101 : reg_out [31:0] = 'h0 ;   
    5'b01110 : reg_out [31:0] = 'h0 ;   
    5'b01111 : reg_out [31:0] = reg_15 ;   
    5'b10000 : reg_out [31:0] = reg_16  ;     
    5'b10001 : reg_out [31:0] = reg_17  ;    
    5'b10010 : reg_out [31:0] = reg_18  ;     
    5'b10011 : reg_out [31:0] = reg_19  ;    
    5'b10100 : reg_out [31:0] = reg_20  ;    
    5'b10101 : reg_out [31:0] = reg_21  ;    
    5'b10110 : reg_out [31:0] = reg_22  ;    
    5'b10111 : reg_out [31:0] = reg_23  ;    
    5'b11000 : reg_out [31:0] = 'h0  ;    
    5'b11001 : reg_out [31:0] = 'h0  ;    
    5'b11010 : reg_out [31:0] = 'h0 ;   
    5'b11011 : reg_out [31:0] = 'h0 ;   
    5'b11100 : reg_out [31:0] = 'h0 ;   
    5'b11101 : reg_out [31:0] = 'h0 ;   
    5'b11110 : reg_out [31:0] = 'h0 ;   
    5'b11111 : reg_out [31:0] = 'h0 ;   
    default  : reg_out [31:0] = 32'h0;
  endcase
end


//----------------------------------
// Generate RTC Clock Generation
//----------------------------------

wire   rtc_clk_div;
wire   rtc_ref_clk_int;
wire   rtc_ref_clk;
wire   rtc_clk_int;

wire [1:0] cfg_rtc_clk_sel_sel   = cfg_rtc_clk_ctrl[7:6];
wire       cfg_rtc_clk_div       = cfg_rtc_clk_ctrl[5];
wire [4:0] cfg_rtc_clk_ratio     = cfg_rtc_clk_ctrl[4:0];

assign rtc_ref_clk_int = (cfg_rtc_clk_sel_sel ==2'b00) ? user_clock1   :
                         (cfg_rtc_clk_sel_sel ==2'b01) ? user_clock2   : xtal_clk;

ctech_clk_buf u_rtc_ref_clkbuf (.A (rtc_ref_clk_int), . X(rtc_ref_clk));

ctech_mux2x1_4 u_rtc_clk_sel (.A0 (rtc_ref_clk), .A1 (rtc_clk_div), .S  (cfg_rtc_clk_div), .X  (rtc_clk_int));


ctech_clk_buf u_clkbuf_rtc (.A (rtc_clk_int), . X(rtc_clk));

clk_ctl #(4) u_rtcclk (
   // Outputs
       .clk_o         (rtc_clk_div      ),
   // Inputs
       .mclk          (rtc_ref_clk      ),
       .reset_n       (s_reset_n        ), 
       .clk_div_ratio (cfg_rtc_clk_ratio)
   );

//----------------------------------
// Generate USB Clock Generation
//----------------------------------

wire   usb_clk_div;
wire   usb_ref_clk_int;
wire   usb_ref_clk;
wire   usb_clk_int;

wire [1:0] cfg_usb_clk_sel_sel   = cfg_usb_clk_ctrl[7:6];
wire       cfg_usb_clk_div       = cfg_usb_clk_ctrl[5];
wire [4:0] cfg_usb_clk_ratio     = cfg_usb_clk_ctrl[4:0];

assign usb_ref_clk_int = (cfg_usb_clk_sel_sel ==2'b00) ? user_clock1   :
                         (cfg_usb_clk_sel_sel ==2'b01) ? user_clock2   : xtal_clk;	

ctech_clk_buf u_usb_ref_clkbuf (.A (usb_ref_clk_int), . X(usb_ref_clk));

ctech_mux2x1_4 u_usb_clk_sel (.A0 (usb_ref_clk), .A1 (usb_clk_div), .S  (cfg_usb_clk_div), .X  (usb_clk_int));

ctech_clk_buf u_clkbuf_usb (.A (usb_clk_int), . X(usb_clk));

clk_ctl #(4) u_usbclk (
   // Outputs
       .clk_o         (usb_clk_div      ),
   // Inputs
       .mclk          (usb_ref_clk      ),
       .reset_n       (s_reset_n        ), 
       .clk_div_ratio (cfg_usb_clk_ratio)
   );

endmodule                       
