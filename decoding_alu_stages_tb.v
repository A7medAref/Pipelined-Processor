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
    reg[15:0] in_port;
    wire[15:0] out_port;

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
        interrupt,
        in_port,
        out_port);

    initial begin
        ////////////////////// LOADING THE PROGRAM
        clk=1;
        interrupt=0;
        rst_fm=1;
        in_port=10;
        #100 rst_fm=0;
        #100 write_enable_fm=1;
        #200
        reset = 1;
        #100
        reset = 0;
        #100 write_enable_fm=0;
        #450 interrupt=1;
        #100 interrupt=0;
    end

    always #50 begin
        clk = ~clk;
    end
endmodule
