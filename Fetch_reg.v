`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2025 18:54:02
// Design Name: 
// Module Name: Fetch_reg
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


module Fetch_reg(clk, reset, FlushD, StallD,RD, PCF, PCPlus4F, InstrD, PCD, PCPlus4D);
input clk, reset, FlushD,StallD;
input[31:0] RD, PCF, PCPlus4F;
output reg [31:0] InstrD, PCD, PCPlus4D;
    always @(posedge clk or posedge reset)
     begin
        if (reset | FlushD) begin
            InstrD <= 0;
            PCD <= 0;
            PCPlus4D <= 0;
        end else if (!StallD) begin
            InstrD <= RD;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;
        end
    end
endmodule
