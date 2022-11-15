module PC(pcValue,clk);
reg[31:0] PC=32'b0010_0000;
output wire [31:0] pcValue;
assign pcValue=PC;
always@(negedge clk)begin
	PC=PC+1;
end
endmodule