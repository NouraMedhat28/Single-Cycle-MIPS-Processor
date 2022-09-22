module MUX #(
    parameter MUX_Width = 'd32
)
(
    input   wire  SEL,
    input   wire  [MUX_Width-1:0]  IN0,
    input   wire  [MUX_Width-1:0]  IN1,
    output  reg   [MUX_Width-1:0]  Out
);

always @(*) begin
    if(SEL) begin
        Out = IN1;
    end

    else  begin
        Out = IN0;
    end
end
    
endmodule