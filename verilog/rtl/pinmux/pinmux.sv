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

/*********************************************************************************
* CONFIG                            **           Caravel Pin Mapping
**********************************************************************************
* PC6/RESET                         **           digital_io[5]                  **
* PD0/RXD[0]                        **           digital_io[6]                  **
* PD1/TXD[0]                        **           digital_io[7]                  **
* PD2/RXD[1]                        **           digital_io[8]                  **
* PD3/PWM0                          **           digital_io[9]                  **
* PD4/TXD[1]                        **           digital_io[10]                 **
* PB6/XTAL                          **           digital_io[11]                 **
* PB7                               **           digital_io[12]                 **
* PD5/SS[3]/PWM1                    **           digital_io[13]                 **
* PD6/SS[2]/PWM2                    **           digital_io[14]                 **
* PD7                               **           digital_io[15]                 **
* PB0                               **           digital_io[16]                 **
* PB1/SS[1]/PWM3                    **           digital_io[17]                 **
* PB2/SS[0]/PWM4                    **           digital_io[18]                 **
* PB3/MOSI/PWM5                     **           digital_io[19]                 **
* PB4/MISO                          **           digital_io[20]                 **
* PB5/SCK                           **           digital_io[21]                 **
* PC0                               **           digital_io[22]                 **
* PC1                               **           digital_io[23]                 **
* PC2/usb_dp                        **           digital_io[24]                 **
* PC3/usb_dn                        **           digital_io[25]                 **
* PC4/SDA                           **           digital_io[26]                 **
* PC5/SCL                           **           digital_io[27]                 **
*

********************************************************************************                     
********************************************************************************/


module pinmux (
               
               // Digital IO
               output logic [37:0]     digital_io_out          ,
               output logic [37:0]     digital_io_oen          ,
               input  logic [37:0]     digital_io_in           ,

               output logic            xtal_clk                ,

               // Config
               input logic  [31:0]    cfg_gpio_dir_sel         ,
               input logic  [31:0]    cfg_multi_func_sel       ,

               output logic[5:0]       cfg_pwm_enb             ,
               input logic [5:0]       pwm_wfm                 ,

               output  logic [31:0]    pad_gpio_in             ,  // GPIO data input from PAD
               input  logic [31:0]     pad_gpio_out            ,  // GPIO Data out towards PAD

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
		       output  logic           spim_mosi
   );

reg [7:0]     port_a_in;      // PORT A Data In
reg [7:0]     port_b_in;      // PORT B Data In
reg [7:0]     port_c_in;      // PORT C Data In
reg [7:0]     port_d_in;      // PORT D Data In

wire [7:0]    port_a_out;     // PORT A Data Out
wire [7:0]    port_b_out;     // PORT B Data Out
wire [7:0]    port_c_out;     // PORT C Data Out
wire [7:0]    port_d_out;     // PORT D Data Out


// GPIO to PORT Mapping
assign      pad_gpio_in[7:0]     = port_a_in;
assign      pad_gpio_in[15:8]    = port_b_in;
assign      pad_gpio_in[23:16]   = port_c_in;
assign      pad_gpio_in[31:24]   = port_d_in;

assign      port_a_out           = pad_gpio_out[7:0];
assign      port_b_out           = pad_gpio_out[15:8];
assign      port_c_out           = pad_gpio_out[23:16];
assign      port_d_out           = pad_gpio_out[31:24];


assign      cfg_pwm_enb          = cfg_multi_func_sel[5:0];
wire [1:0]  cfg_int_enb          = cfg_multi_func_sel[7:6];
wire [1:0]  cfg_uart_enb         = cfg_multi_func_sel[9:8];
wire        cfg_spim_enb         = cfg_multi_func_sel[10];
wire [3:0]  cfg_spim_cs_enb      = cfg_multi_func_sel[14:11];
wire        cfg_i2cm_enb         = cfg_multi_func_sel[15];
wire        cfg_usb_enb          = cfg_multi_func_sel[16];

