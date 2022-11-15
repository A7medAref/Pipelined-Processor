module reg_file (
    input[2:0] read_addr,
    input[2:0] write_addr,
    input[15:0] write_data,
    input reg_write,
    output reg[15:0] read_data,
    input clk
);
    reg[15:0] data[7:0];
    always @(negedge clk) begin
        if(reg_write) begin
            data[write_addr] = write_data;
        end
    end
    always @(posedge clk) begin 
        read_data = data[read_addr];
    end
endmodule