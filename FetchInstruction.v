module fetchInstructionModule
(
	write_enable, 
	instruction_buf, 
	write_data,
	clk,
	rst,
	write_addr,
	jump_occured, 
	jump_to
);

input write_enable,clk,rst, jump_occured;
input[15:0] write_data;
input[31:0] write_addr;

/////////////////////////////////////
input [15:0] jump_to;

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
					jump_to);

// always@(negedge clk)begin
// 	if(rst)
// 	pc=32'b0100000;
// 	if(!write_enable && !rst) begin
// 	  	if(jump_occured)
// 			begin
// 			  	$display("jumping to %d", jump_to);
// 				pc={0,jump_to};
// 			end
// 		else
// 			pc=pc+1;
// 	end
// end

endmodule
