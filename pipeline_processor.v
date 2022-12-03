module pipelinedProcessor(
	input clk,
    input reset,
	input [2:0] write_addr,
	input [15:0] write_data,
	input write_en,
    output [15:0] wb_output,
    // fetch module only
    input write_enable_fm,
    input rst_fm,
    input[15:0] write_data_fm,
    input[31:0] write_addr_fm,
    // can be removed
    output [15:0] instruction,
    output show_1bit,
    output [15:0] show);


    wire [15:0] memory_data_output;
    wire [15:0] result_buf;
    wire [15:0] result_buf2;    
    
    wire mem_read_buf, mem_write_buf, mem_read_buf2, mem_write_buf2, mem_read_buf3;
    
    wire [15:0] read_data1_buf;
    wire [15:0] read_data2_buf;
    wire [15:0] read_data2_buf2;
    wire [15:0] immediateValue;
    wire [2:0] alu_operation_buf;
    wire destination_alu_select_buf;
    wire wb_buf, wb_buf2, wb_buf3;

    // testing
    assign show = result_buf;
    assign show_1bit = alu_operation_buf;


    fetchInstructionModule fim_45185(write_enable_fm, instruction, write_data_fm, clk, rst_fm, write_addr_fm);

    decodingStage ds_1331(
        clk, reset, write_addr, write_data, instruction, write_en,
        
        // Needs another buffering
        mem_read_buf, mem_write_buf, mem_read_buf2, mem_write_buf2, mem_read_buf3, read_data1_buf, read_data2_buf, read_data2_buf2,
        /////////////////////

        immediateValue, alu_operation_buf, destination_alu_select_buf,

        wb_buf, wb_buf2, wb_buf3
        );

    ALU_stage alu_1839(clk, read_data1_buf,
                    read_data2_buf, immediateValue, alu_operation_buf,
                    destination_alu_select_buf, result_buf, result_buf2);
    dataMemory dm_1438(mem_read_buf2, mem_write_buf2, memory_data_output,
                        read_data2_buf2, clk, 0/*rst*/, result_buf/*address come from alu*/,
                        result_buf);

    wb_stage wb_85915(clk, mem_read_buf3, memory_data_output, result_buf2, wb_output);
endmodule