// SPDX-FileCopyrightText: 2023 Harald Pretl
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//
//		http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
// SPDX-License-Identifier: Apache-2.0

/*
      -- 1 --
     |       |
     6       2
     |       |
      -- 7 --
     |       |
     5       3
     |       |
      -- 4 --
*/

`ifndef __SEG7__
`define __SEG7__

`default_nettype none

module seg7 (
	input wire [3:0] i_disp,
	output reg [6:0] o_segments
);

	always @(*) begin
		case(i_disp)
			//                7654321
			// numeric characters
			0:  o_segments = 7'b0111111; // O
			1:  o_segments = 7'b0000110;
			2:  o_segments = 7'b1011011;
			3:  o_segments = 7'b1001111;
			4:  o_segments = 7'b1100110;
			5:  o_segments = 7'b1101101;
			6:  o_segments = 7'b1111100;
			7:  o_segments = 7'b0000111;
			8:  o_segments = 7'b1111111;
			9:  o_segments = 7'b1100111;
			// special characters
			10:	o_segments = 7'b0000000; // blank
			11:	o_segments = 7'b1111111; // full
			12:	o_segments = 7'b1110110; // X
			13: o_segments = 7'b0000001; // top bar
			14: o_segments = 7'b1000000; // middle bar
			15: o_segments = 7'b0001000; // bottom bar
			default:
				o_segments = 7'b0000000;
		endcase
	end

endmodule // seg7
`endif
