`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2025 23:53:44
// Design Name: 
// Module Name: control_m
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


module control_m(clk, reset, RegWriteM, ResultSrcM, RegWriteW, 
ResultSrcW);
input clk, reset, RegWriteM;
input [1:0] ResultSrcM;
output reg  RegWriteW;
output reg [1:0] ResultSrcW;
always @(posedge clk, posedge reset)
begin   
    if(reset)
    begin
        RegWriteW <= 0;
        ResultSrcW <= 0;
    end
    else
    begin
        RegWriteW <= RegWriteM;
        ResultSrcW <= ResultSrcM;
    end
end
endmodule
