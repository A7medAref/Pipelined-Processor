module fetchInstructionModule
(
	write_enable, 
	instruction_buf, 
	write_data,
	clk,
	rst,
	write_addr,
	jump_occured, 
	jump_to,
	direct_jump,
	direct_jump_to
);

input write_enable,clk,rst, jump_occured, direct_jump;
input[15:0] write_data;
input[31:0] write_addr;

/////////////////////////////////////
input [15:0] jump_to, direct_jump_to;

wire [15:0]instruction;
output wire [15	:0]instruction_buf;

instructionMemory IF(write_enable,
					instruction,
					instruction_buf,
					write_data,
					clk,
					rst,
					write_addr,
					jump_occured, 
					jump_to,
					direct_jump,
					direct_jump_to);

endmodule
