`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2025 18:39:07
// Design Name: 
// Module Name: imem
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


module imem(A, RD);
input [31:0] A;
output reg [31:0] RD;
reg [31:0] imem_reg[63:0];
initial
       $readmemh("riscvtest.mem",imem_reg);
always@(*) 
RD <= imem_reg[A[31:2]];
endmodule
