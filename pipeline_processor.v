module pipelinedProcessor(
	input clk,
    input reset,
	input [2:0] write_addr,
    output [15:0] wb_output,
    // fetch module only
    input write_enable_fm,
    input rst_fm,
    input[15:0] write_data_fm,
    input[31:0] write_addr_fm,
    // can be removed
    output [15:0] instruction,
    output show_1bit,
    output [15:0] show
);


    wire [15:0] memory_data_output;
    wire [15:0] result_buf;
    wire [15:0] result_buf2;    
    
    wire mem_read_buf, mem_write_buf, mem_read_buf2, mem_write_buf2, mem_read_buf3;
    
    wire [15:0] read_data1_buf;
    wire [15:0] read_data1_buf2;
    wire [15:0] read_data2_buf;
    wire [15:0] read_data2_buf2;
    wire [15:0] immediateValue;
    wire [3:0] alu_operation_buf;
    wire destination_alu_select_buf;
    wire wb_buf, wb_buf2, wb_buf3;
    wire reg1_buf1, reg1_buf2;
    wire reg2_buf1, reg2_buf2;

    /////////////////// should be inputs for the next stage
    wire push_signal;
    wire pop_signal;
    wire in_port_signal;
    wire out_port_signal;
    wire immediate_signal;
    ////////////////////
    wire[1:0] jump_type_signal;
    wire jump_occured;
    // testing
    assign show = result_buf;
    assign show_1bit = alu_operation_buf;

    wire[15:0] jump_to;
    wire[15:0] register1_content, register2_content;
    wire[1:0] alu_input1_selection, alu_input2_selection;

    fetchInstructionModule fim_45185(write_enable_fm, instruction, write_data_fm, clk, rst_fm, write_addr_fm, jump_occured, read_data1_buf2);

    decodingStage ds_1331(
        clk,
        reset,
        write_addr,
        wb_output,
        instruction,
        
        // Needs another buffering
        mem_read_buf,
        mem_write_buf,
        mem_read_buf2,
        mem_write_buf2,
        mem_read_buf3,
        read_data1_buf,
        read_data1_buf2,
        read_data2_buf,
        read_data2_buf2,
        /////////////////////

        immediateValue,
        alu_operation_buf,
        destination_alu_select_buf,
        wb_buf,
        wb_buf2,
        wb_buf3,
        //////////////////////// new signals phase 2
        push_signal,
        pop_signal,
        in_port_signal,
        out_port_signal,
        immediate_signal,

        jump_type_signal,

        reg1_buf1,
        reg1_buf2,
        reg2_buf1,
        reg2_buf2
        );

    forwardingUnit fu(
        clk,
        wb_buf2,
        wb_buf3,
        instruction[7:5],
        instruction[10:8],
        reg2_buf1,
        reg2_buf2,
        alu_input1_selection,
        alu_input2_selection
    );

    aluInputSelection ais(
        clk,
        alu_input1_selection,
        alu_input2_selection,
        result_buf,
        result_buf2,
        read_data1_buf,
        read_data2_buf,
        register1_content,
        register2_content
    );
    
    ALU_stage alu_1839
    (
        clk,
        register1_content,
        register2_content,
        immediateValue, 
        alu_operation_buf,
        destination_alu_select_buf,
        result_buf,
        result_buf2,
        jump_type_signal,
        jump_occured
    );

    dataMemory dm_1438(mem_read_buf2, mem_write_buf2, memory_data_output,
                        read_data2_buf2, clk, 0/*rst*/, result_buf/*address come from alu*/,
                        result_buf);

    wb_stage wb_85915(clk, mem_read_buf3, memory_data_output, result_buf2, wb_output);
endmodule
/*
Add r1 , r2
Add r2 , r1

F D E M W
  F D E M W
    F D E M W
*/