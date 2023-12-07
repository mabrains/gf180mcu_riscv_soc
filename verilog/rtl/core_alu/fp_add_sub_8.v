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

// 8-bit add/sub using PPA
// sub is done using 2's complement
module fp_add_sub_8(
    input wire [7:0] a, b,
    output wire [7:0] sum
   );

  reg [6:0] mag_a, mag_b, max, min, a_in, b_in; // intermediate values
  reg sign_a, sign_b, sign, c_in;               // intermediate signs
	wire [6:0] s_out;

  // PPA-8
	ppa_8 ppa_u0(
	.a(a_in), 
	.b(b_in),
	.cin(c_in),
	.S(s_out)
	);

  always @* begin
    mag_a = a[6:0] ;  // storing the magnitude in mag_a
    mag_b = b[6:0] ;  // storing the magnitude in mag_b
    sign_a = a[7] ;   // extracting the sign
    sign_b = b[7] ;   // extracting the sign
  // Get max value
    if(mag_a > mag_b) begin
      max = mag_a;
      min = mag_b;
      sign = sign_a;
    end
    else begin
      max = mag_b;
      min = mag_a;
      sign = sign_b;
    end
    // logic for addition using check on signs of numbers
    if(sign_a == sign_b) begin 
      // if both have same signs
      // sum is addition of a and b
      a_in = max;
      b_in = min;
      c_in = 1'b0;
    end
    else begin 
      // if they have different sign
      // sum is subtraction of a and b
      // subtraction is done using 2's complement
      // min_comp is 1's complement of min
      a_in = max;
      b_in = ~min;
      c_in = 1'b1;
    end
  end

	assign sum = {sign, s_out};

endmodule
