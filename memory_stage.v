module memory_stage (input clk, input mem_read, input mem_write,
                     input[2:0] write_address, input write_back,
                     input[15:0] data);
    wire[15:0] read_data;
    dataMemory dm(mem_read, mem_write, read_data,write_data,clk,rst,read_addr,write_addr);
endmodule