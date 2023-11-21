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

//	This cell implements a voltage-mode DAC using the gf180mcu_fd_sc_mcu7t5v0__invz_1 cell.
//	Due to the special structure of this tri-state inverter this construction
//	is possible.
//
//  IMPORTANT: Make sure that the synthesis and optimization tools do not mess
//	with the resulting netlist, especially at the node `vout_notouch_`!

`ifndef __VDAC_CELL__
`define __VDAC_CELL__

`default_nettype none

module vdac_cell #(parameter PARALLEL_CELLS = 4) (
	input wire	i_sign,
	input wire	i_data,
	input wire	i_enable,
	output wire	vout_notouch_
);

	wire en_vref, en_pupd, npu_pd;

	// Control logic
	assign npu_pd  = ~i_data;
	assign en_pupd = i_enable & (~(i_sign^i_data));
	assign en_vref = i_enable & (i_sign^i_data);

	genvar i;
	generate
		for (i=0; i < PARALLEL_CELLS; i=i+1) begin : einvp_batch
			(* keep = "true" *) gf180mcu_fd_sc_mcu7t5v0__invz_1 pupd (.I(npu_pd), .EN(en_pupd), .ZN(vout_notouch_));
			(* keep = "true" *) gf180mcu_fd_sc_mcu7t5v0__invz_1 vref (.I(vout_notouch_), .EN(en_vref), .ZN(vout_notouch_));
		end
  	endgenerate

endmodule // vdac_cell
`endif
