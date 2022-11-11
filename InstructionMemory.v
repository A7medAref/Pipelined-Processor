module NMemory #(parameter N=5) (read_enable,write_enable,read_data,write_data,clk,rst,read_addr,write_addr);

input read_enable,write_enable,clk,rst;
input[15:0]write_data;
input[N-1:0] read_addr,write_addr;
output reg[15:0]read_data;
wire [(1<<N)-1:0]Activate;
wire [15:0]RegOut[(1<<N)-1:0];

NDecoder D (write_addr,Activate,clk);

genvar j;
generate
	for(j=0;j<(1<<N);j=j+1)begin
		NRegister R(write_data,RegOut[j],Activate[j],write_enable,rst,clk);
	end
endgenerate

always@(negedge clk)begin
	if(rst)begin
	end else begin
		if(read_enable)begin
			read_data=RegOut[read_addr];
		end
	end
end

endmodule



