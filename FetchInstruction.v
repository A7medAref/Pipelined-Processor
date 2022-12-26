module fetchInstructionModule(write_enable, instruction_buf, write_data,clk,rst,write_addr, jump_signal, jump_to);

input write_enable,clk,rst;
input[15:0] write_data;
input[31:0] write_addr;

/////////////////////////////////////
input jump_signal;
input [15:0] jump_to;

wire [15:0]instruction;
output wire [15:0]instruction_buf;
reg[31:0] pc=32'b0100000;

instructionMemory IF(write_enable, instruction, instruction_buf,write_data,clk,rst,pc,write_addr);

always@(negedge clk)begin
	if(rst)
	pc=32'b0100000;
	if(!write_enable && !rst) begin
	  	if(jump_signal)
			pc={0,jump_to};
		else
			pc=pc+1;
	end
end

endmodule
