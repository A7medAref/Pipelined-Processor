module forwardingUnit 
(
    input clk,
    input wb_buf1,
    input wb_buf2,
    input[2:0] instruction_src,
    input[2:0] instruction_dst,
    input[2:0] buf1_dst,
    input[2:0] buf2_dst,
    output[1:0] alu_input1_selection,
    output[1:0] alu_input2_selection
);
    // ins2 => buf2
    // ins1 => buf1
    // instruction
    always @(posedge clk) begin
        alu_input1_selection = 0; // 0 for default operand selection
        alu_input2_selection = 0;
        //  if ins2 is making write back
        if(wb_buf2) begin
            if(instruction_dst == buf2_dst)
                alu_input1_selection = 2; // 2 for memory selection
            if(instruction_src == buf2_dst)
                alu_input2_selection = 2;
        end
        if(wb_buf1) begin 
            if(instruction_dst == buf1_dst) 
                alu_input1_selection = 1; // 1 for alu selection
            if(instruction_src == buf1_dst)
                alu_input2_selection = 1;
        end
        // alu selection is overriding memory selection
    end
endmodule