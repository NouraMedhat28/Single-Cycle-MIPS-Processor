module MainDecoder  (
    input  wire   [5:0]  Decoder_Input,
    output reg           MemToReg,
    output reg           MemWrite,
    output reg           Branch,
    output reg           ALUSrc,
    output reg           RegDst,
    output reg           RegWrite,
    output reg           Jump,
    output reg   [1:0]   ALUOp_MD
);

always @(*) begin
    case(Decoder_Input)

        //R-Type
        'b000000 : begin
           RegWrite = 'b1;
           RegDst   = 'b1;
           ALUOp_MD = 'b10;
           Jump     = 'b0;
           MemToReg = 'b0;
           MemWrite = 'b0;
           Branch   = 'b0;
           ALUSrc   = 'b0;
        end

        //Load word
        'b100011 : begin
            RegWrite = 'b1;
            ALUSrc   = 'b1;
            MemToReg = 'b1;
            MemWrite = 'b0;
            Branch   = 'b0;
            RegDst   = 'b0;
            Jump     = 'b0;
            ALUOp_MD = 'b00;
        end

        //Store word
        'b101011 : begin
            ALUSrc   = 'b1;
            MemWrite = 'b1;
            Branch   = 'b0;
            RegDst   = 'b0;
            Jump     = 'b0;
            ALUOp_MD = 'b00;
            RegWrite = 'b0;
            MemToReg = 'b0;
        end

        //Branch if equal
        'b000100 : begin
            Branch   = 'b1;
            ALUOp_MD = 'b01;
            RegDst   = 'b0;
            Jump     = 'b0;
            RegWrite = 'b0;
            MemToReg = 'b0;
            ALUSrc   = 'b0;
            MemWrite = 'b0;
        end

        //Add immediate 
        'b001000 : begin
            RegWrite = 'b1;
            ALUSrc   = 'b1;
            Branch   = 'b0;
            ALUOp_MD = 'b00;
            RegDst   = 'b0;
            Jump     = 'b0;
            MemToReg = 'b0;
            MemWrite = 'b0;
        end

        //Jump
        'b000010 : begin
            Jump = 'b1;
            RegWrite = 'b0;
            ALUSrc   = 'b0;
            Branch   = 'b0;
            ALUOp_MD = 'b00;
            RegDst   = 'b0;
            MemToReg = 'b0;
            MemWrite = 'b0;
        end

        //Default
        default : begin
           MemToReg = 'b0;
           MemWrite = 'b0;
           Branch   = 'b0;
           ALUSrc   = 'b0;
          RegDst   =  'b0;
          RegWrite =  'b0;
          Jump     =  'b0;
          ALUOp_MD =  'b00; 
        end
    endcase
end
    
endmodule