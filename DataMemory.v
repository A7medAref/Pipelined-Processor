module dataMemory #(parameter N=10) (read_enable, write_enable, memory_data_output,
									write_data, clk, rst, read_addr,
									write_addr);

input read_enable,write_enable,clk,rst;
input[15:0] write_data;
input[15:0] read_addr,write_addr;
output reg [15:0] memory_data_output;
reg [15:0] read_data;
reg[15:0]regs[(1<<N)-1:0];
integer i;

always@(posedge clk)begin
	if(rst)begin
		for(i=0;i<8;i=i+1)begin
			regs[i]=16'b00;
		end
	end else begin
		if(write_enable)begin
			regs[write_addr]=write_data;
			$display("writting happend in %b with value %b",write_addr, regs[write_addr]);
		end
		if(read_enable)begin
			read_data=regs[read_addr];
			$display("data read from memory at %b with value= %b",read_addr, read_data);
		end
end
end

always@(negedge clk)begin
	memory_data_output = read_data;
end

endmodule

