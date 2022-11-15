module decodingStage(
	input clk,
	input [15:0] write_addr,
	input [15:0] write_data,
	input [15:0] instruction,
	input write_en,
	output [15:0] read_data1,
	output [15:0] read_data2
);

reg_file(clk, 
instruction[12:10],
instruction[9:7],
write_addr,
write_data, 
write_en,
read_data1,
read_data2);

endmodule