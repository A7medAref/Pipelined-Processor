module decodingStage(
	input clk,
    input reset,
	input [2:0] write_addr,
	input [15:0] write_data,
	input [15:0] instruction,
	input write_en,
    output mem_read_buf,
    output mem_write_buf,
    // buffering for memory stage
    output mem_read_buf2,
    output mem_write_buf2,
    output mem_read_buf3,

    output [15:0] read_data1,
    output [15:0] read_data2,
    output [15:0] read_data2_buf,

    output [15:0] immediateValue, 
    output [2:0] alu_operation_buf,
    output destination_alu_select_buf,
    
    output wb_buf,
    output wb_buf2,
    output wb_buf3);

// Just to remove warning
wire [2:0] reg1, reg2, opcode;
// wire[7:0] immediateValue;
///////////////////////////
// To be simple to use
assign opcode = instruction[15:13];
assign reg1 = instruction[12:10];
assign reg2 = instruction[9:7];

// assumsion
assign immediateValue = instruction[7:0];
///////////////////////////

wire mem_read, mem_write;
//--mem_read_buf, mem_write_buf;

wire[2:0] alu_operation;
// alu_operation_buf;
wire wb, destination_alu_select;
// wb_buf, destination_alu_select_buf

// Register file that contains the registers
reg_file rf(clk, reset/*For testing purpses*/, reg1, reg2, write_addr,
			write_data, write_en, read_data1, read_data2, read_data2_buf);



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
    mem_read_buf2,
    mem_write_buf2,
    mem_read_buf3,
    alu_operation_buf,
    wb_buf,
    wb_buf2,
    wb_buf3,
    destination_alu_select_buf
);
endmodule