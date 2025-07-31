`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2025 21:12:19
// Design Name: 
// Module Name: top
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


module top(input clk, reset, output memWriteM, output [31:0] ALUResultM, writeDataM, readDataM, pcF, InstrF  );
wire FlushE,StallD,FlushD,StallF, branch_taken, ALUSrcE, PCSrcE, RegWriteM, RegWriteW ;
wire [1:0] ImmSrcD, ResultSrcE,ResultSrcW, ForwardAE, ForwardBE;
wire [2:0] ALUControlE;
wire [31:0] InstrD, PCD, PCPlus4D, PCTargetE, PCPlus4M; 
wire [4:0] RS1E, RS2E,RDE, RDW, RDM ;
wire [2:0] functE, functM; 


Controller controller1(clk, reset, FlushE,branch_taken, InstrD, ImmSrcD, ALUSrcE,
PCSrcE, ResultSrcE, ALUControlE,memWriteM,RegWriteM, RegWriteW, ResultSrcW, functE, functM);


data_Path dataPath(clk,reset,InstrD,ImmSrcD,PCD,PCPlus4D,RS1E,functE,functM, ResultSrcW,readDataM,
RS2E, RDE,RegWriteW,FlushE,ForwardAE,ForwardBE,
ALUControlE,ALUSrcE, RDM,PCPlus4M, writeDataM, ALUResultM,RDW,
PCTargetE,branch_taken);

Hazard hazard_unit(RegWriteW, RDW, RegWriteM, RDM, ResultSrcE, ForwardBE, ForwardAE, PCSrcE,
RS1E, RS2E, RDE, FlushE, InstrD[19:15], InstrD[24:20] , StallD, FlushD, StallF );

fetch Fetch(clk, reset,PCSrcE, StallF,StallD, FlushD, InstrF, pcF,PCTargetE,
 InstrD, PCPlus4D, PCD);
 
Data_Memory dmem(clk, reset, memWriteM,
    ALUResultM, writeDataM,readDataM);
    
imem imem1(pcF, InstrF); 
endmodule



