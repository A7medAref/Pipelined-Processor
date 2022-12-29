module dataMemory #(parameter N=10) (read_enable, write_enable, memory_data_output,
									write_data, clk, rst, read_addr,
									write_addr, push_signal, pop_signal,
									functions_destination_address,
									fetch_bus_memory, currentFlags);

input read_enable,write_enable,clk,rst, push_signal, pop_signal;
input[15:0] write_data;
input[15:0] read_addr,write_addr;
output reg [15:0] memory_data_output;
reg [15:0] read_data;
reg[15:0]regs[(1<<N)-1:0];
integer i;
input [15:0] fetch_bus_memory;
input [2:0] currentFlags;
input [1:0] functions_destination_address;

reg sp=32768;
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
			$display("dest=%d fetch_bus_memory=%d flags=%b",functions_destination_address,fetch_bus_memory, currentFlags);
			sp=sp-1;
			regs[sp]= functions_destination_address==1 ? fetch_bus_memory :
					  functions_destination_address==2 ? {0,currentFlags} :	
					  write_data;
			
			$display("push value", regs[sp]);
		end
	end
end

always@(negedge clk)begin
	memory_data_output = read_data;
end

endmodule

