//////////////////////////////////////////////////////////////////////////////
// SPDX-FileCopyrightText: 2021 , Dinesh Annayya                          
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
// SPDX-FileContributor: Created by Dinesh Annayya <dinesha@opencores.org>
//

/*************************************************************
  This block added to block abort changing of config during PWM config.
  pwm config will be update only in following condition
  1. When pwm is in disable condition
  2. When disable_update = 0 and cfg_update = 1
*************************************************************/


module pwm_cfg_dglitch  (
                       // System Signals
                       // Inputs
		               input  logic        mclk           ,
                       input  logic        h_reset_n      ,
                       input  logic        enb            , // Operation Enable 
                       input  logic        cfg_update     , // Update config
                       input  logic        cfg_dupdate    , // Disable config update
                       input  logic [31:0] reg_in         ,
                       output logic [31:0] reg_out            

                       );



always @(posedge mclk or negedge h_reset_n) begin 
   if ( ~h_reset_n ) begin
        reg_out <= 'h0;
   end else begin
       if(!cfg_dupdate) begin
          if(!enb || cfg_update) begin
             reg_out <= reg_in;
          end
       end 
   end
end

endmodule
