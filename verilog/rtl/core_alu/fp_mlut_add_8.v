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

// =====================================
// ------------ MAIN MODULE ------------
// =====================================

// out = m*a + b
module fp_mlut_add_8(
    input wire clk, reset,
    input wire [7:0] m, a, b,
    output reg [7:0] out
    );

  // intermediate reg/wire
  reg [7:0] b_in;
  wire [7:0] out_mult, out_add;

  reg [7:0] b_in_d1, b_in_d2, b_in_d3;
  reg [7:0] b_in_d4, b_in_d5, b_in_d6;
  reg [7:0] b_in_d7;

  // Adding delay for addition input
  // to be synch with mult_out
  always@(posedge clk) begin
      b_in <= b;
      b_in_d1 <= b_in;
      b_in_d2 <= b_in_d1;
      b_in_d3 <= b_in_d2;
      b_in_d4 <= b_in_d3;
      b_in_d5 <= b_in_d4;
      b_in_d6 <= b_in_d5;
      b_in_d7 <= b_in_d6;      
  end
  
  // 7 Cycles to get mult out
	fp_booth_8 mult0( 
    .clk(clk), 
    .reset(reset),
    .multiplier_in(m),
    .multiplicand_in(a),
    .product_r(out_mult)
  );

  // Addition is a pure comb
	fp_add_sub_8 add0( 
    .a(out_mult), 
    .b(b_in_d7),
    .sum(out_add)
  );

  // Out reg
  always@(posedge clk) begin
    if (reset == 1)
      out <= 0;
    else
      out <= out_add;
  end

endmodule
