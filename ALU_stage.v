module ALU_stage (input clk, input[15:0] register_content1,
                input[15:0] register_content2, input[7:0] immediate_value, input[2:0] alu_control_signal,
                input alu_src_signal, output reg[15:0] result_buf, output reg[15:0] result_buf2);

    wire carry, zero, neg;
    wire [15:0] out;
    reg[15:0] result;
    
    ALU alu_1(register_content1, register_content2, alu_control_signal, out, carry, zero, neg);

    always @(negedge clk) begin
        // Buffering
        result_buf2 = result_buf;
        result_buf = result;
    end

    always @(posedge clk) begin
        result = out;
    end
endmodule
