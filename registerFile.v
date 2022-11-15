module reg_file (
    input clk,
    input[2:0] read_addr1,
	input[2:0] read_addr2,
    input[2:0] write_addr,
    input[15:0] write_data,
    input reg_write,
    output reg[15:0] read_data1,
	output reg[15:0] read_data2
);
    reg[15:0] data[7:0];
    always @(posedge clk) begin
        if(reg_write) begin
            data[write_addr] = write_data;
        end
    end
    always @(negedge clk) begin 
        read_data1 = data[read_addr1];
		read_data2 = data[read_addr2];
    end
endmodule