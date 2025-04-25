`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 19:17:43
// Design Name: 
// Module Name: fetch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fetch(clk, reset,PCSrcE, StallF,StallD, FlushD, InstrF, PCF,PCTargetE,
 InstrD, PCPlus4D, PCD);
input clk, reset,PCSrcE, StallF, StallD, FlushD;
input [31:0] InstrF;
output [31:0] PCF, PCTargetE,InstrD,PCPlus4D, PCD;
wire [31:0] PCPlus4F, PCNextF;
mux2 #(32) m1(PCPlus4F, PCTargetE, PCSrcE, PCNextF);
flopenr #(32) pcflop(clk, reset, ~StallF, PCNextF, PCF);
adder pcadd(PCF, 32'h4, PCPlus4F);
Fetch_reg fetch_reg(clk, reset, FlushD, StallD,
InstrF, PCF, PCPlus4F, InstrD, PCD, PCPlus4D);
endmodule
