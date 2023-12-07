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
// ------------ SUB MODULES ------------
// =====================================

// 8-bit add/sub using PPA
// sub is done using 2's complement
module add_sub_8(
    input wire cin,
    input wire [6:0] i0,i1,
    output wire [6:0] sum
  );

	wire [6:0] int_ip; //intermediate input
	
	//if cin == 1, int_ip = 1's complement
	//else int_ip = i1
  xor2 x0 (i1[0], cin, int_ip[0]);
  xor2 x1 (i1[1], cin, int_ip[1]);
  xor2 x2 (i1[2], cin, int_ip[2]);
  xor2 x3 (i1[3], cin, int_ip[3]);
  xor2 x4 (i1[4], cin, int_ip[4]);
  xor2 x5 (i1[5], cin, int_ip[5]);
  xor2 x6 (i1[6], cin, int_ip[6]);

  //if cin == 1, cin added to make two's complement
  //else addition takes place
  ppa_8 ppa8_u0(
    .a(i0), 
    .b(int_ip),
    .cin(cin),
    .S(sum)
    );
endmodule

module booth_substep(
  input wire [6:0] acc,    // Current value of accumulator
  input wire [6:0] Q,      // Current value of Q (initially the multiplier)    
  input wire q0,           // Current value of q-1 th bit
  input wire [6:0] multiplicand,
  output reg [6:0] next_acc,   // Next accumulator value || value of 8 MSB's of 16 bit output [17:8]
  output reg [6:0] next_Q,     // Next value of Q || value of 8 LSB's of 16 bit output [7:0]
  output reg q0_next
  );

wire [6:0] addsub_temp;  //next value of q_-1 th bit

add_sub_8 add_sub4_u0(
  Q[0], 
  acc, 
  multiplicand, 
  addsub_temp
  );

always @(*) begin
  q0_next = Q[0];
  next_Q = Q >> 1;    

  if(Q[0] == q0) begin
    next_Q[6] = acc[0];
    next_acc = acc >> 1; // ARS
    if (acc[6] == 1)     // sign extension
      next_acc[6] = 1;
  end
  else begin
    next_Q[6] = addsub_temp[0];
    next_acc = addsub_temp >> 1 ; // ARS
    if (addsub_temp[6] == 1)      // sign extension
      next_acc[6] = 1;
  end
end
endmodule

// =====================================
// ------------ MAIN MODULE ------------
// =====================================

// 1-bit for sign, 4 bit for exponent, 3-bit for mantissa
module fp_booth_8(
    input wire clk, reset,
    input wire [7:0] multiplier_in, multiplicand_in,
    output reg [7:0] product_r
    );

  // sign-bit
  wire mul_sign;
  reg mul_sign_s1, mul_sign_s2, mul_sign_s3;
  reg mul_sign_s4, mul_sign_s5, mul_sign_s6;
  // Final sign = sign (M) ^ sign (Q)
  // Same sign --> + [0]
  // Diff sign --> - [1]
  xor2 x_sign(
    multiplier_in[7], 
    multiplicand_in[7], 
    mul_sign
    );

  // synch sign with final output
  always@(posedge clk) begin
      mul_sign_s1 <= mul_sign;
      mul_sign_s2 <= mul_sign_s1;
      mul_sign_s3 <= mul_sign_s2;
      mul_sign_s4 <= mul_sign_s3;
      mul_sign_s5 <= mul_sign_s4;
      mul_sign_s6 <= mul_sign_s5;
  end

  // product of exponents (integer part) [4-bit]
  wire [6:0] product;
  wire [6:0] unused_product;
	wire [6:0] Q[0:5];         // an 7 bit array, with a depth of 5
	wire [6:0] acc[0:6];       // an 7 bit array, with a depth of 6
	wire [6:0] q0;             // Holds q_-1 bits
	wire unused_qout;
  reg [6:0] multiplier, multiplicand;

  // inital values for acc and q_-1
  assign q0[0] = 1'b0;
  assign acc[0] = 7'b0000000;

  always@(posedge clk) begin
    multiplier <= multiplier_in[6:0];
    multiplicand <= multiplicand_in[6:0];
  end

  // intermediate reg/wires for pipeline
  reg [6:0] acc_s1, Q_s1;
  reg [6:0] acc_s2, Q_s2;
  reg [6:0] acc_s3, Q_s3;
  reg [6:0] acc_s4, Q_s4;
  reg [6:0] acc_s5, Q_s5;
  reg [6:0] acc_s6, Q_s6;

  reg q0_s1, q0_s2;
  reg q0_s3, q0_s4;
  reg q0_s5, q0_s6;
  
  reg [6:0] multiplicand_s1, multiplicand_s2;
  reg [6:0] multiplicand_s3, multiplicand_s4;
  reg [6:0] multiplicand_s5, multiplicand_s6;

  // pipeline 
  always@(posedge clk) begin
    acc_s1 <= acc[1];
    acc_s2 <= acc[2];
    acc_s3 <= acc[3];
    acc_s4 <= acc[4];
    acc_s5 <= acc[5];
    acc_s6 <= acc[6];

    Q_s1 <= Q[0];
    Q_s2 <= Q[1];
    Q_s3 <= Q[2];
    Q_s4 <= Q[3];
    Q_s5 <= Q[4];
    Q_s6 <= Q[5];

    q0_s1 <= q0[1];
    q0_s2 <= q0[2];
    q0_s3 <= q0[3];
    q0_s4 <= q0[4];
    q0_s5 <= q0[5];
    q0_s6 <= q0[6];

    multiplicand_s1 <= multiplicand;
    multiplicand_s2 <= multiplicand_s1;
    multiplicand_s3 <= multiplicand_s2;
    multiplicand_s4 <= multiplicand_s3;
    multiplicand_s5 <= multiplicand_s4;
    multiplicand_s6 <= multiplicand_s5;
  end

  // ==== 1st step ====
	booth_substep step1( 
    acc[0],
    multiplier, 
    q0[0],
    multiplicand, 
    acc[1],        
    Q[0],         
    q0[1]
    );

  // ==== 2nd step ====
	booth_substep step2( 
    acc_s1, 
    Q_s1, 
    q0_s1, 
    multiplicand_s1, 
    acc[2],        
    Q[1],         
    q0[2]
    );

  // ==== 3rd step ====
	booth_substep step3( 
    acc_s2, 
    Q_s2, 
    q0_s2, 
    multiplicand_s2, 
    acc[3],        
    Q[2],         
    q0[3]
    );

  // ==== 4th step ====
	booth_substep step4( 
    acc_s3, 
    Q_s3, 
    q0_s3, 
    multiplicand_s3,
    acc[4],
    Q[3],         
    q0[4]
    );

  // ==== 5th step ====
	booth_substep step5( 
    acc_s4, 
    Q_s4,
    q0_s4, 
    multiplicand_s4,
    acc[5],
    Q[4],         
    q0[5]
    );

  // ==== 6th step ====
	booth_substep step6( 
    acc_s5,
    Q_s5,
    q0_s5, 
    multiplicand_s5,
    acc[6],
    Q[5],         
    q0[6]
    );    

  // ==== 7th step ====
	booth_substep step7( 
    acc_s6, 
    Q_s6,
    q0_s6, 
    multiplicand_s6,
    unused_product,        
    product,         
    unused_qout
    );

  always@(posedge clk) begin
    if (reset == 1)
      product_r <= 0;
    else
      product_r <= {mul_sign_s6, unused_product[2:0], product[6:3]};
  end

endmodule
