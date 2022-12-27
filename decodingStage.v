module decodingStage(
	input clk,
    input reset,
	input [2:0] write_addr,
	input [15:0] write_data,
	input [15:0] instruction,
    output mem_read_buf,
    output mem_write_buf,
    // buffering for memory stage
    output mem_read_buf2,
    output mem_write_buf2,
    output mem_read_buf3,

    output [15:0] read_data1,
    output [15:0] read_data1_buf,
    output [15:0] read_data2,
    output [15:0] read_data2_buf,

    output [3:0] alu_operation_buf,
    output destination_alu_select_buf,
    
    output wb_buf,
    output wb_buf2,
    output wb_buf3,

    output push_signal,
    output pop_signal,
    output in_port_signal,
    output out_port_signal,
    output[1:0] jump_type_signal,
    input jump_occured,
    output[2:0] reg1_buf1,
    output[2:0] reg2_buf1,
    output[2:0] reg2_buf2,
    output[2:0] reg2_buf3
    );

// Just to remove warning
wire [2:0] reg1, reg2;
wire [4:0] opcode;
///////////////////////////
// To be simple to use
assign opcode = instruction[15:11];
assign reg1 = instruction[10:8];
assign reg2 = instruction[7:5];

wire mem_read, mem_write;

wire[3:0] alu_operation;
wire wb, destination_alu_select;
wire oneOperand;

wire [15:0] read_data2_buf2;


// Register file that contains the registers
reg_file rf(clk, 
            reset/*For testing purpses*/, 
            oneOperand, 
            mem_write, 
            reg1,
            reg2,
			write_data, 
            wb_buf3, 
            read_data1,
            read_data1_buf, 
            read_data2, 
            read_data2_buf, 
            read_data2_buf2,
            opcode,
            reg1_buf1,
            reg2_buf1,
            reg2_buf2,
            reg2_buf3
            );

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
    destination_alu_select_buf,
    
    push_signal,
    pop_signal,
    in_port_signal,
    out_port_signal,
    oneOperand,
    jump_type_signal,
    jump_occured
);
endmodule