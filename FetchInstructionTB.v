
module IFTB();
reg clk,rst,write_enable;
reg[31:0] PC,write_addr;
reg[15:0] write_data;
wire[15:0]Instruction;

fetchInstructionModule IF(
    write_enable,
    Instruction,
    write_data,
    clk,
    rst,
    write_addr);

initial begin
	$monitor("enable_write=%b,write_data=%b,write_address=%b,read_data1=%b,read_address=%b",write_enable,write_data,write_addr,Instruction,PC);
	clk=1;
	rst=1;
	write_addr=32'b0000_0000_0000_0010_0000;
	write_data=16'b0000_0000_0111_0000;
	#4 rst=0;
	#4 write_enable=1;
   	#4 write_addr=write_addr+1;
	write_data=write_data+1;
	#4 write_addr=write_addr+1;
	write_data=write_data+1;
	#4 write_addr=write_addr+1;
	write_data=write_data+1;
	#4 write_addr=write_addr+1;
	write_data=write_data+1;
	#4 write_addr=write_addr+1;
	write_data=write_data+1;
	#4 write_enable=0;

end

always begin
#2 clk= !clk;
end
endmodule



