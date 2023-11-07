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

`default_nettype none

module ACMP(
`ifdef USE_POWER_PINS
    input wire VDD,
    input wire VSS, 
`endif 

    input   wire clk,
    input   wire INP,
    input   wire INN,
    output  wire Q    
);

`ifdef ACMP_FUNCTIONAL

    assign Q = INP > INN ;
`else 

    wire    clkb;
    wire    net1, 
            net2,
            net3,
            net4,
            net5,
            net6,
            net7;
    
    gf180mcu_fd_sc_mcu7t5v0__inv_1 x15 (
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif 
        .I(clk), .ZN(clkb));
    gf180mcu_fd_sc_mcu7t5v0__aoi221_1 x7 (
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif 
        .A1(INP), .A2(INP), .B1(clkb), .B2(1'b1), .C(net2), .ZN(net1));     
    gf180mcu_fd_sc_mcu7t5v0__aoi221_1 x8 (
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif 
        .A1(INN), .A2(INN), .B1(clkb), .B2(1'b1), .C(net1), .ZN(net2));  
    gf180mcu_fd_sc_mcu7t5v0__inv_1 x2 (
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif 
        .I(net3), .ZN(net6));
    gf180mcu_fd_sc_mcu7t5v0__inv_1 x3 (
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif 
        .I(net4), .ZN(net5));
    gf180mcu_fd_sc_mcu7t5v0__oai221_1 x6 (
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif 
        .A1(INP), .A2(INP), .B1(clk), .B2(1'b0), .C(net4), .ZN(net3));
    gf180mcu_fd_sc_mcu7t5v0__oai221_1 x9 (
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif 
        .A1(INN), .A2(INN), .B1(clk), .B2(1'b0), .C(net3), .ZN(net4));
    gf180mcu_fd_sc_mcu7t5v0__nor3_1 x10 (
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif 
        .A1(net5), .A2(net1), .A3(net7), .ZN(Q));
    gf180mcu_fd_sc_mcu7t5v0__nor3_1 x11 (
    `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
    `endif 
        .A1(Q), .A2(net6), .A3(net2), .ZN(net7));
    
`endif

endmodule
