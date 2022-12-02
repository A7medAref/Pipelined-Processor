module fetch(
    input clk,
    input[15:0] instruction,
    output reg[2:0] src,
    output reg[2:0] dest,
    output reg[2:0] opcode
);
    always @(posedge clk) begin
        opcode = instruction[15:13];
        src = instruction[12:10];
        dest = instruction[9:7];
    end
endmodule