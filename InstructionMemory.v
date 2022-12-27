module instructionMemory #(parameter N=6) ( write_enable,
											read_data,
											read_data_buf,
											write_data,
											clk,
											rst,
											write_addr,
											jump_occured, 
											jump_to);

input write_enable,clk,rst, jump_occured;

input[15:0]write_data;
input[31:0] write_addr;
output[15:0]read_data;
reg [15:0] read_data;
output reg [15:0] read_data_buf;
reg[15:0]regs[(1<<N)-1:0];

input [15:0] jump_to;
reg[31:0] pc=32'b0100000;


integer i;

always@(negedge clk) begin
	read_data_buf = read_data;
end

always@(posedge clk)
begin
	if(rst)
		pc=32'b0011111;
	if(!write_enable && !rst) begin
	  	if(jump_occured)
			begin
			  	$display("jumping to %d", jump_to);
				pc={0,jump_to};
			end
		else
			pc=pc+1;
	
		read_data=regs[pc];
	end

	if(write_enable)
		regs[write_addr]=write_data;
end

endmodule
