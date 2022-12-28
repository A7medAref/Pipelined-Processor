module instructionMemory #(parameter N=6) ( write_enable,
											read_data,
											read_data_buf,
											write_data,
											clk,
											rst,
											write_addr,
											jump_occured, 
											jump_to,
											direct_jump,
											direct_jump_to);

input write_enable,clk,rst, jump_occured, direct_jump;

input[15:0]write_data;
input[31:0] write_addr;
output[15:0]read_data;
reg [15:0] read_data;
output reg [15:0] read_data_buf;
reg[15:0]regs[(1<<N)-1:0];

input [15:0] jump_to, direct_jump_to;
reg[31:0] pc=32'b0100000;
reg[15:0] loadCaseCheck;


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
		else if(direct_jump) begin
			  	$display("direct jump to %d", direct_jump_to);
				pc={0,direct_jump_to};
			end
		else
			pc=pc+1;
		
		loadCaseCheck=read_data;
		read_data=regs[pc];
		if(((loadCaseCheck[15:11] === 10) && (loadCaseCheck[7:5] === read_data[7:5] || loadCaseCheck[7:5] === read_data[10:8])) ||
			(loadCaseCheck[15:11] === 9 && (loadCaseCheck[10:8] === read_data[7:5] || loadCaseCheck[10:8] === read_data[10:8]))) begin
				$display("memory read hazard with inst %d where destination=%b,  new inst src=%b  ,dst=%b",
				 			loadCaseCheck[15:11], loadCaseCheck[7:5], read_data[10:8], read_data[7:5]);

				read_data = 0;
			  	pc = pc - 1;
			end
	end

	if(write_enable)
		regs[write_addr]=write_data;
end

endmodule
