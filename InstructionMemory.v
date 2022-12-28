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
											direct_jump_to,
											interrupt,
											saveStateCounter,
											stateType,
											fetchWithMemoryDataBus,
											pc,
											address_of_call);

input write_enable,clk,rst, jump_occured, direct_jump, interrupt;

output reg[2:0] saveStateCounter, stateType;

input[15:0]write_data;
input[31:0] write_addr;
output[15:0] read_data;
input[15:0] fetchWithMemoryDataBus;
reg [15:0] read_data;
output reg [15:0] read_data_buf;
reg[15:0]regs[(1<<N)-1:0];

input [15:0] jump_to, direct_jump_to, address_of_call;
output reg[31:0] pc;
reg[15:0] loadCaseCheck;


integer i;

always@(negedge clk) begin
	read_data_buf = read_data;
end



always@(posedge clk)
begin
	if(rst)	begin
		saveStateCounter=0;
		pc=32'b0011111;
	end
	
	if(saveStateCounter > 0) begin
		if(stateType == 2) begin
		  	if(saveStateCounter == 2)
				pc[15:0]=fetchWithMemoryDataBus;
		  	else if(saveStateCounter == 1)
				pc[31:16]=fetchWithMemoryDataBus;
		end else if(stateType == 3 && saveStateCounter == 3)
			pc={0,address_of_call};

	  	saveStateCounter = saveStateCounter - 1;
	end else if(!write_enable && interrupt && stateType == 0 && !rst) begin
		$display("interrupt at data %b", read_data);
		saveStateCounter=5;
		read_data=0;
		stateType=1;
	end else if(!write_enable && !rst) begin
		if(stateType == 1) begin
		  	pc=0;
			$display("start the interrupt instructions execution");
		end else if(jump_occured)
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
		
		saveStateCounter=0;
		stateType=0;

		loadCaseCheck=read_data;
		read_data=regs[pc];

		if(read_data[15:11] == 22) begin
			$display("RTI");
			stateType=2;
			saveStateCounter=6;
		end else if(read_data[15:11] == 20) begin
			$display("CALL");
			stateType=3;
			saveStateCounter=4;
		end
		// else if(read_data[15:11] == 21) begin
		// 	$display("RET");
		// 	stateType=4;
		// 	saveStateCounter=4;
		// end

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
