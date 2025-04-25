 `timescale 1ns/1ps
 module maindec(input [6:0] op,
                           output [1:0] ResultSrc,
                           output           MemWrite,
                           output           Branch, ALUSrc,
                           output          RegWrite, Jump,
                           output [1:0] ImmSrc,
                           output [1:0] ALUOp);
    reg[11:0] controls;
    assign {RegWrite, ImmSrc, ALUSrc, MemWrite,
                  ResultSrc, Branch, ALUOp, Jump} = controls;
    always @(*)
    begin
       case(op)
       // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
            7'b0000011: controls = 11'b1_00_1_0_01_0_00_0; // lw
          7'b0100011: controls = 11'b0_01_1_1_00_0_00_0; // sw
          7'b0110011: controls = 11'b1_xx_0_0_00_0_10_0; // R-type
          7'b1100011: controls = 11'b0_10_0_0_00_1_01_0; // beq
          7'b0010011: controls = 11'b1_00_1_0_00_0_10_0; // I-type ALU
          7'b1101111: controls = 11'b1_11_0_0_10_0_00_1; // jal
          7'b0000000: controls = 11'b0_00_0_0_00_0_00_0;
           default:      controls = 11'bx_xx_x_x_xx_x_xx_x; // ??? 
        endcase
        end
 endmodule
 
  module aludec(input           opb5,
                        input    [2:0] funct3,
                        input            funct7b5,
                        input  [1:0] ALUOp,
                        output reg [2:0] ALUControl);
    wire RtypeSub;
    assign RtypeSub = funct7b5 & opb5;  // TRUE for R-type subtract
    always @(*)
    begin
       case(ALUOp)
           2'b00: ALUControl = 3'b000; // addition
           2'b01: ALUControl = 3'b001; // subtraction
           default: case(funct3) // R-type or I-type ALU
                            3'b000:    if (RtypeSub)
                                                 ALUControl = 3'b001; // sub
                                            else
                                                ALUControl = 3'b000; // add, addi                       
                         3'b010:       ALUControl = 3'b101; // slt, slti
                         3'b100:       ALUControl = 3'b100;//xor
                         3'b110:       ALUControl = 3'b011; // or, ori
                         3'b111:       ALUControl = 3'b010; // and, andi
                         default:      ALUControl = 3'bxxx; // ???
                         endcase
         endcase
         end
 endmodule