`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2025 23:12:09
// Design Name: 
// Module Name: control_d
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


module control_d(clk, reset,clr, op,funct3,funct7, RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, 
ALUControlE, ALUSrcE,ImmSrcD,functE);
input clk,clr, reset ,funct7;
input [2:0] funct3;
input [6:0] op;
output [1:0] ImmSrcD;
output reg RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
output reg [1:0]  ResultSrcE;
output reg [2:0] ALUControlE;
output reg [2:0] functE;
wire [1:0] ALUOp;
wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
wire [1:0] ResultSrcD;
wire [2:0] ALUControlD;
maindec dec1(op,ResultSrcD,MemWriteD,BranchD, ALUSrcD,RegWriteD, JumpD,
   ImmSrcD,ALUOp);
   aludec dec2(op[5], funct3, funct7, ALUOp,ALUControlD);
always @(posedge clk, posedge reset)
begin
if(reset|clr)
begin
   ResultSrcE <= 0;
   MemWriteE <= 0;
   BranchE <= 0;
   ALUSrcE <= 0;
   RegWriteE <= 0;
   JumpE <= 0;
   ALUControlE <= 0;
   functE<=0;
end
else
begin
   ResultSrcE <= ResultSrcD;
   MemWriteE <= MemWriteD;
   BranchE <= BranchD;
   ALUSrcE <= ALUSrcD;
   RegWriteE <= RegWriteD;
   JumpE <= JumpD;
   ALUControlE <= ALUControlD;
   functE<= funct3;
end
end
endmodule
