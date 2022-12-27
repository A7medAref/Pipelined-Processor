module ALU_stage (
    input clk, 
    input[15:0] register_content1,
    input[15:0] register_content2, 
    input[3:0] alu_control_signal,
    input alu_src_signal, 
    output reg[15:0] result_buf, 
    output reg[15:0] result_buf2 ,   
    input[1:0] jump_type_signal,
    output reg jump_occured,
    // The immediate value after fetching
    input[15:0] instruction,
    input wb1,
    input wb2,

    input[2:0] reg1_buf1,
    input[2:0] reg2_buf1,
    input[2:0] reg2_buf2,
    input[2:0] reg2_buf3,
    input[15:0] memory_data_output_load_case,
    input mem_read_load_case
);

    wire carry, zero, neg;
    wire [15:0] out;
    reg[15:0] result;

    reg[2:0] flags, flags_buffered;

    ALU alu_1(  register_content1, 
                register_content2, 
                alu_control_signal,
                out, 
                carry, 
                zero, 
                neg,
                instruction,
                wb1,
                wb2,
                result_buf,
                result_buf2,
                reg1_buf1,
                reg2_buf1,
                reg2_buf2,
                reg2_buf3,
                memory_data_output_load_case,
                mem_read_load_case
                );


    always @(negedge clk) begin
        // Buffering
        result_buf2 = result_buf;
        result_buf = result;
        flags_buffered = flags;
    end

    always @(posedge clk) begin
        // $display("loading= %b alu_operation= %d", load_case, alu_control_signal);

        result = out;
        flags = {carry , zero , neg};
        jump_occured = (jump_type_signal == 1 && flags_buffered[1]) ||
        (jump_type_signal == 2 && flags_buffered[0])||
        (jump_type_signal == 3 && flags_buffered[2]);
    end
endmodule
