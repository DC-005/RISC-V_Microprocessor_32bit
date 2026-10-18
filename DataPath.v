`timescale 1ns/1ps

module data_Path(
    CLK, rst, InstrD, ImmSrcD, PCD, PCPlus4D, RS1_E, ResultSrcW, RD,
    RS2_E, RD_E, RegWriteW, flushE, ForwardA_E, ForwardB_E,
    ALUControlE, ALUSrcE, RD_M, PCPlus4M, WriteDataM, ALU_ResultM, RDW,
    PCTargetE, ZeroE
);

    // ==========================================
    // Port Declarations
    // ==========================================
    // Clock and Reset
    input             CLK, rst;

    // Decode Stage Inputs
    input      [31:0] InstrD, PCD, PCPlus4D;
    input      [1:0]  ImmSrcD;

    // Execute Stage Control Inputs
    input             ALUSrcE, flushE;
    input      [1:0]  ForwardA_E, ForwardB_E;
    input      [2:0]  ALUControlE;

    // Memory & Writeback Inputs
    input      [31:0] RD;           // Read data from Data Memory
    input             RegWriteW;
    input      [1:0]  ResultSrcW;

    // Module Outputs
    output            ZeroE;
    output     [31:0] PCTargetE;
    output reg [4:0]  RS1_E, RS2_E, RD_E;
    output reg [4:0]  RD_M;
    output reg [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    output     [4:0]  RDW;

    // ==========================================
    // Internal Signals
    // ==========================================
    // Decode (D) stage
    wire [31:0] RD1_D, RD2_D, Imm_Ext_D;

    // Execute (E) stage
    reg  [31:0] RD1_E, RD2_E, Imm_Ext_E;
    reg  [31:0] PCE, PCPlus4E;
    wire [31:0] Src_A, Src_B_inter, Src_B;
    wire [31:0] ResultE;

    // Writeback (W) stage
    wire [31:0] ALUResultW, ReadDataW, PCPlus4W;
    wire [31:0] ResultW;

    // ==========================================
    // 1. Decode Stage (ID)
    // ==========================================
    register_File reg1 (
        .CLK(CLK),
        .rst(rst),
        .WE3(RegWriteW),
        .WD3(ResultW),
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(RDW),
        .RD1(RD1_D),
        .RD2(RD2_D)
    );

    extend ext (
        .instr(InstrD),
        .immsrc(ImmSrcD),
        .immext(Imm_Ext_D)
    );

    // ==========================================
    // 2. Decode -> Execute Register (ID/EX)
    // ==========================================
    always @(posedge CLK or posedge rst) begin
        if (rst || flushE) begin
            RD1_E     <= 32'b0;
            RD2_E     <= 32'b0;
            Imm_Ext_E <= 32'b0;
            PCE       <= 32'b0;
            PCPlus4E  <= 32'b0;
            RD_E      <= 5'b0;
            RS1_E     <= 5'b0;
            RS2_E     <= 5'b0;
        end else begin
            RD1_E     <= RD1_D;
            RD2_E     <= RD2_D;
            Imm_Ext_E <= Imm_Ext_D;
            PCE       <= PCD;
            PCPlus4E  <= PCPlus4D;
            RD_E      <= InstrD[11:7];
            RS1_E     <= InstrD[19:15];
            RS2_E     <= InstrD[24:20];
        end
    end

    // ==========================================
    // 3. Execute Stage (EX)
    // ==========================================
    // Forwarding Multiplexers
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

    // ALU Source B Selection
    Mux alu_src_mux (
        .a(Src_B_inter),
        .b(Imm_Ext_E),
        .s(ALUSrcE),
        .c(Src_B)
    );

    // ALU Core
    ALU alu (
        .SrcAE(Src_A),
        .SrcBE(Src_B),
        .ALUControlE(ALUControlE),
        .ALUResult(ResultE),
        .ZeroE(ZeroE)
    );

    // Branch Target Calculation
    pcAdder branch_adder (
        .a(PCE),
        .b(Imm_Ext_E),
        .y(PCTargetE)
    );

    // ==========================================
    // 4. Execute -> Memory Register (EX/MEM)
    // ==========================================
    always @(posedge CLK or posedge rst) begin
        if (rst) begin
            RD_M        <= 5'b0;
            PCPlus4M    <= 32'b0;
            WriteDataM  <= 32'b0;
            ALU_ResultM <= 32'b0;
        end else begin
            RD_M        <= RD_E;
            PCPlus4M    <= PCPlus4E;
            WriteDataM  <= Src_B_inter;
            ALU_ResultM <= ResultE;
        end
    end

    // ==========================================
    // 5. Memory -> Writeback Register (MEM/WB)
    // ==========================================
    flopr #(101) regW (
        .clk(CLK),
        .reset(rst),
        .d({ALU_ResultM, RD, RD_M, PCPlus4M}),
        .q({ALUResultW, ReadDataW, RDW, PCPlus4W})
    );

    // ==========================================
    // 6. Writeback Stage (WB)
    // ==========================================
    Mux3 resulta (
        .a(ALUResultW),
        .b(ReadDataW),
        .c(PCPlus4W),
        .s(ResultSrcW),
        .d(ResultW)
    );

endmodule
