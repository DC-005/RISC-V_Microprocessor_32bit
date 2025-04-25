`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.03.2025 14:24:21
// Design Name: 
// Module Name: Hazard
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


module Hazard(regWriteW, rdW, regWriteM, rdM, resultSrcE, forwardBE, forwardAE, pcSrcE,
rs1E, rs2E, rdE, flushE, rs1D, rs2D, stallD, flushD, stallF );
input regWriteW, regWriteM, pcSrcE;
input [1:0] resultSrcE;
input [4:0] rdM, rdW, rs1E, rs2E, rdE, rs1D, rs2D;
output flushE, stallD, flushD, stallF;
output reg [1:0] forwardBE, forwardAE;
wire lwStallD;
always @(*)
    begin
        if (((rs1E == rdM)& regWriteM)&(rs1E != 0)) forwardAE = 2'b10;
        else if (((rs1E == rdW)& regWriteW)&(rs1E != 0)) forwardAE = 2'b01;
        else forwardAE = 2'b00;
        if (((rs2E == rdM)& regWriteM)&(rs2E != 0)) forwardBE = 2'b10;
        else if (((rs2E == rdW)& regWriteW)&(rs2E != 0)) forwardBE = 2'b01;
        else forwardBE = 2'b00;
        
    end
        assign lwStallD = resultSrcE[0] & ((rs1D == rdE) | (rs2D == rdE));   
        assign stallD = lwStallD; 
        assign stallF = lwStallD; 
        assign flushD = pcSrcE; 
        assign flushE = lwStallD | pcSrcE; 
endmodule 
