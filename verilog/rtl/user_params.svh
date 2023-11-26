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


`ifndef USER_PARMS
`define USER_PARMS


// ---- DEFINES ----
`define SEL_I2C   3'b001  // 0x3000_0040 --> 00110000000000000000000[001]000000
`define SEL_USB   3'b010  // 0x3000_0080 --> 00110000000000000000000[010]000000
`define SEL_SPI   3'b011  // 0x3000_00C0 --> 00110000000000000000000[011]000000
`define SEL_UART0 3'b100  // 0x3000_0100 --> 00110000000000000000000[100]000000
`define SEL_UART1 3'b111  // 0x3000_01C0 --> 00110000000000000000000[111]000000

//----------------------------------------------------------------------------
// Pinumux/Peri Reg Map - 0x3000_0600 --> 0011000000000000000000[10000]00000
//                      : 0x3000_06FF --> 0011000000000000000000[10111]11111

`define SEL_GLBL    5'b10000   // GLOBAL REGISTER
`define SEL_GPIO    5'b10001   // GPIO REGISTER
`define SEL_PWM     5'b10010   // PWM REGISTER
`define SEL_TIMER   5'b10011   // TIMER REGISTER
`define SEL_PERI    1'b1       // Peripheral
`define SEL_RTC     5'b10100   // RTC REGISTER

// ----- WB-Testing -----
`define LED_ADDRESS     32'h3000_0000   // BASE ADR
`define BUTTON_ADDRESS  32'h3000_0004   // BASE ADR + 4

// ---- Analog-TEMP-SENSOR ----
`define TEMP_SENS_ADDRESS      32'h3000_0008   // BASE ADR + 8
`define TEMP_SENS_CAL_ADDR1    32'h3000_0012   // TEMP_SENS_ADDRESS ADR + 4  // 6 reg for cal data
`define TEMP_SENS_CAL_ADDR2    32'h3000_0016   // TEMP_SENS_CAL_ADDR1   + 4  // 6 reg for cal data
`define TEMP_SENS_CAL_ADDR3    32'h3000_0020   // TEMP_SENS_CAL_ADDR2   + 4  // 6 reg for cal data
`define TEMP_SENS_CAL_ADDR4    32'h3000_0024   // TEMP_SENS_CAL_ADDR3   + 4  // 6 reg for cal data
`define TEMP_SENS_CAL_ADDR5    32'h3000_0028   // TEMP_SENS_CAL_ADDR4   + 4  // 6 reg for cal data
`define TEMP_SENS_CAL_ADDR6    32'h3000_0032   // TEMP_SENS_CAL_ADDR5   + 4  // 6 reg for cal data
`define TEMP_SENS_DBG_ADR      32'h3000_0036   // TEMP_SENS_CAL_ADDR6   + 4  // 3 bits for DBG + 1 bit for CAL ENABLE

`endif // USER_PARMS
