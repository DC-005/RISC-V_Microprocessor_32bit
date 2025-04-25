`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2025 16:08:22
// Design Name: 
// Module Name: riscV_tb
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
module testbench(); 
reg  clk, reset; 
wire memWriteM;
wire [31:0] ALUResultM, writeDataM, readDataM, pcF, InstrF;
top riscV(clk, reset,memWriteM,ALUResultM, writeDataM, readDataM, pcF, InstrF  );

initial 
begin 
reset <= 1; # 22; reset <= 0; 
end 
// generate clock to sequence tests 
always
begin 
clk <= 1; # 5; clk <= 0; # 5; 
end 
// check results 
always @(negedge clk) begin
    if (memWriteM) begin
        if (ALUResultM == 100 && writeDataM == 25) begin
            $display("Simulation succeeded");
            #20 $stop;
        end 
        else if (ALUResultM != 96) begin
            $display("Simulation failed");
            $stop;
        end
    end
end
endmodule 