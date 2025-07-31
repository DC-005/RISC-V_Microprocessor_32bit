`timescale 1ns/1ps
module control_e(clk, reset, RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, RegWriteM,
     ResultSrcM, MemWriteM, branch_taken, PCSrcE, functE, functM);
input clk, reset, RegWriteE, MemWriteE, JumpE, BranchE, branch_taken, functE;
input [1:0] ResultSrcE;
output reg RegWriteM, MemWriteM, functM; 
output PCSrcE;
output reg [1:0]  ResultSrcM;
wire andr;
and (andr, branch_taken, BranchE);
or (PCSrcE, andr, JumpE);
always @(posedge clk, posedge reset)
begin
if(reset)
begin
   ResultSrcM <= 0;
   MemWriteM <= 0;
   RegWriteM <= 0;
   functM <= 0;
end
else
begin  ResultSrcM <= ResultSrcE;
   MemWriteM <= MemWriteE;
   RegWriteM <= RegWriteE;
   functM <= functE;
end
end
endmodule

