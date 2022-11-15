module control_unit(
    input[2:0] opcode,
    input clk,
    output reg mem_read,
    output reg mem_write,
    output reg[1:0] alu_operation,
    output reg wb
);
    always @(posedge clk) begin 
        mem_read = (opcode == 1); // load
        mem_write = (opcode == 2); // store
        alu_operation = (opcode == 3 /*add*/) ? 0 :
                        (opcode == 4 /*not*/) ? 1 : 2 /*NOP*/;
        wb = (opcode == 1 || alu_operation != 2);
    end
endmodule
