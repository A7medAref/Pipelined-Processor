module pipelinedProcessor(
	input clk,
    input reset,
	input [2:0] write_addr,
	input [15:0] write_data,
	input write_en,
    output [15:0] result,
    // fetch module only
    input write_enable_fm,
    input rst_fm,
    input[15:0] write_data_fm,
    input[31:0] write_addr_fm);

    wire mem_read_buf;
    wire mem_write_buf;
    wire [15:0] read_data1_buf;
    wire [15:0] read_data2_buf;
    wire [15:0] immediateValue;
    wire [1:0] alu_operation_buf;
    wire destination_alu_select_buf;
    wire wb_buf;
    
    wire [15:0] instruction;
    fetchInstructionModule fim_45185(write_enable_fm, instruction, write_data_fm, clk, rst_fm, write_addr_fm);

    decodingStage ds_1331(
        clk,
        reset,
        write_addr,
        write_data,
        instruction,
        write_en,

        mem_read_buf,
        mem_write_buf,
        read_data1_buf,
        read_data2_buf,
        immediateValue, 
        alu_operation_buf,
        destination_alu_select_buf,
        wb_buf
        );

    ALU_stage alu_module(clk, mem_read_buf, mem_write_buf, read_data1_buf,
                    read_data2_buf, immediateValue, alu_operation_buf,
                    destination_alu_select_buf, write_addr, wb_buf, result);

endmodule