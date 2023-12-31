
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


// ======= ctech_mux2x1_2 =======
module ctech_mux2x1_2 #(parameter WB = 1) (
	input  logic [WB-1:0] A0,
	input  logic [WB-1:0] A1,
	input  logic S ,
	output logic [WB-1:0] X);

`ifndef SYNTHESIS
    assign X = (S) ? A1 : A0;
`else 
    generate
       if (WB > 1)
       begin : bus_
         genvar tcnt;
         for (tcnt = 0; $unsigned(tcnt) < WB; tcnt=tcnt+1) begin : bit_
             gf180mcu_fd_sc_mcu7t5v0__mux2_2 u_mux (.I0 (A0[tcnt]), .I1 (A1[tcnt]), .S  (S), .Z (X[tcnt]));
         end
       end else begin 
          gf180mcu_fd_sc_mcu7t5v0__mux2_2 u_mux (.I0 (A0), .I1 (A1), .S  (S), .Z (X));
       end
    endgenerate
`endif
endmodule

// ======= ctech_mux2x1_4 =======
module ctech_mux2x1_4 #(parameter WB = 1) (
	input  logic [WB-1:0] A0,
	input  logic [WB-1:0] A1,
	input  logic S ,
	output logic [WB-1:0] X);

`ifndef SYNTHESIS
    assign X = (S) ? A1 : A0;
`else 
    generate
       if (WB > 1)
       begin : bus_
         genvar tcnt;
         for (tcnt = 0; $unsigned(tcnt) < WB; tcnt=tcnt+1) begin : bit_
             gf180mcu_fd_sc_mcu7t5v0__mux2_4 u_mux (.I0 (A0[tcnt]), .I1 (A1[tcnt]), .S  (S), .Z (X[tcnt]));
         end
       end else begin
          gf180mcu_fd_sc_mcu7t5v0__mux2_4 u_mux (.I0 (A0), .I1 (A1), .S  (S), .Z (X));
       end
    endgenerate
`endif
endmodule

// ======= ctech_clk_buf =======
module ctech_clk_buf (
	input  logic A,
	output logic X);

`ifndef SYNTHESIS
    assign X = A;
`else
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_8 u_buf  (.I(A),.Z(X));
`endif
endmodule

// ======= ctech_delay_clkbuf =======
module ctech_delay_clkbuf (
	input  logic A,
	output logic X);

wire X1,X2,X3;
`ifndef SYNTHESIS
    assign X = A;
`else
     gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 u_dly0 (.Z(X1),.I(A));
     gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 u_dly1 (.Z(X),.I(X1));
    //  gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 u_dly2 (.Z(X3),.I(X2));
    //  gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 u_dly3 (.Z(X), .I(X3));     
`endif
endmodule

// ======= ctech_buf =======
module ctech_buf (
	input  logic A,
	output logic X);

`ifndef SYNTHESIS
    assign X = A;
`else
    gf180mcu_fd_sc_mcu7t5v0__buf_8 u_buf  (.I(A),.Z(X));
`endif
endmodule

// ======= ctech_delay_buf =======
module ctech_delay_buf (
	input  logic A,
	output logic X);

`ifndef SYNTHESIS
    assign X = A;
`else
     gf180mcu_fd_sc_mcu7t5v0__dlyb_1 u_dly (.Z(X),.I(A));
`endif

endmodule

// ======= ctech_clk_gate =======
module ctech_clk_gate (
	input  logic GATE  ,
	input  logic CLK   ,
	output logic GCLK
     );

`ifndef SYNTHESIS
   logic clk_enb;

   assign #1 GCLK  = CLK & clk_enb;
   
   always_latch begin
       if(CLK == 0) begin
            clk_enb <= GATE;
       end
   end

`else
    gf180mcu_fd_sc_mcu7t5v0__icgtp_2 u_gate(
                                   .E    (GATE ),
                                   .TE   (1'h0 ),
                                   .CLK  (CLK  ), 
                                   .Q    (GCLK )
                                  );
`endif

endmodule

// Double sync High, added ctech cell to easy defining false path at sdc
module ctech_dsync_high #(parameter WB = 1) (
	input  logic [WB-1:0]  in_data,
    input  logic           out_clk,
    input  logic           out_rst_n,
	output  logic [WB-1:0] out_data
	);

reg [WB-1:0]     in_data_s  ; // One   Cycle sync 
reg [WB-1:0]     in_data_2s ; // two   Cycle sync 
reg [WB-1:0]     in_data_3s ; // three Cycle sync 

assign out_data =  in_data_3s;

always @(negedge out_rst_n or posedge out_clk)
    begin
    if(out_rst_n == 1'b0) begin
        in_data_s  <= {WB{1'b0}};
        in_data_2s <= {WB{1'b0}};
        in_data_3s <= {WB{1'b0}};
    end
    else begin
        in_data_s  <= in_data;
        in_data_2s <= in_data_s;
        in_data_3s <= in_data_2s;
    end
end

endmodule
