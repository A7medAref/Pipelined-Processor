module ALU_stage (input clk, input memRead, input memWrite, input[15:0] registerContent1,
                input[15:0] registerContent2, input[15:0] immediateValue, input[1:0] alu_control_signal,
                input alu_src_signal, input write_address, input write_back, output reg[15:0] result);
    
    wire carry, zero, neg;
    wire [15:0] out;
    wire[15:0] second_oper;
    assign second_oper = (alu_src_signal == 1) ? immediateValue : registerContent2;

    ALU tb1(registerContent1, second_oper, alu_control_signal, out, carry, zero, neg);

    always @(posedge clk) begin
        result = out;
    end
endmodule
