`timescale 1ns/1ps
module ALU(
    input [31:0] SrcAE, SrcBE,       
    input [2:0] ALUControlE,   
    output reg ZeroE,          
    output reg [31:0] ALUResult  
);

    wire [31:0] Sum;          
    wire [31:0] SubResult;    
    
    assign Sum = SrcAE + SrcBE; 
    assign SubResult = SrcAE - SrcBE;

    always @(*) begin
        case (ALUControlE)
            3'b000: ALUResult = Sum;                 
            3'b001: ALUResult = SubResult;           
            3'b010: ALUResult = SrcAE & SrcBE;       
            3'b011: ALUResult = SrcAE | SrcBE;       
            3'b100: ALUResult = SrcAE ^ SrcBE;      
            3'b101: ALUResult = (SrcAE < SrcBE) ? 32'b1 : 32'b0; 
            3'b110: ALUResult = SrcAE << 1;          
            3'b111: ALUResult = SrcAE >>> 1;         
            default: ALUResult = 32'hxxxxxxxx;             
        endcase
        
        ZeroE = (ALUResult == 32'b0);
    end

endmodule