wire [7:0]  cfg_port_a_dir_sel   = cfg_gpio_dir_sel[7:0];
wire [7:0]  cfg_port_b_dir_sel   = cfg_gpio_dir_sel[15:8];
wire [7:0]  cfg_port_c_dir_sel   = cfg_gpio_dir_sel[23:16];
wire [7:0]  cfg_port_d_dir_sel   = cfg_gpio_dir_sel[31:24];

// This logic to create spi slave interface
logic        pin_resetn,spis_boot;

// On Reset internal SPI Master is disabled, If cfg_spim_enb = 0, then we are in
// SPIS Boot Mode
assign      spis_boot = (cfg_spim_enb ) ? 1'b0: !pin_resetn; 

// datain selection
always_comb begin
     port_a_in = 'h0;
     port_b_in = 'h0;
     port_c_in = 'h0;
     port_d_in = 'h0;
     uart_rxd   = 'b1;
     spim_mosi  = 'h0;
     i2cm_data_i= 'h0;
     i2cm_clk_i = 'h0;
     xtal_clk   = 'b0;

     // **  PC6/RESET       **          digital_io[5]
     port_c_in[6] = digital_io_in[5];
     pin_resetn   = digital_io_in[5];

     // ** PD0/RXD[0]       **      digital_io[6]
     port_d_in[0] = digital_io_in[6];
     if(cfg_uart_enb[0])  uart_rxd[0]   = digital_io_in[6];

     // ** PD1/TXD[0]       **      digital_io[7]
     port_d_in[1] = digital_io_in[7];

     // ** PD2/RXD[1]        **      digital_io[8]
     port_d_in[2] = digital_io_in[8];
     if(cfg_uart_enb[1])     uart_rxd[1]    = digital_io_in[8];

     // **  PD3/PWM0         **        digital_io[9]
     port_d_in[3] = digital_io_in[9];

     // **  PD4/TXD[1]          **  digital_io[10]
     port_d_in[4] = digital_io_in[10];

     //  ** PB6/XTAL1/TOSC1        **       digital_io[11]
     port_b_in[6] = digital_io_in[11];
     xtal_clk     = digital_io_in[11];

     // **  PB7           **           digital_io[12]
     port_b_in[7] = digital_io_in[12];

     // **  PD5/SS[3]/PWM1      **       digital_io[13]
     port_d_in[5] = digital_io_in[13];

     // ** PD6/SS[2]/PWM2        **        digital_io[14]
     port_d_in[6] = digital_io_in[14];

     //  **  PD7          **        digital_io[15]
     port_d_in[7] = digital_io_in[15];
     
     //  **  PB0          **        digital_io[16]
     port_b_in[0] =  digital_io_in[16];

     // **  PB1/SS[1]/PWM3           **        digital_io[17]
     port_b_in[1] = digital_io_in[17];

     // **  PB2/SS/PWM4        **        digital_io[18]
     port_b_in[2] = digital_io_in[18];

     // **  PB3/MOSI/PWM5      **        digital_io[19]
     port_b_in[3] = digital_io_in[19];
     if(cfg_spim_enb) spim_mosi = digital_io_in[19];        // SPIM MOSI (Input) = SPIS MISO (Output)

     // **  PB4/MISO          **        digital_io[20]
     port_b_in[4] = digital_io_in[20];

     // ** PB5/SCK        **      digital_io[21]
     port_b_in[5]= digital_io_in[21];
     
     // ** PC0        **       digital_io[22]
     port_c_in[0] = digital_io_in[22];

     // ** PC1        **       digital_io[23]
     port_c_in[1] = digital_io_in[23];

     // **   PC2      **   digital_io[24]/usb_dp
     usb_dp_i     = (cfg_usb_enb) ? digital_io_in[24] : 1'b1;
     port_c_in[2] = digital_io_in[24];

     // **   PC3      **   digital_io[25]/usb_dn
     usb_dn_i     = (cfg_usb_enb) ? digital_io_in[25] : 1'b1;
     port_c_in[3] = digital_io_in[25];

     // **   PC4/SDA  **  digital_io[26]
     port_c_in[4] = digital_io_in[26];
     if(cfg_i2cm_enb)  i2cm_data_i = digital_io_in[26];

     // **   PC5/SCL  **  digital_io[27]
     port_c_in[5] = digital_io_in[27];
     if(cfg_i2cm_enb)  i2cm_clk_i = digital_io_in[27];

     port_a_in[0] = digital_io_in[0];
     port_a_in[1] = digital_io_in[1];
     port_a_in[2] = digital_io_in[2];
     port_a_in[3] = digital_io_in[3];
     port_a_in[4] = digital_io_in[4];

