module Adder #(
    parameter Adder_Input1_Width = 'd32,
              Adder_Input2_Width = 'd32
) (
    input  wire [Adder_Input1_Width-1:0]      IN1_Adder,
    input  wire [Adder_Input2_Width-1:0]      IN2_Adder,
    output reg  [Adder_Input1_Width-1:0]      OUT_Adder
);

always @(*) begin
    OUT_Adder = IN1_Adder + IN2_Adder;
end 
endmodule

