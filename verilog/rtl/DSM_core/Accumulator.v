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

// Accumulator used in the Sigma-Delta Modulator
module accum(In_Data, clk, reset, Out_Data, Cout);
	
	input [6:0] In_Data;
	input clk, reset;
	output [6:0] Out_Data;
	output wire Cout;


	wire [6:0] Sum;
	reg [6:0] Temp;

	
	always @(posedge clk or negedge reset)
	begin
		if (!reset) Temp <= 7'b0000000;
		else Temp <= Sum;
	end

	assign {Cout, Sum} = In_Data + Temp;
	assign Out_Data = Temp;
endmodule
