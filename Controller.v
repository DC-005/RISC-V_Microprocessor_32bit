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


module Controller(clk, reset, FlushE,branch_taken, InstrD, ImmSrcD, ALUSrcE,
PCSrcE, ResultSrcE, ALUControlE,MemWriteM,RegWriteM, RegWriteW, ResultSrcW, functE, functM);
input clk, reset, FlushE, branch_taken;
input [31:0] InstrD;
output MemWriteM, ALUSrcE, PCSrcE, RegWriteM, RegWriteW;
output [1:0] ImmSrcD, ResultSrcE, ResultSrcW;
output [2:0] ALUControlE, functE, functM;
wire RegWriteE, MemWriteE, JumpE, BranchE;
wire [1:0]ResultSrcM;

control_d control1(clk, reset,FlushE, InstrD[6:0], InstrD[14:12],
InstrD[30],RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, 
ALUControlE, ALUSrcE,ImmSrcD, functE);

control_e control2(clk, reset, RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, RegWriteM,
     ResultSrcM, MemWriteM, branch_taken, PCSrcE,functE, functM );

control_m control3(clk, reset, RegWriteM, ResultSrcM, RegWriteW, 
ResultSrcW);
endmodule