end

// dataout selection
always_comb begin
     digital_io_out = 'h0;

     // **  PC6/RESET       **          digital_io[5]
     if(cfg_port_c_dir_sel[6])    digital_io_out[5]   = port_c_out[6];

     // ** PD2/RXD[0]      **      digital_io[6]
     if(cfg_port_d_dir_sel[0])    digital_io_out[6]   = port_d_out[0];
  
     //** PD1/TXD[0]       **      digital_io[7]
     if(cfg_uart_enb[0])              digital_io_out[7]  = uart_txd[0];
     else if(cfg_port_d_dir_sel[1])   digital_io_out[7]  = port_d_out[1];

     // ** PD2/RXD[1]/INT0       **      digital_io[8]
     if(cfg_port_d_dir_sel[2])   digital_io_out[8]   = port_d_out[2];

     // **  PD3/INT1/PWM0       **        digital_io[9]
     if(cfg_pwm_enb[0])              digital_io_out[9]   = pwm_wfm[0];
     else if(cfg_port_d_dir_sel[3])  digital_io_out[9]   = port_d_out[3];

     //** PD4/TXD[1]       **      digital_io[10]
     if   (cfg_uart_enb[1])               digital_io_out[10]   = uart_txd[1];
     else if(cfg_port_d_dir_sel[4])       digital_io_out[10]   = port_d_out[4];

     //  ** PB6/XTAL1/TOSC1        **       digital_io[11]
     if(cfg_port_b_dir_sel[6])    digital_io_out[11]   = port_b_out[6];

     // **  PB7           **           digital_io[12]
     if(cfg_port_b_dir_sel[7])    digital_io_out[12]   = port_b_out[7];

     // **  PD5/SS[3]/PWM1      **       digital_io[13]
     if(cfg_pwm_enb[1])              digital_io_out[13]   = pwm_wfm[1];
     else if(cfg_spim_cs_enb[3])     digital_io_out[13]   = spim_ssn[3];
     else if(cfg_port_d_dir_sel[5])  digital_io_out[13]   = port_d_out[5];

     // ** PD6/SS[2]/PWM2        **        digital_io[14]
     if(cfg_pwm_enb[2])              digital_io_out[14]   = pwm_wfm[2];
     else if(cfg_spim_cs_enb[2])     digital_io_out[14]   = spim_ssn[2];
     else if(cfg_port_d_dir_sel[6])  digital_io_out[14]   = port_d_out[6];

     //  **  PD7          **        digital_io[15]
     if(cfg_port_d_dir_sel[7])  digital_io_out[15]  = port_d_out[7];

     //  **  PB0          **        digital_io[16]
     if(cfg_port_b_dir_sel[0])  digital_io_out[16]  = port_b_out[0];

     // **  PB1/SS[1]/PWM3           **        digital_io[17]
     if(cfg_pwm_enb[3])              digital_io_out[17]    = pwm_wfm[3];
     else if(cfg_spim_cs_enb[1])     digital_io_out[17]    = spim_ssn[1];
     else if(cfg_port_b_dir_sel[1])  digital_io_out[17]    = port_b_out[1];

     // **  PB2/SS/PWM4        **        digital_io[18]
     if(cfg_pwm_enb[4])              digital_io_out[18]  = pwm_wfm[4];
     else if(cfg_spim_cs_enb[0])     digital_io_out[18]  = spim_ssn[0];
     else if(cfg_port_b_dir_sel[2])  digital_io_out[18]  = port_b_out[2];

     // **  PB3/MOSI/PWM5      **        digital_io[19]
     if(cfg_pwm_enb[5])                digital_io_out[19]  = pwm_wfm[5];
     else if(cfg_port_b_dir_sel[3])    digital_io_out[19]  = port_b_out[3];

     // **  PB4/MISO          **        digital_io[20]
     if(cfg_spim_enb)                digital_io_out[20]  = spim_miso;   // SPIM MISO (Output) = SPIS MOSI (Input)
     else if(cfg_port_b_dir_sel[4])  digital_io_out[20]  = port_b_out[4];

     // ** PB5/SCK        **      digital_io[21]
     if(cfg_spim_enb)                digital_io_out[21]  = spim_sck;      // SPIM SCK (Output) = SPIS SCK (Input)
     else if(cfg_port_b_dir_sel[5])  digital_io_out[21]  = port_b_out[5];

     // ** PC0             **    digital_io[22]
     if(cfg_port_c_dir_sel[0])  digital_io_out[22]  = port_c_out[0];

     // ** PC1             **    digital_io[23]
     if(cfg_port_c_dir_sel[1])  digital_io_out[23]  = port_c_out[1];

     // **   PC2/USB_DP    **   digital_io[24]
     if(cfg_usb_enb)                 digital_io_out[24]  = usb_dp_o;
     else if(cfg_port_c_dir_sel[2])  digital_io_out[24]  = port_c_out[2];

     // **   PC3/USB_DN    **   digital_io[25]
     if(cfg_usb_enb)                 digital_io_out[25]  = usb_dn_o;
     if(cfg_port_c_dir_sel[3])       digital_io_out[25]  = port_c_out[3];

     // **   PC4/SDA       **   digital_io[26]
     if(cfg_i2cm_enb)                digital_io_out[26]  = i2cm_data_o;
     else if(cfg_port_c_dir_sel[4])  digital_io_out[26]  = port_c_out[4];

     // **   PC5/SCL       **   digital_io[27]
     if(cfg_i2cm_enb)                digital_io_out[27]  = i2cm_clk_o;
     else if(cfg_port_c_dir_sel[5])  digital_io_out[27]  = port_c_out[5];

