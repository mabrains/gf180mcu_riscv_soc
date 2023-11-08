// SPDX-FileCopyrightText: 2023 Mabrains Company
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
//
// SPDX-License-Identifier: Apache-2.0


// The ACMP module is a high-speed analog comparator that can be used to compare two analog input voltages. 
// The output of the comparator is a digital signal that indicates which input voltage is higher. 
// The ACMP module can be used for a variety of applications, such as Analog-to-digital conversion.


module sar_adc(
`ifdef USE_POWER_PINS
    input logic             VDD         ,
    input logic             VSS         ,
`endif

    
    input  logic            clk           ,// The clock (digital)
    input  logic            reset_n       ,// Active low reset (digital)

    // Reg Bus Interface Signal
    input logic             reg_cs        ,
    input logic             reg_wr        ,
    input logic [7:0]       reg_addr      ,
    input logic [31:0]      reg_wdata     ,
    input logic [3:0]       reg_be        ,

    // Outputs
    output logic [31:0]     reg_rdata     ,
    output logic            reg_ack       ,

    input  logic            pulse1m_mclk  ,
    output  logic [7:0]     sar2dac       ,// SAR O/P towards DAC

    input   logic           analog_dac_out, // DAC analog o/p for compare

    // ACMP (HD) Ports 
    input   logic    [5:0]  analog_din        // (Analog)

);

    logic        clkn;
    logic [5:0]  sar_cmp; // SAR compare signal
    logic        sar_cmp_int;
    logic [2:0]  adc_ch_no;
    logic        start_conv    ;// Conversion start (digital)
    logic        conv_done     ;// Conversion is done (digital)
    logic [7:0]  adc_result    ;// SAR o/p (digital)
  
always_comb 
begin
   sar_cmp_int = 0;
   case(adc_ch_no)
   3'b000 :  sar_cmp_int = sar_cmp[0];
   3'b001 :  sar_cmp_int = sar_cmp[1];
   3'b010 :  sar_cmp_int = sar_cmp[2];
   3'b011 :  sar_cmp_int = sar_cmp[3];
   3'b100 :  sar_cmp_int = sar_cmp[4];
   3'b101 :  sar_cmp_int = sar_cmp[5];
   endcase


end

adc_reg u_adc_reg (
        .mclk        (mclk),
        .reset_n     (reset_n),

        // Reg Bus Interface Signal
        .reg_cs      (reg_cs),
        .reg_wr      (reg_wr),
        .reg_addr    (reg_addr),
        .reg_wdata   (reg_wdata),
        .reg_be      (reg_be),

       // Outputs
        .reg_rdata   (reg_rdata),
        .reg_ack     (reg_ack),

	.pulse1m_mclk  (pulse1m_mclk),
       // ADC I/F
       .start_conv   (start_conv),
       .adc_ch_no    (adc_ch_no),           
       .conv_done    (conv_done),
       .adc_result   (adc_result)

       );


    ACMP COMP_0 (
    `ifdef USE_POWER_PINS
        .VDD     (VDD             ),
        .VSS     (VSS             ),
    `endif
        .clk     (clk             ),
        .INP     (analog_din[0]   ),
        .INN     (analog_dac_out  ),
        .Q       (sar_cmp[0]      )    
    );

    ACMP COMP_1 (
    `ifdef USE_POWER_PINS
        .VDD     (VDD             ),
        .VSS     (VSS             ),
    `endif
        .clk     (clk             ),
        .INP     (analog_din[1]   ),
        .INN     (analog_dac_out  ),
        .Q       (sar_cmp[1]      )    
    );

    ACMP COMP_2 (
    `ifdef USE_POWER_PINS
        .VDD     (VDD             ),
        .VSS     (VSS             ),
    `endif
        .clk     (clk             ),
        .INP     (analog_din[2]   ),
        .INN     (analog_dac_out  ),
        .Q       (sar_cmp[2]      )    
    );

    ACMP COMP_3 (
    `ifdef USE_POWER_PINS
        .VDD     (VDD             ),
        .VSS     (VSS             ),
    `endif
        .clk     (clk             ),
        .INP     (analog_din[3]   ),
        .INN     (analog_dac_out  ),
        .Q       (sar_cmp[3]      )    
    );
    ACMP COMP_4 (
    `ifdef USE_POWER_PINS
        .VDD     (VDD             ),
        .VSS     (VSS             ),
    `endif
        .clk     (clk             ),
        .INP     (analog_din[4]   ),
        .INN     (analog_dac_out  ),
        .Q       (sar_cmp[4]      )    
    );
    ACMP COMP_5 (
    `ifdef USE_POWER_PINS
        .VDD     (VDD             ),
        .VSS     (VSS             ),
    `endif
        .clk     (clk             ),
        .INP     (analog_din[5]   ),
        .INN     (analog_dac_out  ),
        .Q       (sar_cmp[5]      )    
    );

    SAR CTRL ( 
        .clk     (clk             ),   
        .reset_n (reset_n         ),  
        .start   (start_conv      ),
        .cmp     (sar_cmp_int     ),
        .out     (adc_result      ),    
        .done    (conv_done       ),
        .outn    (sar2dac         ),
        .clkn    (clkn            ) 
    );


endmodule
