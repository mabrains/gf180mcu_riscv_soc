// SPDX-FileCopyrightText: 2023 Efabless Corporation
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

`ifndef __USER_DEFINES_H
// User GPIO initial configuration parameters
`define __USER_DEFINES_H

// deliberately erroneous placeholder value; user required to config GPIO's to other
`define GPIO_MODE_INVALID                  13'hXXXX

// Authoritive source of these MODE defs is: caravel/verilog/rtl/user_defines.v
// Useful GPIO mode values.  These match the names used in defs.h.
//

`define GPIO_MODE_MGMT_STD_INPUT_NOPULL    10'h007
`define GPIO_MODE_MGMT_STD_INPUT_PULLDOWN  10'h047
`define GPIO_MODE_MGMT_STD_INPUT_PULLUP    10'h087
`define GPIO_MODE_MGMT_STD_OUTPUT          10'h00b
`define GPIO_MODE_MGMT_STD_BIDIRECTIONAL   10'h009

`define GPIO_MODE_USER_STD_INPUT_NOPULL    10'h006
`define GPIO_MODE_USER_STD_INPUT_PULLDOWN  10'h046
`define GPIO_MODE_USER_STD_INPUT_PULLUP    10'h086
`define GPIO_MODE_USER_STD_OUTPUT          10'h00a
`define GPIO_MODE_USER_STD_BIDIRECTIONAL   10'h008

// The power-on configuration for GPIO 0 to 4 is fixed and cannot be
// modified (allowing the SPI and debug to always be accessible unless
// overridden by a flash program).

// The values below can be any of the standard types defined above,
// or they can be any 13-bit value if the user wants a non-standard
// startup state for the GPIO.  By default, every GPIO from 5 to 37
// is set to power up as an input controlled by the management SoC.
// Users may want to redefine these so that the user project powers
// up in a state that can be used immediately without depending on
// the management SoC to run a startup program to configure the GPIOs.

`define USER_CONFIG_GPIO_5_INIT  `GPIO_MODE_MGMT_STD_INPUT_PULLUP   // button-0 [WB-test]
`define USER_CONFIG_GPIO_6_INIT  `GPIO_MODE_MGMT_STD_INPUT_PULLUP   // button-1 [WB-test]
`define USER_CONFIG_GPIO_7_INIT  `GPIO_MODE_USER_STD_OUTPUT         // leds-0   [WB-test]
`define USER_CONFIG_GPIO_8_INIT  `GPIO_MODE_USER_STD_OUTPUT         // leds-1   [WB-test]
`define USER_CONFIG_GPIO_9_INIT  `GPIO_MODE_USER_STD_OUTPUT         // wb_clk_i
`define USER_CONFIG_GPIO_10_INIT `GPIO_MODE_USER_STD_OUTPUT         // user_clk_2
`define USER_CONFIG_GPIO_11_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  //          [Empty  ]
`define USER_CONFIG_GPIO_12_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  //          [Empty  ]
`define USER_CONFIG_GPIO_13_INIT `GPIO_MODE_USER_STD_OUTPUT         // Display data [Temp sensor]

`define USER_CONFIG_GPIO_14_INIT `GPIO_MODE_USER_STD_OUTPUT         // Display data   [Temp sensor]
`define USER_CONFIG_GPIO_15_INIT `GPIO_MODE_USER_STD_OUTPUT         // Display data   [Temp sensor]
`define USER_CONFIG_GPIO_16_INIT `GPIO_MODE_USER_STD_OUTPUT         // Display data   [Temp sensor]
`define USER_CONFIG_GPIO_17_INIT `GPIO_MODE_USER_STD_OUTPUT         // Display data   [Temp sensor]
`define USER_CONFIG_GPIO_18_INIT `GPIO_MODE_USER_STD_OUTPUT         // Display data   [Temp sensor]
`define USER_CONFIG_GPIO_19_INIT `GPIO_MODE_USER_STD_OUTPUT         // Display data   [Temp sensor]
`define USER_CONFIG_GPIO_20_INIT `GPIO_MODE_USER_STD_OUTPUT         // Display data   [Temp sensor]
`define USER_CONFIG_GPIO_21_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PD0/RXD[0]     [Periperals ]
`define USER_CONFIG_GPIO_22_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PD1/TXD[0]     [Periperals ]
`define USER_CONFIG_GPIO_23_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PD2/RXD[1]     [Periperals ]
`define USER_CONFIG_GPIO_24_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PD3/PWM0       [Periperals ]
`define USER_CONFIG_GPIO_25_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PD4/TXD[1]     [Periperals ]
`define USER_CONFIG_GPIO_26_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PB6/XTAL       [Periperals ]
`define USER_CONFIG_GPIO_27_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PD5/SS[3]/PWM1 [Periperals ]
`define USER_CONFIG_GPIO_28_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PD6/SS[2]/PWM2 [Periperals ]
`define USER_CONFIG_GPIO_29_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PB1/SS[1]/PWM3 [Periperals ]
`define USER_CONFIG_GPIO_30_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PB2/SS[0]/PWM4 [Periperals ]
`define USER_CONFIG_GPIO_31_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PB3/MOSI/PWM5  [Periperals ]
`define USER_CONFIG_GPIO_32_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PB4/MISO       [Periperals ]
`define USER_CONFIG_GPIO_33_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PB5/SCK        [Periperals ]
`define USER_CONFIG_GPIO_34_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PC2/usb_dp     [Periperals ]
`define USER_CONFIG_GPIO_35_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PC3/usb_dn     [Periperals ]
`define USER_CONFIG_GPIO_36_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PC4/SDA        [Periperals ]
`define USER_CONFIG_GPIO_37_INIT `GPIO_MODE_USER_STD_BIDIRECTIONAL  // PC5/SCL        [Periperals ]

`endif // __USER_DEFINES_H
