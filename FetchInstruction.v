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
	direct_jump_to,
	interrupt,
	saveInterruptData
);

input write_enable,clk,rst, jump_occured, direct_jump, interrupt;
input[15:0] write_data;
input[31:0] write_addr;
input [15:0] jump_to, direct_jump_to;
output saveInterruptData;
output wire [15	:0]instruction_buf;
/////////////////////////////////////

wire [15:0]instruction;

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
					direct_jump_to,
					interrupt,
					saveInterruptData);

endmodule
