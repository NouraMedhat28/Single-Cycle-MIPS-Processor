module SignExtend #(
    parameter Sign_Extend_Width = 'd32
) (
    input  wire   [Sign_Extend_Width/2-1:0]    offset,
    output reg    [Sign_Extend_Width-1:0]      SignImm
);

integer i;


always @(*) begin
    SignImm[Sign_Extend_Width/2-1:0] <= offset[Sign_Extend_Width/2-1:0];
        
    for (i = Sign_Extend_Width/2; i<Sign_Extend_Width ; i = i +1  ) begin
        SignImm[i] = offset[Sign_Extend_Width/2-1-1];
    end
    
end
    
endmodule

