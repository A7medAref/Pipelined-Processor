module control_unit(
    input clk,
    input[4:0] opcode,
    output reg mem_read,
    output reg mem_write,
    output reg[3:0] alu_operation,
    output reg wb,
    output reg destination_alu_select,
    
    output reg mem_read_buf,
    output reg mem_write_buf,
    output reg mem_read_buf2,
    output reg mem_write_buf2,
    output reg mem_read_buf3,
    
    output reg[3:0] alu_operation_buf,
    output reg wb_buf,
    output reg wb_buf2,
    output reg wb_buf3,
    output reg destination_alu_select_buf,

    output reg push_signal,
    output reg pop_signal,
    output reg in_port_signal,
    output reg out_port_signal,
    output reg immediate_signal,
    output reg[2:0] jump_type_signal,
    output reg oneOperand
);

    always @(negedge clk) begin
        // Buffering the data before changing
        mem_read_buf3 = mem_read_buf2;
        mem_read_buf2 = mem_read_buf;
        mem_write_buf2 = mem_write_buf;
        wb_buf3 = wb_buf2;
        wb_buf2 = wb_buf;
        
        mem_read_buf = mem_read;
        mem_write_buf = mem_write;

        alu_operation_buf = alu_operation;
        wb_buf = wb;
        destination_alu_select_buf = destination_alu_select;
    end

    wire isNot, isInc, isDec;
    assign isNot = (opcode == 3);
    assign isInc = (opcode == 4);
    assign isDec = (opcode == 5);

    always @(posedge clk) begin 
        // calculating the values of the current instruction stage.        
        mem_read = 0;
        mem_write = 0;
        alu_operation = 0;
        push_signal = 0;
        pop_signal = 0;
        in_port_signal = 0;
        out_port_signal = 0;
        immediate_signal = 0;
        jump_type_signal = 0;

        oneOperand = (isNot | isInc | isDec) ? 1 : 0;

        if (opcode == 1) // SETC
            alu_operation = 11;
        else if(opcode == 2) // CLRC
            alu_operation = 12;
        else if(isNot) // NOT
            alu_operation = 1;
        else if(isInc) // INC
            alu_operation = 2;
        else if(isDec) // DEC
            alu_operation = 3;
        else if(opcode == 6) // IN
            in_port_signal = 1;
        else if(opcode == 7) // OUT
            out_port_signal = 1;
        else if(opcode == 8) // PUSH
            push_signal = 1;
        else if(opcode == 9) // POP
            pop_signal = 1;
        else if(opcode == 10) // LOAD
            mem_read = 1;
        else if(opcode == 12) // STORE
            mem_write = 1;
        else if(opcode == 13) begin // LOAD_IMMEDIATE
            mem_read = 1;
            immediate_signal = 1;
        end
        else if(opcode == 24) // MOV
            alu_operation = 4; 
        else if(opcode == 25) // ADD
            alu_operation = 5;
        else if(opcode == 26) // SUB
            alu_operation = 6;
        else if(opcode == 28) // AND
            alu_operation = 7;
        else if(opcode == 29) // OR
            alu_operation = 8;
        else if(opcode == 30) begin // SHL
            alu_operation = 9;
            immediate_signal = 1;
        end
        else if(opcode == 31) begin // SHR
            alu_operation = 10;
            immediate_signal = 1;
        end
        else if(opcode == 16) // JZ
            jump_type_signal = 2;
        else if(opcode == 17) // JN
            jump_type_signal = 3;
        else if(opcode == 18) // JC
            jump_type_signal = 4;
        else if(opcode == 19) // JMP
            jump_type_signal = 1;
        // CALL , RET , RETI will be implemented


        // may be change if we added mem_read to signal that doesn't write back
        wb = alu_operation != 0 || mem_read; 



    end
endmodule