end

// dataoen selection
always_comb begin
     digital_io_oen = 38'h3F_FFFF_FFFF;

     // **  PC6/RESET       **          digital_io[5]
     if(cfg_port_c_dir_sel[6])    digital_io_oen[5]   = 1'b0;

     // ** PD2/RXD[0]      **      digital_io[6]
     if(cfg_uart_enb[0])             digital_io_oen[6]   = 1'b1;
     else if(cfg_port_d_dir_sel[0])  digital_io_oen[6]   = 1'b0;

     //** PD1/TXD[0]       **      digital_io[7]
     if(cfg_uart_enb[0])             digital_io_oen[7]   = 1'b0;
     else if(cfg_port_d_dir_sel[1])  digital_io_oen[7]   = 1'b0;

     // ** PD2/RXD[1]/INT0       **      digital_io[8]
     if(cfg_int_enb[0])              digital_io_oen[8]   = 1'b1;
     else if(cfg_port_d_dir_sel[2])  digital_io_oen[8]   = 1'b0;

     // **  PD3/INT1/PWM0       **        digital_io[9]
     if(cfg_pwm_enb[0])              digital_io_oen[9]   = 1'b0;
     else if(cfg_int_enb[1])         digital_io_oen[9]   = 1'b1;
     else if(cfg_port_d_dir_sel[3])  digital_io_oen[9]   = 1'b0;

     //** PD4/TXD[1]       **      digital_io[10]
     if   (cfg_uart_enb[1])          digital_io_oen[10]   = 1'b0;
     else if(cfg_port_d_dir_sel[4])  digital_io_oen[10]   = 1'b0;

     //  ** PB6/XTAL1/TOSC1        **       digital_io[11]
     if(cfg_port_b_dir_sel[6])       digital_io_oen[11]   = 1'b0;

     // **  PB7           **           digital_io[12]
     if(cfg_port_b_dir_sel[7])       digital_io_oen[12]   = 1'b0;

     // **  PD5/SS[3]/PWM1      **       digital_io[13]
     if(cfg_pwm_enb[1])              digital_io_oen[13]   = 1'b0;
     else if(cfg_spim_cs_enb[3])     digital_io_oen[13]   = 1'b0;
     else if(cfg_port_d_dir_sel[5])  digital_io_oen[13]   = 1'b0;

     // ** PD6/SS[2]/PWM2        **        digital_io[14]
     if(cfg_pwm_enb[2])              digital_io_oen[14]   = 1'b0;
     else if(cfg_spim_cs_enb[2])     digital_io_oen[14]   = 1'b0;
     else if(cfg_port_d_dir_sel[6])  digital_io_oen[14]   = 1'b0;

     //  **  PD7         **       digital_io[15]
     if(cfg_port_d_dir_sel[7])       digital_io_oen[15]  = 1'b0;

     //  **  PB0         **      digital_io[16]
     if(cfg_port_b_dir_sel[0])       digital_io_oen[16]  = 1'b0;

     // **  PB1/SS[1]/PWM3           **        digital_io[17]
     if(cfg_pwm_enb[3])              digital_io_oen[17]  = 1'b0;
     else if(cfg_spim_cs_enb[1])     digital_io_oen[17]  = 1'b0;
     else if(cfg_port_b_dir_sel[1])  digital_io_oen[17]  = 1'b0;

     // **  PB2/SS/PWM4        **        digital_io[18]
     if(cfg_pwm_enb[4])              digital_io_oen[18]  = 1'b0;
     else if(cfg_spim_cs_enb[0])     digital_io_oen[18]  = 1'b0;
     else if(cfg_port_b_dir_sel[2])  digital_io_oen[18]  = 1'b0;

     // **  PB3/MOSI/PWM5      **        digital_io[19]
     if(cfg_spim_enb)                digital_io_oen[19]  = 1'b1; // SPIM MOSI (Input)
     else if(cfg_pwm_enb[5])         digital_io_oen[19]  = 1'b0;
     else if(cfg_port_b_dir_sel[3])  digital_io_oen[19]  = 1'b0;

     // **  PB4/MISO          **        digital_io[20]
     if(cfg_spim_enb)                 digital_io_oen[20]  = 1'b0; // SPIM MISO (Output) 
     else if(cfg_port_b_dir_sel[4])   digital_io_oen[20]  = 1'b0;

     // ** PB5/SCK        **      digital_io[21]
     if(cfg_spim_enb)                digital_io_oen[21]  = 1'b0; // SPIM SCK (Output)
     else if(cfg_port_b_dir_sel[5])  digital_io_oen[21]  = 1'b0;

     // ** PC0             **    digital_io[22]
     if(cfg_port_c_dir_sel[0])       digital_io_oen[22]  = 1'b0;

     // ** PC1             **    digital_io[23]
     if(cfg_port_c_dir_sel[1])       digital_io_oen[23]  = 1'b0;

     // **   PC2/USB_DP    **   digital_io[24]
     if(cfg_usb_enb)                 digital_io_oen[24]  = usb_oen;
     else if(cfg_port_c_dir_sel[2])  digital_io_oen[24]  = 1'b0;

     // **   PC3/USB_DN    **   digital_io[25]
     if(cfg_usb_enb)                 digital_io_oen[25]  = usb_oen;
     else if(cfg_port_c_dir_sel[3])  digital_io_oen[25]  = 1'b0;

     // **   PC4/SDA       **   digital_io[26]
     if(cfg_i2cm_enb)                digital_io_oen[26]  = i2cm_data_oen;
     else if(cfg_port_c_dir_sel[4])  digital_io_oen[26]  = 1'b0;

     // **   PC5/SCL       **   digital_io[27]
     if(cfg_i2cm_enb)                digital_io_oen[27]  = i2cm_clk_oen;
     else if(cfg_port_c_dir_sel[5])  digital_io_oen[27]  = 1'b0;

end


endmodule 


