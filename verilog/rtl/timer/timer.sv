// SPDX-FileCopyrightText: 2023 Mabrains Company
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

module timer
  (
     input logic	     reset_n,	// system syn reset
     input logic	     mclk,		// master clock
     input logic 	     pulse_1us,
     input logic 	     pulse_1ms,
     input logic 	     pulse_1s,

     input logic             cfg_timer_enb,     
     input logic             cfg_timer_update, 
     input logic [15:0]      cfg_timer_compare,
     input logic [1:0]       cfg_timer_clksel,	// to select the timer 1us/1ms reference clock

     output logic  	     timer_intr

   );

reg 		timer_hit_s1;
wire 		timer_hit;
reg [15:0]      timer_counter;
wire		timer_pulse;

// select between 1us timer and 1ms timer
assign timer_pulse = (cfg_timer_clksel == 2'b00) ? pulse_1us : 
	             (cfg_timer_clksel == 2'b01) ? pulse_1ms : pulse_1s;
  

/************************************************
	Timer Counter
************************************************/
always @(negedge reset_n or posedge mclk)
begin
   if (!reset_n)
	timer_counter <= 16'b0;
   else if (cfg_timer_update || (timer_pulse && timer_hit))
	timer_counter <=  cfg_timer_compare;
   else if (timer_pulse && cfg_timer_enb)
	timer_counter <=  timer_counter - 1;
end


   
/***********************************************
	Timer Interrupt Generation
***********************************************/
   assign timer_hit = (timer_counter == 1'b0);

   assign timer_intr = !timer_hit_s1 && timer_hit && cfg_timer_enb;

   
   always @(negedge reset_n or posedge mclk)
     begin
	if (!reset_n) begin
	   timer_hit_s1 <= 1'b1;
        end else begin
	   timer_hit_s1 <= timer_hit;
	end
     end

   
endmodule
