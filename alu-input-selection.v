module aluInputSelection (
    input clk,
    input[1:0] alu_input1_selection,
    input[1:0] alu_input2_selection,
    input[15:0] alu_result,
    input[15:0] mem_result,
    input[15:0] register1_data,
    input[15:0] register2_data,
    output reg[15:0] register1_content,
    output reg[15:0] register2_content
);
    always @(posedge clk) begin
        if(alu_input1_selection == 0)
            register1_content = register1_data;
        else if(alu_input1_selection == 1)
            register1_content = alu_result;
        else if(alu_input1_selection == 2)
            register1_content = mem_result;
        else
            register1_content = 0;
        if(alu_input2_selection == 0)
            register2_content = register2_data;
        else if(alu_input2_selection == 1)
            register2_content = alu_result;
        else if(alu_input2_selection == 2)
            register2_content = mem_result;
        else
            register2_content = 0;
    end
    
endmodule