module dataMemory #(parameter N=15) (read_enable, write_enable, memory_data_output,
									write_data, clk, rst, read_addr,
									write_addr, push_signal, pop_signal,
									saveStateCounter, stateType, busWithFetch,flags_exec_unit,
									pc);

input read_enable,write_enable,clk,rst, push_signal, pop_signal;
input[15:0] write_data;
input[15:0] read_addr,write_addr;
output reg [15:0] memory_data_output;
reg [15:0] read_data;
reg[15:0]regs[(1<<N)-1:0];

output reg[15:0] busWithFetch;
input [31:0] pc;

input[2:0] saveStateCounter, stateType;
input [2:0] flags_exec_unit;
integer i;

reg[15:0] sp=32768;
always@(posedge clk)begin
	if(rst)begin
		for(i=0;i<8;i=i+1)begin
			regs[i]=16'b00;
		end
		sp=32768;
	end else begin
		if(write_enable)begin
			regs[write_addr]=write_data;
			$display("writting happend in %d with value %d",write_addr, regs[write_addr]);
		end
		
		if(pop_signal) begin
			$display("pop value", regs[sp]);
			read_data=regs[sp];
			sp=sp+1;
		end else if(read_enable)begin
			read_data=regs[read_addr];
			$display("data read from memory at %d with value= %d",read_addr, read_data);
		end

		if(push_signal) begin
			sp=sp-1;
			regs[sp]=write_data;
			$display("push value", regs[sp]);
		end
		if(saveStateCounter > 0) begin
			if(stateType == 1  && saveStateCounter < 4) begin
				sp=sp-1;
				if(saveStateCounter == 3) begin
					regs[sp]=pc[31:16];
				end else if(saveStateCounter == 2) begin
					regs[sp]=pc[15:0];
				end else begin
				  	regs[sp]=flags_exec_unit;
				end
			end
			if(stateType == 2 && saveStateCounter < 5 && saveStateCounter > 1) begin
				busWithFetch=regs[sp];
				sp=sp+1;
			end
			$display("saveStateCounter %d", saveStateCounter);
		end
	end
end

always@(negedge clk)begin
	memory_data_output = read_data;
end

endmodule

