//Ports & Parameters
module Datapath #(
  parameter Data_Width = 'd32,
            ALU_Control_Data = 'd3,
            Address_Data = 'd5
) (
  input    wire                           CLK,
  input    wire                           RST,
  input    wire [Data_Width-1:0]          Instr_Data,
  input    wire [Data_Width-1:0]          ReadData,
  input    wire                           RegWrite_Data,
  input    wire                           MemToRegTData,
  input    wire                           RegDst_Data,
  input    wire                           ALUSrc_Data,
  input    wire                           Branch_Data,
  input    wire                           Jump_Data,
  input    wire [ALU_Control_Data-1:0]    ALUControl_Data,
  output   wire [Data_Width-1:0]          PC_Data,
  output   wire [Data_Width-1:0]          SecondRD,
  output   wire [Data_Width-1:0]          ALUOut
);

wire                    Zero_Flag;
wire                    PCSrc;
wire [Data_Width-1:0]   FirstOperand;
wire [Data_Width-1:0]   SecondOperand;
wire [Data_Width-1:0]   ExtendedReg;
wire [2:0]              AddedValue;
wire [Data_Width-1:0]   PCPlus4;
wire [Data_Width-1:0]   BranchShifterOut;
wire [Data_Width-1:0]   PCBranch;
wire [27:0]             PCJump;
wire [Data_Width-1:0]   PC_Next;
wire [Address_Data-1:0] DestinationSelectionOut;
wire [Data_Width-1:0]   BranchMuxOut;
wire [Data_Width-1:0]   WD3;


assign  AddedValue = 3'b100;
assign  PCSrc = Zero_Flag && Branch_Data;

//Modules instantiation
ALU                 #(.ALU_Width(Data_Width), .ALU_Control_Signal(ALU_Control_Data))  ALUData
( .SrcA              (FirstOperand),
  .SrcB              (SecondOperand),
  .ALUControl        (ALUControl_Data),
  .ALUResult         (ALUOut),
  .Zero              (Zero_Flag)  
); 

RegisterFile      #(.Register_File_Width(Data_Width), .Register_File_Depth(Data_Width), .Address_Width(Address_Data))  RegFileData
( .A1              (Instr_Data[25:21]),
  .A2              (Instr_Data[20:16]),
  .A3              (DestinationSelectionOut),
  .CLK             (CLK),
  .RST             (RST),
  .WE3             (RegWrite_Data),
  .WD3             (WD3), 
  .RD1             (FirstOperand),
  .RD2             (SecondRD) 
);

MUX              #(.MUX_Width('d5))            DestinationSelection
( .IN0            (Instr_Data[20:16]),
  .IN1            (Instr_Data[15:11]),
  .SEL            (RegDst_Data),
  .Out            (DestinationSelectionOut)
);

/*
The lw instruction requires an offset. The offset is stored in Instr_Data[15:0].
Because the 16-bit immediate might be either positive or negative, it must be sign-extended
to 32-bits.
*/
SignExtend       #(.Sign_Extend_Width(Data_Width))     SignImmediate
( .offset         (Instr_Data[15:0]),
  .SignImm        (ExtendedReg)
);

/*
For R-Type instructions IN0 (RD2 in the register file) is selected which means ALUSrc_Data = 0.
For the lw and sw intstructions IN0 (SignImm) is selected which means ALUSrc_Data = 1.
*/
MUX              #(.MUX_Width(Data_Width))             SecondOperandSelection 
( .IN0            (SecondRD),
  .IN1            (ExtendedReg),
  .SEL            (ALUSrc_Data),
  .Out            (SecondOperand)
);

/*
To compute the address of the next instruction we add 4 to the current instruction because the 
instructions are 32 bit = 4bytes.
*/
Adder            #(.Adder_Input1_Width(Data_Width), .Adder_Input2_Width(3))     NextInstruction
( .IN1_Adder      (PC_Data),
  .IN2_Adder      (AddedValue),
  .OUT_Adder      (PCPlus4)
);

/*
For beq instruction to compute the branch address the SignImm must be multiplied by 4 to get
the new programm counter value (Branch address = PC + 4 + (SignImm*4)).
A left shifter is used for the muliplication followed by adder to get the address.
*/
LeftShifter     #(.Shifter_input_Width(Data_Width), .Shifter_output_Width(Data_Width))   BranchShifter
( .Shift_input   (ExtendedReg),
  .Shift_output  (BranchShifterOut)
);


Adder            #(.Adder_Input1_Width(Data_Width), .Adder_Input2_Width(Data_Width))     BranchAdder
( .IN1_Adder      (BranchShifterOut),
  .IN2_Adder      (PCPlus4),
  .OUT_Adder      (PCBranch)
);

/*
If the Branch control signal weren't activiated (Because the 2 registers aren't equal) IN0 will be 
selected, and if it were activiated the MUX would select IN1 which is the branch address.
*/
MUX              #(.MUX_Width(Data_Width))             BranchMux 
( .IN0            (PCPlus4),
  .IN1            (PCBranch),
  .SEL            (PCSrc),
  .Out            (BranchMuxOut)
);

/*
Another left shifter for the Jump address.
*/
LeftShifter     #(.Shifter_input_Width('d26), .Shifter_output_Width('d28))   JumpShifter
( .Shift_input   (Instr_Data[25:0]),
  .Shift_output  (PCJump)
);

MUX              #(.MUX_Width(Data_Width))             JumpMux 
( .IN0            (BranchMuxOut),
  .IN1            ({PCPlus4[31:28], PCJump}),
  .SEL            (Jump_Data),
  .Out            (PC_Next)
);

ProgrammCounter  #(.PC_width(Data_Width))            Programm_Counter
( .CLK            (CLK),
  .RST            (RST),
  .next_instr     (PC_Next),
  .current_instr  (PC_Data)
);

/*
For the R-Type instructions the ALUOut is selected to be written in WD3 in the register file,
and for the the lw instructions the ReadData is selected.
*/

MUX                      #(.MUX_Width(Data_Width))            MUX_MemtoReg
( .IN0                   (ALUOut),
  .IN1                   (ReadData),
  .SEL                   (MemToRegTData),
  .Out                   (WD3)
);
endmodule