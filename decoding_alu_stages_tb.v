// ALU TESTS
module aa_pipe_tb;
    reg clk, reset;
    reg [2:0] write_addr;
    reg write_en;
    wire [15:0] result;
    reg rst_fm;
    reg[31:0] write_addr_fm;
    reg[15:0] write_data_fm;
    reg write_enable_fm;
    wire [15:0] instruction;
    reg interrupt;
    pipelinedProcessor pp_508251(
        clk,
        reset,
        write_addr,
        result,
        write_enable_fm,
        rst_fm,
        write_data_fm,
        write_addr_fm,
        ////////////
        instruction,
        interrupt
        );

    initial begin
        ////////////////////// LOADING THE PROGRAM
        clk=1;
        interrupt=0;
        rst_fm=1;
        write_addr_fm=32'b0000_0000_0000_0010_0000;
        write_data_fm=16'b01110_001_00000000;

        #100 rst_fm=0;

        #100 write_enable_fm=1;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=60;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b00001_000_00000000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b10010_001_00000000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b01110_001_00000000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b000000000_1010000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b00100_010_00000000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b01100_001_010_00000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b01010_010_101_00000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b00100_101_00000000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b01000_101_00000000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b01001_111_00000000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b00100_111_00000000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b01110_000_00000000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b0000000000000_110;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b11001_000_000_00000;


        //////////////////////////////////////
        // Load interrupt program
        #100 write_addr_fm=60;
        write_data_fm=16'b01110_111_00000000;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b0000000000_100100;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b0;

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b10011_111_00000000;

        #100
        reset = 1;
        #100
        reset = 0;
        #100 write_enable_fm=0;
    end

    always #50 begin
        clk = ~clk;
    end
endmodule
