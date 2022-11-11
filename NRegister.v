module NRegister(DataToWrite,DataToRead,Activate,write_enable,rst,clk);

input [15:0]DataToWrite;
output reg [15:0]DataToRead;
input Activate,write_enable,rst,clk;
reg[15:0]MainReg=16'b00;
assign DataToRead=MainReg;

always@(negedge clk)begin
	if(rst)begin
		MainReg=16'b00;
	end else begin
			if(write_enable&&Activate)begin
				MainReg=DataToWrite;
			end
	end
end
endmodule


