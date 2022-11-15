module fetchInstructionModule(write_enable,instruction,write_data,clk,rst,write_addr);

input write_enable,clk,rst;
input[15:0] write_data;
input[31:0] write_addr;
output wire [15:0]instruction;
reg[31:0] pc=32'b0100000;
instructionMemory IF(write_enable,instruction,write_data,clk,rst,pc,write_addr);

always@(negedge clk)begin
	if(rst)
	pc=32'b0100000;
	if(!write_enable && !rst)
	pc=pc+1;
end

endmodule
