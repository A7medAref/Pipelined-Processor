module decodingStage(
	input clk,
    input reset,
	input [2:0] write_addr,
	input [15:0] write_data,
	input [15:0] instruction,
	input write_en,
    output [15:0] result);

wire [2:0] reg1, reg2, opcode;
assign opcode = instruction[15:13];
assign reg1 = instruction[12:10];
assign reg2 = instruction[9:7];

wire mem_read, mem_write, mem_read_buf, mem_write_buf;
wire[1:0] alu_operation, alu_operation_buf;
wire wb, wb_buf;


wire [15:0] read_data1, read_data2;
wire [15:0] read_data1_buf, read_data2_buf;

wire[15:0] temp_immediateValue;

reg_file rf(clk, reset, reg1, reg2, write_addr,
			write_data, write_en, read_data1, read_data2, read_data1_buf, read_data2_buf);

control_unit cu(
    clk,
    opcode,
    mem_read,
    mem_write,
    alu_operation,
    wb,
    mem_read_buf,
    mem_write_buf,
    alu_operation_buf,
    wb_buf
);

ALU_stage alu_module(clk, mem_read_buf, mem_write_buf, read_data1_buf,
                read_data2_buf, temp_immediateValue, alu_operation_buf,
                0/*temp till discussing immediate value*/, write_addr, wb, result);

endmodule