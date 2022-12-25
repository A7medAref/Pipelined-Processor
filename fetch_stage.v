module fetchStage(write_enable,
                write_data,
                write_addr,
                clk, 
                rst, 
                instruction_buf);

input write_enable, clk, rst;
input[15:0] write_data;

input[31:0] write_addr;

output reg[15:0] instruction_buf;

reg [15:0] instruction;

fetchInstructionModule FIM151853(write_enable, instruction, write_data, clk, rst, write_addr);

endmodule