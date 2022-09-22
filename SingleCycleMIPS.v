module SingleCycleMIPS #(
    parameter Data_Width_Top = 'd32,
              Address_Width_Top = 'd5,
              ALU_Control_Top = 'd3,
              test_value_width_Top = 'd16,
              Depth_Top = 'd100
) (
    input  wire                                 CLK,
    input  wire                                 RST,
    output wire  [test_value_width_Top-1:0]     Test_value_Top
); 
wire  [Data_Width_Top-1:0]           current_Top;
wire  [Data_Width_Top-1:0]           Instruction_Top;
wire  [Data_Width_Top-1:0]           ALUOut_Top;
wire  [Data_Width_Top-1:0]           ReadData;
wire  [ALU_Control_Top-1:0]          ALUControlTop;
wire                                 MemWrite_Top;
wire                                 MemToRegTop;
wire                                 RegWriteTop;
wire                                 RegDstTop;
wire                                 ALUSrcTop;
wire                                 BranchTop;
wire                                 JumpTop;
wire [Data_Width_Top-1:0]            SecondRD_Top;
wire [Data_Width_Top-1:0]            WD3_Top;

  
Datapath                #(.Data_Width(Data_Width_Top), .Address_Data(Address_Width_Top), .ALU_Control_Data(ALU_Control_Top))   Datapath_Top
( .CLK                   (CLK),
  .RST                   (RST),
  .PC_Data               (current_Top),
  .Instr_Data            (Instruction_Top),
  .ALUOut                (ALUOut_Top),
  .ReadData              (ReadData),
  .Jump_Data             (JumpTop),
  .SecondRD              (SecondRD_Top),
  .RegWrite_Data         (RegWriteTop),
  .RegDst_Data           (RegDstTop),
  .ALUSrc_Data           (ALUSrcTop),
  .Branch_Data           (BranchTop),
  .MemToRegTData         (MemToRegTop),
  .ALUControl_Data       (ALUControlTop)
);

ControlUnit             ControlUnitTop
(.Funct                  (Instruction_Top[5:0]),
 .OpCode                 (Instruction_Top[31:26]),       
 .MemToReg_C             (MemToRegTop), 
 .MemWrite_C             (MemWrite_Top),
 .Branch_C               (BranchTop),
 .ALUSrc_C               (ALUSrcTop),
 .RegDst_C               (RegDstTop),
 .RegWrite_C             (RegWriteTop),
 .Jump_C                 (JumpTop),
 .ALUControl_C           (ALUControlTop)
);



DataMemory            #(.test_value_width(test_value_width_Top), .Data_Memory_Depth(Depth_Top), .Data_Memory_Width(Data_Width_Top))   Data_Memory_Top
( .CLK                  (CLK),
  .RST                  (RST),
  .A_Data               (ALUOut_Top),
  .RD                   (ReadData),
  .WD                   (SecondRD_Top),
  .WE                   (MemWrite_Top),
  .Test_value           (Test_value_Top)
);


InstructionMemory       #(.Memory_Width(Data_Width_Top), .Memory_Depth(Depth_Top))  instr_memory_Top
( .A_Instr               (current_Top),
  .Instr                 (Instruction_Top)
);
    
endmodule