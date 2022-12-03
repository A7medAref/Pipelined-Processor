module wb_stage(input clk, input mem_read, input[15:0] memory_data_output, input[15:0] alu_output, output[15:0] result);
    assign result = mem_read ? memory_data_output : alu_output;
endmodule