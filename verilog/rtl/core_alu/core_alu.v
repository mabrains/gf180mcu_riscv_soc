// ************************************************************************
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
// ************************************************************************

`include "../user_params.svh"

module core_alu(
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
	input wire    [25:0]  i_wb_data,      // incoming data
    input wire  [31:0]  i_wb_addr,      // address
    output reg          o_wb_ack,       // request is completed 
    output wire         o_wb_stall,     // cannot accept req
    output reg  [7:0]   o_wb_data       // output data
	);

	// Init for req
  assign o_wb_stall = 0;

  // Main IOs
  reg [7:0] a, b, m;
  reg [1:0] sel;
  reg [7:0] out;


	// ------------------ CPU-I/F ------------------
	// reads output data & send it to CPU
    always @(posedge clk) begin
        if(reset)
            o_wb_data <= 0;
        else if(i_wb_stb && i_wb_cyc && !i_wb_we && !o_wb_stall)
            case(i_wb_addr)
                `CORE_ALU_ADDRESS: 
                    o_wb_data <= out;
                default:
                    o_wb_data <= 8'b0;
            endcase
    end

    // writes in data
    always @(posedge clk) begin
        if(reset) begin
            a <= 8'b0;
            b <= 8'b0;
            m <= 8'b0;
          end
        else if(i_wb_stb && i_wb_cyc && i_wb_we && !o_wb_stall && i_wb_addr == `CORE_ALU_ADDRESS) begin
            a <= i_wb_data[7:0];
            b <= i_wb_data[15:8];
            m <= i_wb_data[23:16];
            sel <= i_wb_data[25:24];
        end
    end

    // acks
    always @(posedge clk) begin
        if(reset)
            o_wb_ack <= 0;
        else
            // return ack immediately
            o_wb_ack <= (i_wb_stb && !o_wb_stall && (i_wb_addr == `CORE_ALU_ADDRESS));
    end
	// ---------------------------------------------


  // intermediate reg/wire
  wire [7:0] add_out, mult_out, mult_add_out;

  // Adding delay for addition & mult out
  // to be synch with mult_out & mult_add_out
  reg [7:0] add_out_d0, add_out_d1, add_out_d2;
  reg [7:0] add_out_d3, add_out_d4, add_out_d5;
  reg [7:0] add_out_d6, add_out_d7;

  reg [7:0] mul_out_d0;

  always@(posedge clk) begin
      add_out_d0 <= add_out;
      add_out_d1 <= add_out_d0;
      add_out_d2 <= add_out_d1;
      add_out_d3 <= add_out_d2;
      add_out_d4 <= add_out_d3;
      add_out_d5 <= add_out_d4;
      add_out_d6 <= add_out_d5;
      add_out_d7 <= add_out_d6;      

      mul_out_d0 <= mult_out;      
  end

  // Addition
  // Addition is a pure comb
	fp_add_sub_8 add_u0( 
    .a(a), 
    .b(b),
    .sum(add_out)
  );

  // Multiplication
  // 7 Cycles to get mult out
	fp_booth_8 mult_u0( 
    .clk(clk), 
    .reset(reset),
    .multiplier_in(a),
    .multiplicand_in(b),
    .product_r(mult_out)
  );

  // mult_add [m*a + b]
  // 7 Cycles to get mult_add out
	fp_mlut_add_8 mult_add_u0( 
    .clk(clk), 
    .reset(reset),
    .m(m),
    .a(a),
    .b(b),
    .out(mult_add_out)
  );


  // Adding delay for sel input
  reg [1:0] sel_d0, sel_d1, sel_d2;
  reg [1:0] sel_d3, sel_d4, sel_d5;
  reg [1:0] sel_d6, sel_d7, sel_d8;
  
  always@(posedge clk) begin
      sel_d0 <= sel;
      sel_d1 <= sel_d0;
      sel_d2 <= sel_d1;
      sel_d3 <= sel_d2;
      sel_d4 <= sel_d3;
      sel_d5 <= sel_d4;
      sel_d6 <= sel_d5;
      sel_d7 <= sel_d6;      
      sel_d8 <= sel_d7;      
  end

  // Select the desired operation
  always @(posedge clk) begin
    if (reset) begin
      out <= 0;
    end
    else begin
      case (sel_d8)
        2'b00: out <= add_out_d7;
        2'b01: out <= mul_out_d0;
        2'b10: out <= mult_add_out;
        default: out <= out;
      endcase
    end
  end
endmodule
