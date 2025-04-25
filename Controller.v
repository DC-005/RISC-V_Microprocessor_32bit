`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 19:44:12
// Design Name: 
// Module Name: Controller
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


module Controller(clk, reset, FlushE,ZeroE, InstrD, ImmSrcD, ALUSrcE,
PCSrcE, ResultSrcE, ALUControlE,MemWriteM,RegWriteM, RegWriteW, ResultSrcW);
input clk, reset, FlushE, ZeroE;
input [31:0] InstrD;
output MemWriteM, ALUSrcE, PCSrcE, RegWriteM, RegWriteW;
output [1:0] ImmSrcD, ResultSrcE, ResultSrcW;
output [2:0] ALUControlE;
wire RegWriteE, MemWriteE, JumpE, BranchE;
wire [1:0]ResultSrcM;
control_d control1(clk, reset,FlushE, InstrD[6:0], InstrD[14:12],
InstrD[30],RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, 
ALUControlE, ALUSrcE,ImmSrcD);

control_e control2(clk, reset, RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, RegWriteM,
     ResultSrcM, MemWriteM, ZeroE, PCSrcE );

control_m control3(clk, reset, RegWriteM, ResultSrcM, RegWriteW, 
ResultSrcW);
endmodule
