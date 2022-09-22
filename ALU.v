module ALU #(
    parameter ALU_Width = 'd32,
              ALU_Control_Signal = 'd3
) (
    input  wire  [ALU_Width-1:0]              SrcA,
    input  wire  [ALU_Width-1:0]              SrcB,
    input  wire  [ALU_Control_Signal-1:0]     ALUControl,
    output reg   [ALU_Width-1:0]              ALUResult,
    output reg                                Zero
);

always @(*) begin
    case (ALUControl)
    'b000 : begin
        ALUResult = SrcA & SrcB;
    end 

    'b001 : begin
        ALUResult = SrcA | SrcB;
    end

    'b010 : begin
        ALUResult = SrcA + SrcB;
    end

    'b100 : begin
        ALUResult = SrcA - SrcB;
    end

    'b101 : begin
        ALUResult = SrcA * SrcB;
    end

    'b110 : begin
        //SLT
        if (SrcA < SrcB) begin
            ALUResult = 'b1;
        end
        else begin
            ALUResult = 'b0;
        end
    end

        default : begin
            ALUResult = 'b0;
        end
    endcase
    
end
always @(*) begin
    Zero = (ALUResult == 'b0 && ALUControl!='b011 && ALUControl!='b111);
end
   
endmodule