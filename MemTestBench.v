
module instructionMemoryTB();
localparam N=16;
reg clk,rst,read_enable,write_enable;
reg[4:0] read_addr,write_addr;
reg[15:0] write_data;
wire[15:0]read_data;

instructionMemory Reg1(
	read_enable,
	write_enable,
	read_data,
	write_data,
	clk,
	rst,
	read_addr,
	write_addr);

initial begin
	$monitor("enable_write=%b,write_data=%b,write_address=%b,enable_read=%b,read_data1=%b,read_address=%b",write_enable,write_data,write_addr,read_enable,read_data,read_addr);
	clk=1;
	rst=1;
	read_enable=0;
	write_enable=0;
	read_addr=3'b001;
	write_addr=3'b000;
	write_data=16'b0000_0000_0111_0000;
	#4 rst=0;
	#4 write_enable=1;
   	#4 write_addr=5'b00000;
	write_data=16'b1111_0000_1111_0000;

	#4 write_addr=5'b00001;
	write_data=16'b1111_1111_1111_0000;

	#4 write_addr=5'b00010;
	write_data=16'b1111_1111_1111_1111;

	#4 write_addr=5'b00011;
	write_data=16'b0000_0000_0000_0000;

	#4 write_addr=5'b00100;
	write_data=16'b1111_0000_0000_0000;

	#4 read_enable=1;
     write_enable=0;
     read_addr=5'b00000;
	#4 read_addr=5'b00001;		
	#4 read_addr=5'b00010;
	#4 read_addr=5'b00011;
	#4 read_addr=5'b00100;
end

always begin
#2 clk= !clk;
end
endmodule

