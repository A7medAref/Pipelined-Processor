// (input clk, input[15:0] register_content1,
//                 input[15:0] register_content2, input[7:0] immediate_value, input[3:0] alu_control_signal,
//                 input alu_src_signal, output reg[15:0] result_buf, output reg[15:0] result_buf2);
module ALU_stage (
    input clk, 
    input[15:0] register_content1,
    input[15:0] register_content2, 
    input[7:0] immediate_value, 
    input[3:0] alu_control_signal,
    input alu_src_signal, 
    output reg[15:0] result_buf, 
    output reg[15:0] result_buf2 ,   
    
);

    wire carry, zero, neg;
    wire [15:0] out;
    reg[15:0] result;

    reg[2:0] flags, flags_buffered;

    ALU alu_1(register_content1, register_content2, alu_control_signal, out, carry, zero, neg, flags_buffered);

    always @(negedge clk) begin
        // Buffering
        result_buf2 = result_buf;
        result_buf = result;
        flags_buffered = flags;
    end

    always @(posedge clk) begin
        result = out;
        flags = {carry , zero , neg};
    end
endmodule
