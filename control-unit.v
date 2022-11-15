module control_unit(
    input clk,
    input[2:0] opcode,
    output reg mem_read,
    output reg mem_write,
    output reg[1:0] alu_operation,
    output reg wb,
    
    output reg mem_read_buf,
    output reg mem_write_buf,
    output reg[1:0] alu_operation_buf,
    output reg wb_buf
);

    always @(posedge clk) begin 
        // Buffering the data before changing
        mem_read_buf = mem_read;
        mem_write_buf = mem_write;
        alu_operation_buf = alu_operation;
        wb_buf = wb; 

        // calculating the values of the current instruction stage.        
        mem_read = (opcode == 1); // load
        mem_write = (opcode == 2); // store
        alu_operation = (opcode == 3 /*add*/) ? 0 :
                        (opcode == 4 /*not*/) ? 1 : 2 /*NOP*/;
        wb = (opcode == 1 || alu_operation != 2);
    end
endmodule
