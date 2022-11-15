module fetchInstructionModule(write_enable,instruction,write_data,clk,rst,pc,write_addr);

input write_enable,clk,rst;
input[15:0]write_data;
input[31:0] write_addr;
input [31:0] pc;
output wire [15:0]instruction;

instructionMemory IF(write_enable,instruction,write_data,clk,rst,pc,write_addr);

always@(negedge clk)begin
	pc=pc+1;
end

endmodule


