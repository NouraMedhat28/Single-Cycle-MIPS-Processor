module LeftShifter #(
    parameter Shifter_input_Width  = 'd32,
              Shifter_output_Width = 'd32
) (
    input  wire [Shifter_input_Width-1:0]         Shift_input,
    output wire [Shifter_output_Width-1:0]        Shift_output
);

assign  Shift_output = Shift_input << 2;
   
endmodule