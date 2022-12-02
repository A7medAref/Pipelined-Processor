module reg_file (
    input clk,
    input reset, //for testing purposes.
    input[2:0] read_addr1,
	input[2:0] read_addr2,
    input[2:0] write_addr,
    input[15:0] write_data,
    input reg_write,
    output reg[15:0] read_data1,
	output reg[15:0] read_data2,

    output reg[15:0] read_data1_buf,
	output reg[15:0] read_data2_buf,

    // To see the registers easier
    output[15:0] data_test0,
    output[15:0] data_test1,
    output[15:0] data_test2,
    output[15:0] data_test3,
    output[15:0] data_test4,
    output[15:0] data_test5,
    output[15:0] data_test6,
    output[15:0] data_test7
);
    reg[15:0] data[7:0];

    ////////////////////////////
    // for testing purposes
    assign data_test0 = data[0];
    assign data_test1 = data[1];
    assign data_test2 = data[2];
    assign data_test3 = data[3];
    assign data_test4 = data[4];
    assign data_test5 = data[5];
    assign data_test6 = data[6];
    assign data_test7 = data[7];
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
        // buffering
        read_data1_buf = read_data1;
        read_data2_buf = read_data2;

        if(reg_write) begin
            data[write_addr] = write_data;
        end
    end
    always @(negedge clk) begin 
        read_data1 = data[read_addr1];
		read_data2 = data[read_addr2];
    end
endmodule