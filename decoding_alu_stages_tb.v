module aa_pipe_tb;
	reg clk, reset;
	reg [2:0] write_addr;
	reg [15:0] write_data;
	reg [15:0] instruction;
	reg write_en;
    wire [15:0] result;


    reg rst_fm;
    reg[31:0] write_addr_fm;
    reg[15:0] write_data_fm;
    reg write_enable_fm;

    
    pipelinedProcessor pp_508251(
        clk,
        reset,
        write_addr,
        write_data,
        write_en,
        result,
        write_enable_fm,
        rst_fm,
        write_data_fm,
        write_addr_fm);

    initial begin
        ////////////////////// LOADING THE PROGRAM
        clk=1;
        rst_fm=1;
        write_addr_fm=32'b0000_0000_0000_0010_0000;
        write_data_fm=16'b0110010110111111;
        
        #50 rst_fm=0;
        
        #50 write_enable_fm=1;
        
        #50 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b0010010110111111;

        #50 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b0110010110111111;

        #50 write_enable_fm=0;


        //////////////////////
        #50
        reset = 1;
        #50
        reset = 0;
    end

    always #50 begin
        clk = ~clk;
    end
endmodule