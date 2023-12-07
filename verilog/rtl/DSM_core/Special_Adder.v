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

// Adder which sums 2 inputs then subtracts a third input from them
module spec_adder(Data1, Data2, Data3, Out_Data);
	input [4:0] Data1, Data2, Data3;
	output [4:0] Out_Data;

	wire [5:0] Temp;

	assign Temp = Data1 + Data2 - Data3;

	assign Out_Data = Temp[4:0];
endmodule
