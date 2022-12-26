module ALU_stage 
(
    input clk, 
    input[15:0] register_content1,
    input[15:0] register_content2, 
    input[7:0] immediate_value, 
    input[3:0] alu_control_signal,
    input [2:0] jump_type,
    input alu_src_signal, 
    output reg[15:0] result_buf, 
    output reg[15:0] result_buf2 ,   
    output reg[2:0] CCR_buf1 , //TODO:
    output reg[2:0] CCR_buf2, //TODO:
    output reg jump_occur
);

    wire carry, zero, neg;
    wire [15:0] out;
    reg[15:0] result;
    reg[2:0] CCR, // TODO:
    wire is_jump_occur;
    
    ALU alu_1(register_content1, register_content2, alu_control_signal, out, carry, zero, neg);


    always @(negedge clk) begin
        // buffering
        result_buf2 = result_buf;
        result_buf = result;
        CCR_buf1 = CCR;
        CCR_buf2 = CCR_buf1;
    end

    always @(posedge clk) begin
        result = out;
        CCR = {carry , zero , neg};
        jump_occur = is_jump_occur;
    end
endmodule
