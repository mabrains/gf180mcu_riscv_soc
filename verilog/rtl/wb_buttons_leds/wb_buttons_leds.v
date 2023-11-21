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

`default_nettype none

`include "../user_params.svh"

module wb_buttons_leds (
`ifdef USE_POWER_PINS
    inout VDD,	// User area 5V supply
    inout VSS,	// User area ground
`endif

    input wire          clk,
    input wire          reset,

    // wb interface
    input wire          i_wb_cyc,       // wishbone transaction
    input wire          i_wb_stb,       // strobe - data valid and accepted as long as !o_wb_stall
    input wire          i_wb_we,        // write enable
    input wire  [31:0]  i_wb_addr,      // address
    input wire  [1:0]   i_wb_data,      // incoming data
    output reg          o_wb_ack,       // request is completed 
    output wire         o_wb_stall,     // cannot accept req
    output reg  [31:0]  o_wb_data,      // output data

    // buttons
    input wire  [1:0]   buttons,
    output wire [1:0]   led_enb,        // not enable - low for active    
    output reg  [1:0]   leds
    );


    assign o_wb_stall = 0;

    assign led_enb = 2'b0; // always enabled

    initial leds = 2'b0;

    // writes
    always @(posedge clk) begin
        if(reset)
            leds <= 2'b0;
        else if(i_wb_stb && i_wb_cyc && i_wb_we && !o_wb_stall && i_wb_addr == `LED_ADDRESS) begin
            leds <= i_wb_data[1:0];
        end
    end

    // reads
    always @(posedge clk) begin
        if(reset)
            o_wb_data <= 0;
        else if(i_wb_stb && i_wb_cyc && !i_wb_we && !o_wb_stall)
            case(i_wb_addr)
                `LED_ADDRESS: 
                    o_wb_data <= {30'b0, leds};
                `BUTTON_ADDRESS: 
                    o_wb_data <= {30'b0, buttons};
                default:
                    o_wb_data <= 32'b0;
            endcase
    end

    // acks
    always @(posedge clk) begin
        if(reset)
            o_wb_ack <= 0;
        else
            // return ack immediately
            o_wb_ack <= (i_wb_stb && !o_wb_stall && (i_wb_addr == `LED_ADDRESS || i_wb_addr == `BUTTON_ADDRESS));
    end

endmodule
