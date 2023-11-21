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

`include "tempsense.v"
`include "seg7.v"
`include "bin2dec.v"
`include "../user_params.svh"

module temp_sensor (
`ifdef USE_POWER_PINS
    inout VDD,		// User area 5.0V supply
    inout VSS,		// User area ground
`endif

	input           clk,
	input           reset,
	input  [5:0]	io_in,
	output [7:0]	io_out,
	output [7:0]	io_oeb,

    // wb interface
    input wire          i_wb_cyc,       // wishbone transaction
    input wire          i_wb_stb,       // strobe - data valid and accepted as long as !o_wb_stall
    input wire          i_wb_we,        // write enable
    input wire  [31:0]  i_wb_addr,      // address
    output reg          o_wb_ack,       // request is completed 
    output wire         o_wb_stall,     // cannot accept req
    output reg  [7:0]   o_wb_data       // output data
    );

	// Init for req
    assign o_wb_stall = 0;

    assign io_oeb = 8'b0; // always enabled

	// size the design with these constants
	localparam N_VDAC = 6;
	localparam N_LUT = 6;
	localparam N_CTR = 14; // 2**N_CTR gives roughly a second tick @ clk=10kHz

	// pre-loaded LUT based on nominal simulation results; only even values div:2
	// stored, otherwise does not fit the TinyTapeout area
	localparam [(2**(N_VDAC-1))*N_LUT:1] LUT_PRELOAD = {
		// output	// input
		6'd00,		// 31
		6'd00,		// 30
		6'd00,		// 29
		6'd00,		// 28
		6'd00,		// 27
		6'd00,		// 26
		6'd00,		// 25
		6'd00,		// 24
		6'd05,		// 23
		6'd10,		// 22
		6'd15,		// 21
		6'd19,		// 20
		6'd23,		// 19
		6'd27,		// 18
		6'd30,		// 17
		6'd34,		// 16
		6'd38,		// 15
		6'd42,		// 14
		6'd45,		// 13
		6'd47,		// 12
		6'd49,		// 11
		6'd49,		// 10
		6'd49,		// 09
		6'd49,		// 08
		6'd49,		// 07
		6'd49,		// 06
		6'd49,		// 05
		6'd49,		// 04
		6'd49,		// 03
		6'd49,		// 02
		6'd49,		// 01
		6'd49		// 00
	};

	// definition of external inputs
	wire cal_clk = io_in[0];
	wire cal_dat = io_in[1];
	wire cal_ena = io_in[2];
	wire [2:0] en_dbg = io_in[5:3];


	// definition of external outputs
	wire [7:0] led_out;
	wire [6:0] led_segments;
	wire led_dot = show_ones;
	assign io_out[7:0] = led_out; 


	// definition of internal wires and regs
	reg [N_CTR-1:0] ctr;
	reg [N_VDAC-1:0] tempsens_res_raw;
	wire [N_VDAC:0] tempsens_res;
	reg temp_delay_last;
	reg [(2**(N_VDAC-1))*N_LUT:1] cal_lut;

	wire [1:0] meas_state = ctr[1:0];
	wire [N_VDAC-1:0] dac_value = {N_VDAC{1'b1}} - ctr[N_VDAC+1:2];
	wire idle_cycle = |ctr[N_CTR-1:N_VDAC+2];
	wire show_tens = ~ctr[N_CTR-1];
	wire show_ones = ctr[N_CTR-1];

	wire in_reset, in_precharge, in_transition, in_transition_ph0, in_transition_ph1, in_measurement, in_evaluation;

    wire tempsens_en, temp_delay, tempsens_measure;
	wire [N_VDAC-1:0] tempsens_dat;
	wire [3:0] digit;

	// debug vectors
	wire [7:0] dbg1 = {temp_delay, in_reset, in_precharge, in_transition, in_transition_ph0, in_transition_ph1, in_measurement, in_evaluation};
	wire [7:0] dbg2 = {tempsens_en, tempsens_measure, tempsens_dat}; 
	wire [7:0] dbg3 = {meas_state, tempsens_res_raw};
	wire [7:0] dbg4 = {ctr[7:0]};
	wire [7:0] dbg5 = {show_ones, show_tens, ctr[N_CTR-1:8]};
	wire [7:0] dbg6 = {1'b0, idle_cycle, dac_value};
	wire [7:0] dbg7 = {cal_ena, tempsens_res};


	// measurement state machine (meas_state)
	localparam PRECHARGE	= 2'b00;
	localparam TRANSITION	= 2'b01;
	localparam MEASURE		= 2'b10;
	localparam EVALUATE		= 2'b11;


	// VDAC max and min value
	localparam VMAX = {N_VDAC{1'b1}};
	localparam VMIN = {N_VDAC{1'b0}};


	// create state signals based on state of state machine
	assign in_reset = (ctr == {N_CTR{1'b1}});
	assign in_precharge = (meas_state == PRECHARGE)				&& !in_reset && !idle_cycle;
	assign in_transition = (meas_state == TRANSITION) 			&& !in_reset && !idle_cycle;
	assign in_transition_ph0 = in_transition && (clk == 1'b1) 	&& !in_reset && !idle_cycle;
	assign in_transition_ph1 = in_transition && (clk == 1'b0) 	&& !in_reset && !idle_cycle;
	assign in_measurement = (meas_state == MEASURE) 			&& !in_reset && !idle_cycle;
	assign in_evaluation = (meas_state == EVALUATE) 			&& !in_reset && !idle_cycle;


	// create temperature sensor input signal based on state signals, gate output to
	assign tempsens_en = in_reset ? 1'b0 : 1'b1;
	assign tempsens_dat =		in_precharge		? VMAX :
								in_transition_ph0	? VMIN :
								in_transition_ph1	? VMIN :
								in_measurement		? dac_value :
								in_evaluation		? dac_value :
								VMAX;
	assign tempsens_measure = 	in_precharge		? 1'b0 :
								in_transition_ph0	? 1'b0 :
								in_transition_ph1	? 1'b1 :
								in_measurement 		? 1'b1 :
								in_evaluation		? 1'b1 :
								1'b0;


	// display decimal number (tens or ones) on number LED or debug signals
	assign led_out = 	(en_dbg == 3'd0) ? {led_dot, led_segments} :
						(en_dbg == 3'd1) ? dbg1 :
						(en_dbg == 3'd2) ? dbg2 :
						(en_dbg == 3'd3) ? dbg3 :
						(en_dbg == 3'd4) ? dbg4 :
						(en_dbg == 3'd5) ? dbg5 :
						(en_dbg == 3'd6) ? dbg6 :
						(en_dbg == 3'd7) ? dbg7 :
						{led_dot, led_segments};
	

	// state machine implementation for temperature sensor control
    always @(posedge clk) begin
        if (reset) begin
			ctr <= {N_CTR{1'b1}};
			tempsens_res_raw <= {N_VDAC{1'b0}};
			temp_delay_last <= 1'b1;
		end else begin
			ctr <= ctr + 1'b1;

			if (in_evaluation) begin
				if ((temp_delay_last == 1'b0) && (temp_delay == 1'b1)) begin
					tempsens_res_raw <= dac_value;
				end

				temp_delay_last <= temp_delay;
			end
		end
	end


	// loading of calibration LUT
	always @(posedge cal_clk) begin
		if (reset) begin
			cal_lut <= LUT_PRELOAD;
		end else begin
			cal_lut <= {cal_lut[((2**(N_VDAC-1))*N_LUT)-1:1], cal_dat};
		end
	end

	// ------------------ CPU-I/F ------------------
	// reads output data & send it to CPU
    always @(posedge clk) begin
        if(reset)
            o_wb_data <= 0;
        else if(i_wb_stb && i_wb_cyc && !i_wb_we && !o_wb_stall)
            case(i_wb_addr)
                `TEMP_SENS_ADDRESS: 
                    o_wb_data <= led_out;
                default:
                    o_wb_data <= 8'b0;
            endcase
    end

    // acks
    always @(posedge clk) begin
        if(reset)
            o_wb_ack <= 0;
        else
            // return ack immediately
            o_wb_ack <= (i_wb_stb && !o_wb_stall && (i_wb_addr == `TEMP_SENS_ADDRESS));
    end
	// ---------------------------------------------

	// assign wire array to LUT implemented a shift register (for easy load)
	wire [N_LUT-1:0] cal_lut_entries[0:(2**(N_VDAC-1))-1];
	genvar i;
	generate
		for (i=0; i < 2**(N_VDAC-1); i=i+1) begin : lut_assign
			assign cal_lut_entries[i] = cal_lut[(N_LUT*(i+1)) -: N_LUT];
		end
	endgenerate

	// apply calibration LUT when enabled
	assign tempsens_res = cal_ena ? {cal_lut_entries[tempsens_res_raw[N_VDAC-2:0]], 1'b0} : {1'b0, tempsens_res_raw};


    // instantiate temperature-dependent delay (this is the core circuit)
    tempsense #(.DAC_RESOLUTION(N_VDAC), .CAP_LOAD(16)) temp1 (
        .i_dac_data(tempsens_dat),
        .i_dac_en(tempsens_en),
        .i_precharge_n(tempsens_measure),
        .o_tempdelay(temp_delay)
    );


	// binary to decimal decoder to show measurement result on 7-segment LED
	bin2dec dec1 (
		.i_bin(tempsens_res),
		.i_tens(show_tens),
		.i_ones(show_ones),
		.o_dec(digit)
	);


    // instantiate segment display decoder
    seg7 seg1 (
        .i_disp(digit),
        .o_segments(led_segments)
    );

endmodule // temp_sensor
