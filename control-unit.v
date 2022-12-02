module control_unit(
    input clk,
    input[2:0] opcode,
    output reg mem_read,
    output reg mem_write,
    output reg[1:0] alu_operation,
    output reg wb,
    output reg destination_alu_select,
    
    output reg mem_read_buf,
    output reg mem_write_buf,
    output reg[1:0] alu_operation_buf,
    output reg wb_buf,
    output reg destination_alu_select_buf
);

    always @(posedge clk) begin 
        // Buffering the data before changing
        mem_read_buf = mem_read;
        mem_write_buf = mem_write;
        alu_operation_buf = alu_operation;
        wb_buf = wb;
        destination_alu_select_buf = destination_alu_select;

        // calculating the values of the current instruction stage.        
        mem_write = (opcode == 2); // store
        alu_operation = (opcode == 3 /*add*/) ? 0 :
                        (opcode == 4 /*not*/) ? 1 : 3 /*NOP*/;
        if (opcode == 1) begin
            mem_read = 1;
            alu_operation = 2; /*pass the destination as a result*/
            destination_alu_select = 1;
        end else begin
            mem_read = 0;
            destination_alu_select = 0;
        end

        wb = (opcode == 1 || alu_operation != 3);
    end
endmodule
