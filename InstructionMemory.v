module InstructionMemory #(
    parameter Memory_Width = 'd32,
              Memory_Depth = 'd100
) (
    input wire   [Memory_Width-1:0]  A_Instr,
    output reg   [Memory_Width-1:0]  Instr
);

reg [Memory_Width-1:0]  Instr_Memory [0:Memory_Depth-1];

initial begin
    $readmemh("GCD_Machine Code.txt", Instr_Memory);
end


always @(*) begin
    Instr =Instr_Memory[A_Instr>>2];
end


endmodule
