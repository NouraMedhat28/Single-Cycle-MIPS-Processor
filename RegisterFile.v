module RegisterFile #(
    parameter Address_Width = 'd5,
              Register_File_Width = 'd32,
              Register_File_Depth = 'd32
) (
    input wire    [Address_Width-1:0]        A1,
    input wire    [Address_Width-1:0]        A2,
    input wire    [Address_Width-1:0]        A3,
    input wire                               CLK,
    input wire                               RST,
    input wire                               WE3,
    input wire    [Register_File_Width-1:0]  WD3,
    output reg    [Register_File_Width-1:0]  RD1,
    output reg    [Register_File_Width-1:0]  RD2
);

reg [Register_File_Width-1:0]   Reg_File  [0:Register_File_Depth-1];
integer i;

//Read combinationally lw
always @(*) begin
    RD1 = Reg_File[A1];
end

//Read combinationally sw
always @(*) begin
    RD2 = Reg_File[A2];
end


always @(posedge CLK or negedge RST) begin
    //Asynchronous Reset
    if(!RST) begin
      for (i =0; i<Register_File_Depth; i = i+1 ) begin
        Reg_File[i] <= 'b0;
        
      end
    end

    else if (WE3) begin
      Reg_File[A3] <= WD3;
    end

    
end
    
endmodule