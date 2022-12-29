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
											functions_destination_address_buf3,
											fetch_bus_memory_buf3,
											data_sent_back_from_data_memory);

input write_enable,clk,rst, jump_occured, direct_jump, interrupt;

input[15:0]write_data;
input[31:0] write_addr;
output[15:0]read_data;
reg [15:0] read_data;
output reg [15:0] read_data_buf;
reg[15:0]regs[(1<<N)-1:0];

input [15:0] jump_to, direct_jump_to;
reg[31:0] pc;
reg[15:0] loadCaseCheck;

reg[15:0] fetch_bus_memory;
reg[15:0] fetch_bus_memory_buf1;
reg[15:0] fetch_bus_memory_buf2;
output reg[15:0] fetch_bus_memory_buf3;
reg [1:0] functions_destination_address;
reg [1:0] functions_destination_address_buf1;
reg [1:0] functions_destination_address_buf2;
output reg [1:0] functions_destination_address_buf3;
input[15:0] data_sent_back_from_data_memory;

integer i;

always@(negedge clk) begin
	functions_destination_address_buf3=functions_destination_address_buf2;
	functions_destination_address_buf2=functions_destination_address_buf1;
	functions_destination_address_buf1=functions_destination_address;
	
	fetch_bus_memory_buf3=fetch_bus_memory_buf2;
	fetch_bus_memory_buf2=fetch_bus_memory_buf1;
	fetch_bus_memory_buf1=fetch_bus_memory;

	read_data_buf = read_data;
end

reg [2:0] stallType=0;
reg [3:0] num_of_instructions_should_insert;
always@(posedge clk)
begin
	if(rst)	begin
		pc=32'b0011111;
		stallType=0;
		functions_destination_address=0;
		num_of_instructions_should_insert=0;
	end

	if(num_of_instructions_should_insert > 0) begin
		if(stallType == 1) begin
			// $display("pushing required data");
			if(num_of_instructions_should_insert == 2) begin
				fetch_bus_memory=pc[15:0];
			end else 
				functions_destination_address=2;
		end

		if(stallType == 3) begin
			// $display("pushing required data");
			if(num_of_instructions_should_insert == 1) begin
				fetch_bus_memory=pc[15:0];
			end
		end

		if(stallType == 2) begin
			// $display("poping required data");
			if(num_of_instructions_should_insert == 5) begin
				functions_destination_address=3;
			end else if(num_of_instructions_should_insert == 4) begin
				functions_destination_address=0;
			end else if (num_of_instructions_should_insert == 3)
				read_data=0;
			else if(num_of_instructions_should_insert == 1) begin
				pc[15:0]=data_sent_back_from_data_memory;
			end
		end

		if(stallType == 4) begin
			// $display("poping required data");
			if (num_of_instructions_should_insert == 3)
				read_data=0;
			else if(num_of_instructions_should_insert == 1) begin
				pc[15:0]=data_sent_back_from_data_memory;
			end
		end
		num_of_instructions_should_insert=num_of_instructions_should_insert-1;	
	
	end else if(!write_enable && interrupt && num_of_instructions_should_insert == 0 && stallType == 0 && !rst) begin
		$display("interrupt at data %b", read_data);
		stallType=1;
		functions_destination_address=1;
		fetch_bus_memory=pc[31:16];
		num_of_instructions_should_insert=2;
		read_data[15:11]=8;
	end else if(!write_enable && !rst) begin
		
		if(stallType == 2 || stallType == 4) begin
			pc[31:16]=data_sent_back_from_data_memory;  
		end
		
		if(stallType==1) begin
		  	pc=0;
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
		loadCaseCheck=read_data;
		read_data=regs[pc];
		stallType=0;
		functions_destination_address=0;

		if(read_data[15:11] == 22) begin
			$display("RTI");
			stallType=2;
			num_of_instructions_should_insert=5;
			read_data[15:11]=11;
		end else if(read_data[15:11] == 20) begin
			$display("CALL");
			stallType=3;
			functions_destination_address=1;
			fetch_bus_memory=pc[31:16];
			num_of_instructions_should_insert=1;
			read_data[15:11]=8;
		end else if(read_data[15:11] == 21) begin
			$display("RET");
			stallType=4;
			num_of_instructions_should_insert=4;
			read_data[15:11]=11;
		end

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
