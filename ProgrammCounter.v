//Ports & parameters
module ProgrammCounter #(
    parameter  PC_width = 'd32
) (
    input wire [PC_width-1:0]   next_instr,
    input wire                  CLK,
    input wire                  RST,
    output reg [PC_width-1:0]   current_instr
);

/*
Program counter is a 32-bit register, its output is the address of the current 
instruction and its input is the address of the next instruction
*/

always @(posedge CLK or negedge RST) begin
    //Asynchronous Reset
    if(!RST) begin
       current_instr <= 'b0; 
    end

    else begin
        current_instr <= next_instr;
    end
    
end
    
endmodule