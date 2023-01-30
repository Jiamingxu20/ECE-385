`include "SLC3_2.sv"
import SLC3_2::*;


module  top ( 	input logic Clk, Reset,
					input logic [15:0]  ADDR, 
					input logic OE, WE,
					input logic [9:0]  Switches,
					input logic [15:0] Data_from_CPU, Data_from_SRAM,
					output logic [15:0] Data_to_CPU, Data_to_SRAM,
					output logic [3:0]  HEX0, HEX1, HEX2, HEX3 );
					
					

module  Mem2IO ( 	input logic Clk, Reset,
					input logic [15:0]  ADDR, 
					input logic OE, WE,
					input logic [9:0]  Switches,
					input logic [15:0] Data_from_CPU, Data_from_SRAM,
					output logic [15:0] Data_to_CPU, Data_to_SRAM,
					output logic [3:0]  HEX0, HEX1, HEX2, HEX3 );
					

module slc3(
	input logic [9:0] SW,
	input logic	Clk, Reset, Run, Continue,
	input logic [15:0] Data_from_SRAM,
	output logic OE, WE,
	output logic [9:0] LED,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3,
	output logic [15:0] ADDR,
	output logic [15:0] Data_to_SRAM
);




HexDriver HexDriver_0 (.In0(), .Out0());


module HexDriver (	input				[3:0] In0,
							output logic	[6:0] Out0);
							
		// This module has hardcoded values that convert 4bit binary numbers from registers into hexadecimal
		always_comb
		begin
				unique case(In0)
						4'b0000	:	Out0 = 7'b1000000; // '0'
						4'b0001	:	Out0 = 7'b1111001; // '1'
						4'b0010	:	Out0 = 7'b0100100; // '2'
						4'b0011	:	Out0 = 7'b0110000; // '3'
						4'b0100	:	Out0 = 7'b0011001; // '4'
						4'b0101	:	Out0 = 7'b0010010; // '5'
						4'b0110	:	Out0 = 7'b0000010; // '6'
						4'b0111	:	Out0 = 7'b1111000; // '7'
						4'b1000	:	Out0 = 7'b0000000; // '8'
						4'b1001	:	Out0 = 7'b0010000; // '9'
						4'b1010	:	Out0 = 7'b0001000; // 'A'
						4'b1011	:	Out0 = 7'b0000011; // 'B'
						4'b1100	:	Out0 = 7'b1000110; // 'C'
						4'b1101	:	Out0 = 7'b0100001; // 'D'
						4'b1110	:	Out0 = 7'b0000110; // 'E'
						4'b1111	:	Out0 = 7'b0001110; // 'F'
						default	:	Out0 = 7'bX;
				endcase
		end
endmodule