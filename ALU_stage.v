module ALU_stage (input clk, input mem_read, input mem_write, input[15:0] register_content1,
                input[15:0] register_content2, input[7:0] immediate_value, input[1:0] alu_control_signal,
                input alu_src_signal, input[2:0] write_address, input write_back,
                /*can be removed ==> only exist for testing*/ output reg[15:0] result);
    
    wire carry, zero, neg;
    wire [15:0] out;
    wire[15:0] second_oper;
    assign second_oper = (alu_src_signal == 1) ? 
        /*sign extend*/{{8{immediate_value[7]}}, {immediate_value[7:0]}} 
        : register_content2;

    // Buffers defination
    reg mem_read_buf, mem_write_buf, write_back_buf;
    reg[15:0] result_buf;
    reg[2:0] write_address_buf;

    ALU alu_1(register_content1, second_oper, alu_control_signal, out, carry, zero, neg);
    // Not ready yet (waiting for the next stage requirement)
    always @(posedge clk) begin
        // Buffering
        mem_read_buf = mem_read;
        mem_write_buf = mem_write;
        result_buf = result;
        write_address_buf = write_address;
        write_back_buf = write_back;


        result = out;
    end
endmodule
