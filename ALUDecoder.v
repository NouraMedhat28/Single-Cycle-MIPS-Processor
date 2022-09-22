module ALUDecoder (
    input  wire  [1:0]  ALUOp,
    input  wire  [5:0]  Funct,
    output reg   [2:0]  ALU_Control
);

always @(*) begin
    case (ALUOp) 
        'b00 : begin
            ALU_Control = 'b010;
        end
        'b01 : begin
            ALU_Control = 'b100; 
        end

        'b10 : begin
            case (Funct) 
                'b100000 : begin
                    ALU_Control = 'b010;
                end
                'b100010 : begin
                    ALU_Control = 'b100;
                end
                'b101010 : begin
                    ALU_Control = 'b110;
                end
                'b011100 : begin
                    ALU_Control = 'b101;
                end
                endcase
        end
        default : begin
            ALU_Control = 'b010;
        end
    endcase
end    
endmodule