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
    input mem_write1,
    input mem_write2,
    
    input[2:0] reg1_buf1,
    input[2:0] reg2_buf1,
    input[2:0] reg2_buf2,
    input[2:0] reg2_buf3,
    input[15:0] memory_data_output_load_case,
    input mem_read,
    input mem_read_load_case,
    output reg[2:0] flags_buffered,
    output [2:0] saveStateCounter, 
    output [2:0] stateType,
    input[15:0] fetchWithMemoryDataBus
);

    wire carry, zero, neg;
    wire [15:0] out;
    reg[15:0] result;

    reg[2:0] flags;

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
                mem_write1,
                mem_write2,
                result_buf,
                result_buf2,
                reg1_buf1,
                reg2_buf1,
                reg2_buf2,
                reg2_buf3,
                memory_data_output_load_case,
                mem_read,
                mem_read_load_case
                );


    always @(negedge clk) begin
        // Buffering
        result_buf2 = result_buf;
        result_buf = result;
        flags_buffered = flags;
    end

    always @(posedge clk) begin
        // $display("wb1=%b wb2=%b mem_read=%b mem_write1=%b mem_write2=%b alu_operation=%d",
        //          wb1, wb2, mem_read, mem_write1, mem_write2, alu_control_signal);

        result = out;
        if(stateType==2 && saveStateCounter ==3)begin
            $display("Returning from interrupt with flags=%b", fetchWithMemoryDataBus);
            flags = fetchWithMemoryDataBus[2:0];
        end
        else
            flags = {carry , zero , neg};
        jump_occured = (jump_type_signal == 1 && flags_buffered[1]) ||
        (jump_type_signal == 2 && flags_buffered[0])||
        (jump_type_signal == 3 && flags_buffered[2]);
    end
endmodule
