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

`include "../user_params.svh"

// module DSM_core(
// `ifdef USE_POWER_PINS
//     inout vdd,		// User area 5.0V supply
//     inout vss,		// User area ground
// `endif

// 	input clk, 
// 	input reset,

//     // wb interface
//     input wire          i_wb_cyc,       // wishbone transaction
//     input wire          i_wb_stb,       // strobe - data valid and accepted as long as !o_wb_stall
//     input wire          i_wb_we,        // write enable
// 	input wire  [6:0]   i_wb_data,      // incoming data
//     input wire  [31:0]  i_wb_addr,      // address
//     output reg          o_wb_ack,       // request is completed 
//     output wire         o_wb_stall,     // cannot accept req
//     output reg  [4:0]   o_wb_data       // output data
// 	);

module DSM_core(
	`ifdef USE_POWER_PINS
		inout vdd,		// User area 5.0V supply
		inout vss,		// User area ground
	`endif

	input clk, 
	input reset,

    // wb interface
    input wire          i_wb_cyc,       // wishbone transaction
    input wire          i_wb_stb,       // strobe - data valid and accepted as long as !o_wb_stall
    input wire          i_wb_we,        // write enable
	input wire  [6:0]   i_wb_data,      // incoming data
    input wire  [31:0]  i_wb_addr,      // address
    output reg          o_wb_ack,       // request is completed 
    output wire         o_wb_stall,     // cannot accept req
    output reg  [4:0]   o_wb_data       // output data

	);

	// Init for req
    assign o_wb_stall = 0;

	reg [6:0] In_Data;
	wire [4:0] Out_Data;

	wire [6:0] Sum1, Sum2, Sum3;
	wire [4:0] Cout1, Cout2, Cout3, Cout32;
	reg [4:0] DCout32, DCout3;	// Delayed Cout2 and Cout3


	// ------------------ CPU-I/F ------------------
	// reads output data & send it to CPU
    always @(posedge clk) begin
        if(reset)
            o_wb_data <= 0;
        else if(i_wb_stb && i_wb_cyc && !i_wb_we && !o_wb_stall)
            case(i_wb_addr)
                `DSM_CORE_ADDRESS: 
                    o_wb_data <= Out_Data;
                default:
                    o_wb_data <= 5'b0;
            endcase
    end

    // writes in data
    always @(posedge clk) begin
        if(reset)
            In_Data <= 7'b0;
        else if(i_wb_stb && i_wb_cyc && i_wb_we && !o_wb_stall && i_wb_addr == `DSM_CORE_ADDRESS) begin
            In_Data <= i_wb_data[6:0];
        end
    end

    // acks
    always @(posedge clk) begin
        if(reset)
            o_wb_ack <= 0;
        else
            // return ack immediately
            o_wb_ack <= (i_wb_stb && !o_wb_stall && (i_wb_addr == `DSM_CORE_ADDRESS));
    end
	// ---------------------------------------------

	// DSM CORE
	assign Cout1[4:1] = 4'b0000;
	assign Cout2[4:1] = 4'b0000;
	assign Cout3[4:1] = 4'b0000;

	accum d1 (.In_Data(In_Data), .clk(clk), .reset(reset), .Out_Data(Sum1), .Cout(Cout1[0]));
	accum d2 (.In_Data(Sum1), .clk(clk), .reset(reset), .Out_Data(Sum2), .Cout(Cout2[0]));
	accum d3 (.In_Data(Sum2), .clk(clk), .reset(reset), .Out_Data(Sum3), .Cout(Cout3[0]));

	always @(posedge clk or negedge reset)
	begin
		if (!reset) DCout3 <= 5'b00000;
		else DCout3 <= Cout3;
	end

	spec_adder u4 (.Data1(Cout2), .Data2(Cout3), .Data3(DCout3), .Out_Data(Cout32));
	
	always @(posedge clk or negedge reset)
	begin
		if (!reset) DCout32 <= 5'b00000;
		else DCout32 <= Cout32;
	end

	spec_adder u5 (.Data1(Cout1), .Data2(Cout32), .Data3(DCout32), .Out_Data(Out_Data));

endmodule
