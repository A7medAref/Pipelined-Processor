module pipelined_processor(
    input clk,
    // for now
    input [15:0] instruction,
    /////////////////////////////
    /*For reseting all registers*/
    input reset,
    output[15:0] data_test0,
    output[15:0] data_test1,
    output[15:0] data_test2,
    output[15:0] data_test3,
    output[15:0] data_test4,
    output[15:0] data_test5,
    output[15:0] data_test6,
    output[15:0] data_test7
    ////////////////////////// 
    );
    
    wire [2:0] write_addr;
    wire [15:0] write_data;
    //for now declared as input // instruction;
    wire write_en;
    wire[7:0] immediateValue;
    wire mem_read_buf, mem_write_buf;
    wire[1:0] alu_operation_buf;
    wire [15:0] read_data1_buf, read_data2_buf;
    wire wb_buf, destination_alu_select_buf;
    wire[15:0] result;

    // decodingStage ds_1235614(
	// clk,
    // reset,
	// write_addr,
	// write_data,
	// instruction,
	// write_en,
    // immediateValue,
    // mem_read_buf,
    // mem_write_buf,
    // alu_operation_buf,
    // read_data1_buf,
    // read_data2_buf,
    // wb_buf,
    // destination_alu_select_buf,
    // /////////////////////////////
    // // for testing
    // data_test0, data_test1, data_test2, data_test3,
    //         data_test4, data_test5, data_test6, data_test7
    // /////////////////////////////
    // );

    // ALU_stage alu_module(clk, mem_read_buf, mem_write_buf, read_data1_buf,
    //             read_data2_buf, immediateValue, alu_operation_buf,
    //             destination_alu_select_buf, write_addr, wb_buf, result);

endmodule