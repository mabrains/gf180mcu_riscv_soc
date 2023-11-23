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
//


module analog_wrapper(
`ifdef USE_POWER_PINS
   input wire vdd, // User area 5.0V supply
   input wire vss, // User area ground
`endif

    input wire in1,
    input wire in2,
    output wire out
);

// Dummy behavirol model to verify the analog part P&R with the user_project_wrapper
assign out = in1 & in2 ;

endmodule // analog_wrapper
