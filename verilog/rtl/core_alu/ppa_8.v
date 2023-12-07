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
// ------------ LOGIC GATES ------------
// =====================================

// AND gate [2-bit]
// It will be used for Generate [p]
module and2 (
	input wire in0, in1,
	output wire out
	);
	assign out = in0 & in1;
endmodule

// OR gate [2-bit]
module or2 (
	input wire in0, in1,
	output wire out
	);
	assign out = in0 | in1;
endmodule

// XOR gate [2-bit]
module xor2 (
	input wire in0, in1,
	output wire out
	);
	assign out = in0 ^ in1;
endmodule

// XOR gate [3-bit]
module xor3 (
	input wire i0, i1, i2,
	output wire o
	);
	wire temp;
	xor2 xor2_0 (i0, i1, temp);
	xor2 xor2_1 (i2, temp, o);
endmodule

// =====================================
// ------------ SUB MODULES ------------
// =====================================

// To Get P & G for each 2-bits input
// P when either of A and B are 1
// D when both A and B are 1
module prop_gen(
	input wire x,y,
	output wire p,g
	);
	or2 o(x, y, p);
	and2 a(x, y, g);
endmodule

// Get dot operator for PPA
// (Gx:y, Px:y) ∘ (Gy+1:z, Py+1:z) = (Gx:z, Px:z)
// (Gx:y, Px:y) ∘ (Gy+1:z, Py+1:z) = (Gy+1:z + Gx:y Py+1:z, Px:y Py+1:z)
module dot(
	input wire p1,p0,g1,g0,
	output wire p, g
	);
	wire temp;
	and2 a1(p1, p0, p);
	and2 a2(p1, g0, temp);
	or2 o2(temp, g1, g);
endmodule

module dot_g(
	input wire p1,g1,g0,
	output wire g
	);
	wire temp;
	and2 a2(p1, g0, temp);
	or2 o2(temp, g1, g);
endmodule

// =====================================
// ------------ MAIN MODULE ------------
// =====================================

module ppa_8(
    input wire [6:0] a, b,
    input wire cin,
    output wire [6:0] S
    );

	// Propagate and Generate wires
	wire [5:0] p, g;
	// Carry of intermediate stages
	wire [5:0] cg;
	wire cp21, cg21;
	wire cp43, cg43;
	wire cp54, cg54;

	// All P & g are calculated at first with tgp delay
	prop_gen p_0(a[0], b[0], p[0], g[0]);
	prop_gen p_1(a[1], b[1], p[1], g[1]);
	prop_gen p_2(a[2], b[2], p[2], g[2]);
	prop_gen p_3(a[3], b[3], p[3], g[3]);
	prop_gen p_4(a[4], b[4], p[4], g[4]);
	prop_gen p_5(a[5], b[5], p[5], g[5]);
 
	// 1st stage
	dot_g d1_0(p[0], g[0], cin, cg[0]);
	dot d3_0(p[2], p[1], g[2], g[1], cp21, cg21);
	dot d5_0(p[4], p[3], g[4], g[3], cp43, cg43);

	// 2nd stage
	dot_g d2_0(p[1], g[1], cg[0], cg[1]);
	dot_g d3_1(cp21, cg21, cg[0], cg[2]);
	dot d6_0(p[5], cp43, g[5], cg43, cp54, cg54);

	// 3rd stage
	dot_g d4_0(p[3], g[3], cg[2], cg[3]);
	dot_g d5_1(cp43, cg43, cg[2], cg[4]);
	dot_g d6_1(cp54, cg54, cg[2], cg[5]);

	// Get Final S
	xor3 s0(a[0], b[0], cin,   S[0]);
	xor3 s1(a[1], b[1], cg[0], S[1]);
	xor3 s2(a[2], b[2], cg[1], S[2]);
	xor3 s3(a[3], b[3], cg[2], S[3]);
	xor3 s4(a[4], b[4], cg[3], S[4]);
	xor3 s5(a[5], b[5], cg[4], S[5]);
	xor3 s6(a[6], b[6], cg[5], S[6]);

endmodule
