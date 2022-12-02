module decodingStage(
	input clk,
    input reset,
	input [2:0] write_addr,
	input [15:0] write_data,
	input [15:0] instruction,
	input write_en,
    // output [15:0] result,
    output [7:0] immediateValue,
    output mem_read_buf,
    output mem_write_buf,
    output [1:0] alu_operation_buf,
    output [15:0] read_data1_buf,
    output [15:0] read_data2_buf,
    output wb_buf,
    output destination_alu_select_buf,
    // for testing purposes
    output[15:0] data_test0,
    output[15:0] data_test1,
    output[15:0] data_test2,
    output[15:0] data_test3,
    output[15:0] data_test4,
    output[15:0] data_test5,
    output[15:0] data_test6,
    output[15:0] data_test7
    );

// Just to remove warning
wire [2:0] reg1, reg2, opcode;
// // wire[7:0] immediateValue;

///////////////////////////
// To be simple to use
// opcode   src     dst     immediate_value
// 000      000     000     1234567
assign opcode = instruction[15:13];
assign reg1 = instruction[12:10];
assign reg2 = instruction[9:7];

// assumsion
assign immediateValue = instruction[7:0];
///////////////////////////

wire mem_read, mem_write;
// // mem_read_buf, mem_write_buf;

wire[1:0] alu_operation;
// alu_operation_buf;

wire wb, destination_alu_select;
// wb_buf, destination_alu_select_buf

wire [15:0] read_data1, read_data2;
// wire [15:0] read_data1_buf, read_data2_buf;

// Register file that contains the registers
reg_file rf(clk, reset/*For testing purpses*/, reg1, reg2, write_addr,
			write_data, write_en, read_data1, read_data2, read_data1_buf, read_data2_buf,
            // testing
            data_test0, data_test1, data_test2, data_test3,
            data_test4, data_test5, data_test6, data_test7);

// The control unite responsible for generating the signals
control_unit cu(
    clk,
    opcode,
    mem_read,
    mem_write,
    alu_operation,
    wb,
    destination_alu_select,
    mem_read_buf,
    mem_write_buf,
    alu_operation_buf,
    wb_buf,
    destination_alu_select_buf
);

endmodule