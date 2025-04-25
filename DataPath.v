`timescale 1ns/1ps

module data_Path(CLK,rst,InstrD,ImmSrcD,PCD,PCPlus4D,RS1_E,ResultSrcW,RD,
RS2_E, RD_E,RegWriteW,flushE,ForwardA_E,ForwardB_E,
ALUControlE,ALUSrcE, RD_M,PCPlus4M, WriteDataM, ALU_ResultM,RDW,
PCTargetE,ZeroE);
    input CLK, rst, RegWriteW,ALUSrcE, flushE;
    input [31:0] InstrD, PCD, PCPlus4D,RD;
    input [1:0] ForwardA_E, ForwardB_E,ImmSrcD,ResultSrcW;
    input [2:0] ALUControlE;
    output ZeroE;
    output [4:0] RD_M,RS1_E, RS2_E, RD_E; 
    output [31:0] PCTargetE;
    output [4:0] RDW;
    output [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    wire [31:0] ResultW;
    

    // Wires
    wire [31:0] RD1_D, RD2_D, Imm_Ext_D;
    wire [31:0] RD1_E, RD2_E, Imm_Ext_E;
    wire [31:0] PCE, PCPlus4E;
    wire [31:0] Src_A, Src_B_inter, Src_B;
    wire [31:0] ResultE;
    wire ZeroE1;
    wire [31:0] PCPlus4W, WriteDataW, ALUResultW,ReadDataW;



    // Register
    reg [31:0] RD1_D_r, RD2_D_r, Imm_Ext_D_r;
    reg [4:0] RD_D_r, RS1_D_r, RS2_D_r;
    reg [31:0] PCD_r, PCPlus4D_r;
    reg RegWriteE_r, MemWriteE_r, ResultSrcE_r;
    reg [4:0] RD_E_r;
    reg [31:0] PCPlus4E_r, RD2_E_r, ResultE_r;





    register_File reg1(
        .CLK(CLK),.rst(rst),.WE3(RegWriteW),.WD3(ResultW),.A1(InstrD[19:15]),.A2(InstrD[24:20]),.A3(RDW),.RD1(RD1_D),.RD2(RD2_D)
    );

    extend ext(
        .instr(InstrD), .immsrc(ImmSrcD) , .immext(Imm_Ext_D)
    );

    always @(posedge CLK or posedge rst) begin
        if(rst| flushE) begin
            RD1_D_r <= 32'h00000000; 
            RD2_D_r <= 32'h00000000; 
            Imm_Ext_D_r <= 32'h00000000;
            RD_D_r <= 5'h00;
            PCD_r <= 32'h00000000; 
            PCPlus4D_r <= 32'h00000000;
            RS1_D_r <= 5'h00;
            RS2_D_r <= 5'h00;
        end
        else begin
            RD1_D_r <= RD1_D; 
            RD2_D_r <= RD2_D; 
            Imm_Ext_D_r <= Imm_Ext_D;
            RD_D_r <= InstrD[11:7];
            PCD_r <= PCD; 
            PCPlus4D_r <= PCPlus4D;
            RS1_D_r <= InstrD[19:15];
            RS2_D_r <= InstrD[24:20];
        end
    end
    assign RD1_E = RD1_D_r;
    assign RD2_E = RD2_D_r;
    assign Imm_Ext_E = Imm_Ext_D_r;
    assign RD_E = RD_D_r;
    assign PCE = PCD_r;
    assign PCPlus4E = PCPlus4D_r;
    assign RS1_E = RS1_D_r;
    assign RS2_E = RS2_D_r;
    Mux3 srca (
                        .a(RD1_E),
                        .b(ResultW),
                        .c(ALU_ResultM),
                        .s(ForwardA_E),
                        .d(Src_A)
                        );

    Mux3 srcb (
                        .a(RD2_E),
                        .b(ResultW),
                        .c(ALU_ResultM),
                        .s(ForwardB_E),
                        .d(Src_B_inter)
                        );
    Mux alu_src_mux (
            .a(Src_B_inter),
            .b(Imm_Ext_E),
            .s(ALUSrcE),
            .c(Src_B)
            );
    ALU alu (
            .SrcAE(Src_A),
            .SrcBE(Src_B),
            .ALUResult(ResultE),
            .ALUControlE(ALUControlE),
            .ZeroE(ZeroE1)
            );
    pcAdder branch_adder (
            .a(PCE),
            .b(Imm_Ext_E),
            .y(PCTargetE)
            );
    always @(posedge CLK or posedge rst) begin
        if(rst) begin
            RD_E_r <= 5'h00;
            PCPlus4E_r <= 32'h00000000; 
            RD2_E_r <= 32'h00000000; 
            ResultE_r <= 32'h00000000;
        end
        else begin

            RD_E_r <= RD_E;
            PCPlus4E_r <= PCPlus4E; 
            RD2_E_r <= Src_B_inter; 
            ResultE_r <= ResultE;
        end
    end
    

    // Output Assignments
    assign ZeroE = ZeroE1;
    assign RD_M = RD_E_r;
    assign PCPlus4M = PCPlus4E_r;
    assign WriteDataM = RD2_E_r;
    assign ALU_ResultM = ResultE_r;
    flopr  #(101) regW(CLK, rst,{ALU_ResultM, RD ,RD_M, PCPlus4M}, {ALUResultW, ReadDataW, RDW, PCPlus4W});
    Mux3 resulta(
                        .a(ALUResultW),
                        .b(ReadDataW),
                        .c(PCPlus4W),
                        .s(ResultSrcW),
                        .d(ResultW)
                        );

endmodule
