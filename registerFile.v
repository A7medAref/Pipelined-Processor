module reg_file (
    input clk,
    input reset, //for testing purposes.
    input oneOperand,
    input mem_write,
    input[2:0] read_addr1,
	input[2:0] read_addr2,
    input[15:0] write_data,
    input reg_write,
    output reg[15:0] read_data1,
    output reg[15:0] read_data1_buf,
	output reg[15:0] read_data2,
	output reg[15:0] read_data2_buf,
	output reg[15:0] read_data2_buf2,
    input [4:0] opcode,
    output reg[2:0] reg1_buf1,
    output reg[2:0] reg2_buf1,
    output reg[2:0] reg2_buf2,
    output reg[2:0] reg2_buf3
    );
    reg[15:0] data[7:0];
    reg [2:0] write_addr_buf1, write_addr_buf2, write_addr_buf3;
    wire singleOperand;
    assign singleOperand = (opcode == 3 | opcode == 4 | opcode == 5 | opcode == 14 | opcode == 30 | opcode == 31);
    
    
    ////////////////////////////
    // for testing purposes
    integer i;
    always @(reset) begin
        if (reset) begin
            for (i = 0; i<8; i=i+1) begin
                data[i] = i;
            end
        end
    end
    ////////////////////////////

    always @(posedge clk) begin
        if(reg_write) begin
            data[write_addr_buf3] = write_data;
            $display("data written at that register %d ,data is %d ,data stored is %d", write_addr_buf3, write_data, data[write_addr_buf3]);
        end
        write_addr_buf3 = write_addr_buf2;
        write_addr_buf2 = write_addr_buf1;
        write_addr_buf1 = singleOperand ? read_addr1 : read_addr2;
    end


    always @(negedge clk) begin
        // buffering
        read_data2_buf2 = read_data2_buf;
        read_data2_buf = read_data2;
        read_data1_buf = read_data1;
        read_data1 = data[read_addr1];

        reg2_buf3 = reg2_buf2;
        reg2_buf2 = reg2_buf1;
        reg2_buf1 = oneOperand ? read_addr1 : read_addr2;
        
        reg1_buf1 = read_addr1;


        if(mem_write) begin
            read_data1 = data[read_addr2];
            read_data2 = data[read_addr1];
        end         
        else if(oneOperand == 1)
            read_data2 = read_data1;
        else
            read_data2 = data[read_addr2];
    end
endmodule