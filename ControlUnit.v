module ControlUnit (
   input  wire [5:0]    Funct,
   input  wire [5:0]    OpCode,
   output wire          MemToReg_C,
   output wire          MemWrite_C,
   output wire          Branch_C,
   output wire          ALUSrc_C,
   output wire          RegDst_C,
   output wire          RegWrite_C,
   output wire          Jump_C,
   output wire [2:0]    ALUControl_C

);

wire  [1:0]   ALUOp_int_Control;


MainDecoder                Main_Decoder_Control
( .Decoder_Input            (OpCode),
  .MemToReg                 (MemToReg_C),
  .MemWrite                 (MemWrite_C),
  .Branch                   (Branch_C),
  .ALUSrc                   (ALUSrc_C),
  .RegDst                   (RegDst_C),
  .RegWrite                 (RegWrite_C),
  .Jump                     (Jump_C),
  .ALUOp_MD                 (ALUOp_int_Control)
);

ALUDecoder                ALU_Decoder_Control
( .ALUOp                   (ALUOp_int_Control),
  .Funct                   (Funct),
  .ALU_Control             (ALUControl_C)
);
    
endmodule