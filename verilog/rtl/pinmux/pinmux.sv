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
* PD0/RXD[0]                        **           digital_io[21]                 **
* PD1/TXD[0]                        **           digital_io[22]                 **
* PD2/RXD[1]                        **           digital_io[23]                 **
* PD3/PWM0                          **           digital_io[24]                 **
* PD4/TXD[1]                        **           digital_io[25]                 **
* PB6/XTAL                          **           digital_io[26]                 **
* PD5/SS[3]/PWM1                    **           digital_io[27]                 **
* PD6/SS[2]/PWM2                    **           digital_io[28]                 **
* PB1/SS[1]/PWM3                    **           digital_io[29]                 **
* PB2/SS[0]/PWM4                    **           digital_io[30]                 **
* PB3/MOSI/PWM5                     **           digital_io[31]                 **
* PB4/MISO                          **           digital_io[32]                 **
* PB5/SCK                           **           digital_io[33]                 **
* PC2/usb_dp                        **           digital_io[34]                 **
* PC3/usb_dn                        **           digital_io[35]                 **
* PC4/SDA                           **           digital_io[36]                 **
* PC5/SCL                           **           digital_io[37]                 **
*
********************************************************************************                     
********************************************************************************/


module pinmux (
               
               // Digital IO
               output logic [37:21]     digital_io_out          ,
               output logic [37:21]     digital_io_oen          ,
               input  logic [37:21]     digital_io_in           ,

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

     // ** PD0/RXD[0]       **      digital_io[21]
     port_d_in[0] = digital_io_in[21];
     if(cfg_uart_enb[0])  uart_rxd[0]   = digital_io_in[21];

     // ** PD1/TXD[0]       **      digital_io[22]
     port_d_in[1] = digital_io_in[22];

     // ** PD2/RXD[1]        **      digital_io[23]
     port_d_in[2] = digital_io_in[23];
     if(cfg_uart_enb[1])     uart_rxd[1]    = digital_io_in[23];

     // **  PD3/PWM0         **        digital_io[24]
     port_d_in[3] = digital_io_in[24];

     // **  PD4/TXD[1]          **  digital_io[25]
     port_d_in[4] = digital_io_in[25];

     //  ** PB6/XTAL/TOSC1        **       digital_io[26]
     port_b_in[6] = digital_io_in[26];
     xtal_clk     = digital_io_in[26];

     // **  PD5/SS[3]/PWM1      **       digital_io[27]
     port_d_in[5] = digital_io_in[27];

     // ** PD6/SS[2]/PWM2        **        digital_io[28]
     port_d_in[6] = digital_io_in[28];

     // **  PB1/SS[1]/PWM3           **        digital_io[29]
     port_b_in[1] = digital_io_in[29];

     // **  PB2/SS/PWM4        **        digital_io[30]
     port_b_in[2] = digital_io_in[30];

     // **  PB3/MOSI/PWM5      **        digital_io[31]
     port_b_in[3] = digital_io_in[31];
     if(cfg_spim_enb) spim_mosi = digital_io_in[31];        // SPIM MOSI (Input) = SPIS MISO (Output)

     // **  PB4/MISO          **        digital_io[32]
     port_b_in[4] = digital_io_in[32];

     // ** PB5/SCK        **      digital_io[33]
     port_b_in[5]= digital_io_in[33];
     
     // **   PC2      **   digital_io[34]/usb_dp
     usb_dp_i     = (cfg_usb_enb) ? digital_io_in[34] : 1'b1;
     port_c_in[2] = digital_io_in[34];

     // **   PC3      **   digital_io[35]/usb_dn
     usb_dn_i     = (cfg_usb_enb) ? digital_io_in[35] : 1'b1;
     port_c_in[3] = digital_io_in[35];

     // **   PC4/SDA  **  digital_io[36]
     port_c_in[4] = digital_io_in[36];
     if(cfg_i2cm_enb)  i2cm_data_i = digital_io_in[36];

     // **   PC5/SCL  **  digital_io[37]
     port_c_in[5] = digital_io_in[37];
     if(cfg_i2cm_enb)  i2cm_clk_i = digital_io_in[37];

end

// dataout selection
always_comb begin
     digital_io_out = 'h0;

     // ** PD0/RXD[0]      **      digital_io[21]
     if(cfg_port_d_dir_sel[0])    digital_io_out[21]   = port_d_out[21];

     //** PD1/TXD[0]       **      digital_io[22]
     if(cfg_uart_enb[0])              digital_io_out[22]  = uart_txd[0];
     else if(cfg_port_d_dir_sel[1])   digital_io_out[22]  = port_d_out[1];

     // ** PD2/RXD[1]       **      digital_io[23]
     if(cfg_port_d_dir_sel[2])   digital_io_out[23]   = port_d_out[2];

     // **  PD3/PWM0       **        digital_io[24]
     if(cfg_pwm_enb[0])              digital_io_out[24]   = pwm_wfm[0];
     else if(cfg_port_d_dir_sel[3])  digital_io_out[24]   = port_d_out[3];

     //** PD4/TXD[1]       **      digital_io[25]
     if   (cfg_uart_enb[1])               digital_io_out[25]   = uart_txd[1];
     else if(cfg_port_d_dir_sel[4])       digital_io_out[25]   = port_d_out[4];

     //  ** PB6/XTAL/TOSC1        **       digital_io[26]
     if(cfg_port_b_dir_sel[6])    digital_io_out[26]   = port_b_out[6];

     // **  PD5/SS[3]/PWM1      **       digital_io[27]
     if(cfg_pwm_enb[1])              digital_io_out[27]   = pwm_wfm[1];
     else if(cfg_spim_cs_enb[3])     digital_io_out[27]   = spim_ssn[3];
     else if(cfg_port_d_dir_sel[5])  digital_io_out[27]   = port_d_out[5];

     // ** PD6/SS[2]/PWM2        **        digital_io[28]
     if(cfg_pwm_enb[2])              digital_io_out[28]   = pwm_wfm[2];
     else if(cfg_spim_cs_enb[2])     digital_io_out[28]   = spim_ssn[2];
     else if(cfg_port_d_dir_sel[6])  digital_io_out[28]   = port_d_out[6];

     // **  PB1/SS[1]/PWM3           **        digital_io[29]
     if(cfg_pwm_enb[3])              digital_io_out[29]    = pwm_wfm[3];
     else if(cfg_spim_cs_enb[1])     digital_io_out[29]    = spim_ssn[1];
     else if(cfg_port_b_dir_sel[1])  digital_io_out[29]    = port_b_out[1];

     // **  PB2/SS/PWM4        **        digital_io[30]
     if(cfg_pwm_enb[4])              digital_io_out[30]  = pwm_wfm[4];
     else if(cfg_spim_cs_enb[0])     digital_io_out[30]  = spim_ssn[0];
     else if(cfg_port_b_dir_sel[2])  digital_io_out[30]  = port_b_out[2];

     // **  PB3/MOSI/PWM5      **        digital_io[31]
     if(cfg_pwm_enb[5])                digital_io_out[31]  = pwm_wfm[5];
     else if(cfg_port_b_dir_sel[3])    digital_io_out[31]  = port_b_out[3];

     // **  PB4/MISO          **        digital_io[32]
     if(cfg_spim_enb)                digital_io_out[32]  = spim_miso;   // SPIM MISO (Output) = SPIS MOSI (Input)
     else if(cfg_port_b_dir_sel[4])  digital_io_out[32]  = port_b_out[4];

     // ** PB5/SCK        **      digital_io[33]
     if(cfg_spim_enb)                digital_io_out[33]  = spim_sck;      // SPIM SCK (Output) = SPIS SCK (Input)
     else if(cfg_port_b_dir_sel[5])  digital_io_out[33]  = port_b_out[5];

     // **   PC2/USB_DP    **   digital_io[34]
     if(cfg_usb_enb)                 digital_io_out[34]  = usb_dp_o;
     else if(cfg_port_c_dir_sel[2])  digital_io_out[34]  = port_c_out[2];

     // **   PC3/USB_DN    **   digital_io[35]
     if(cfg_usb_enb)                 digital_io_out[35]  = usb_dn_o;
     if(cfg_port_c_dir_sel[3])       digital_io_out[35]  = port_c_out[3];

     // **   PC4/SDA       **   digital_io[36]
     if(cfg_i2cm_enb)                digital_io_out[36]  = i2cm_data_o;
     else if(cfg_port_c_dir_sel[4])  digital_io_out[36]  = port_c_out[4];

     // **   PC5/SCL       **   digital_io[37]
     if(cfg_i2cm_enb)                digital_io_out[37]  = i2cm_clk_o;
     else if(cfg_port_c_dir_sel[5])  digital_io_out[37]  = port_c_out[5];

end

// dataoen selection
always_comb begin
     digital_io_oen = 38'h3F_FFFF_FFFF;

     // ** PD0/RXD[0]      **      digital_io[21]
     if(cfg_uart_enb[0])             digital_io_oen[21]   = 1'b1;
     else if(cfg_port_d_dir_sel[0])  digital_io_oen[21]   = 1'b0;

     //** PD1/TXD[0]       **      digital_io[22]
     if(cfg_uart_enb[0])             digital_io_oen[22]   = 1'b0;
     else if(cfg_port_d_dir_sel[1])  digital_io_oen[22]   = 1'b0;

     // ** PD2/RXD[1]      **      digital_io[23]
     if(cfg_int_enb[0])              digital_io_oen[23]   = 1'b1;
     else if(cfg_port_d_dir_sel[2])  digital_io_oen[23]   = 1'b0;

     // **  PD3/PWM0       **        digital_io[24]
     if(cfg_pwm_enb[0])              digital_io_oen[24]   = 1'b0;
     else if(cfg_int_enb[1])         digital_io_oen[24]   = 1'b1;
     else if(cfg_port_d_dir_sel[3])  digital_io_oen[24]   = 1'b0;

     //** PD4/TXD[1]       **      digital_io[25]
     if   (cfg_uart_enb[1])          digital_io_oen[25]   = 1'b0;
     else if(cfg_port_d_dir_sel[4])  digital_io_oen[25]   = 1'b0;

     //  ** PB6/XTAL/TOSC1        **       digital_io[26]
     if(cfg_port_b_dir_sel[6])       digital_io_oen[26]   = 1'b0;

     // **  PD5/SS[3]/PWM1      **       digital_io[27]
     if(cfg_pwm_enb[1])              digital_io_oen[27]   = 1'b0;
     else if(cfg_spim_cs_enb[3])     digital_io_oen[27]   = 1'b0;
     else if(cfg_port_d_dir_sel[5])  digital_io_oen[27]   = 1'b0;

     // ** PD6/SS[2]/PWM2        **        digital_io[28]
     if(cfg_pwm_enb[2])              digital_io_oen[28]   = 1'b0;
     else if(cfg_spim_cs_enb[2])     digital_io_oen[28]   = 1'b0;
     else if(cfg_port_d_dir_sel[6])  digital_io_oen[28]   = 1'b0;

     // **  PB1/SS[1]/PWM3           **        digital_io[29]
     if(cfg_pwm_enb[3])              digital_io_oen[29]  = 1'b0;
     else if(cfg_spim_cs_enb[1])     digital_io_oen[29]  = 1'b0;
     else if(cfg_port_b_dir_sel[1])  digital_io_oen[29]  = 1'b0;

     // **  PB2/SS/PWM4        **        digital_io[30]
     if(cfg_pwm_enb[4])              digital_io_oen[30]  = 1'b0;
     else if(cfg_spim_cs_enb[0])     digital_io_oen[30]  = 1'b0;
     else if(cfg_port_b_dir_sel[2])  digital_io_oen[30]  = 1'b0;

     // **  PB3/MOSI/PWM5      **        digital_io[31]
     if(cfg_spim_enb)                digital_io_oen[31]  = 1'b1; // SPIM MOSI (Input)
     else if(cfg_pwm_enb[5])         digital_io_oen[31]  = 1'b0;
     else if(cfg_port_b_dir_sel[3])  digital_io_oen[31]  = 1'b0;

     // **  PB4/MISO          **        digital_io[32]
     if(cfg_spim_enb)                 digital_io_oen[32]  = 1'b0; // SPIM MISO (Output) 
     else if(cfg_port_b_dir_sel[4])   digital_io_oen[32]  = 1'b0;

     // ** PB5/SCK        **      digital_io[33]
     if(cfg_spim_enb)                digital_io_oen[33]  = 1'b0; // SPIM SCK (Output)
     else if(cfg_port_b_dir_sel[5])  digital_io_oen[33]  = 1'b0;

     // **   PC2/USB_DP    **   digital_io[34]
     if(cfg_usb_enb)                 digital_io_oen[34]  = usb_oen;
     else if(cfg_port_c_dir_sel[2])  digital_io_oen[34]  = 1'b0;

     // **   PC3/USB_DN    **   digital_io[35]
     if(cfg_usb_enb)                 digital_io_oen[35]  = usb_oen;
     else if(cfg_port_c_dir_sel[3])  digital_io_oen[35]  = 1'b0;

     // **   PC4/SDA       **   digital_io[36]
     if(cfg_i2cm_enb)                digital_io_oen[36]  = i2cm_data_oen;
     else if(cfg_port_c_dir_sel[4])  digital_io_oen[36]  = 1'b0;

     // **   PC5/SCL       **   digital_io[37]
     if(cfg_i2cm_enb)                digital_io_oen[37]  = i2cm_clk_oen;
     else if(cfg_port_c_dir_sel[5])  digital_io_oen[37]  = 1'b0;

end


endmodule 


