module dataMemory #(parameter N=10) (read_enable,write_enable,read_data,write_data,clk,rst,read_addr,write_addr);

input read_enable,write_enable,clk,rst;
input[15:0]write_data;
input[2:0] read_addr,write_addr;
output[15:0]read_data;
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
	end
end
end

always@(negedge clk)begin
	if(rst)begin
		for(i=0;i<8;i=i+1)begin
			regs[i]=16'b00;
		end
	end else begin
		if(read_enable)begin
			read_data=regs[read_addr];
		end
	end
end

endmodule

