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
        write_data_fm=16'b01000_001_010_11111; // push r1

        #100 rst_fm=0;

        #100 write_enable_fm=1;        

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b01001_010_111_11111; // pop r2

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b00001_000_000_11111; // setc

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b11001_111_001_11111; // Add r4, r1 => register1 = 1+1

        //////////////////////////////////////
        // Load interrupt program
        #100 write_addr_fm=0;
        write_data_fm=16'b01100_001_010_11111; // Std r1, r2 => address 2 contains 1

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b01010_010_100_11111; // ldd r2, r4 => register4 = 1

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b11001_100_001_11111; // Add r4, r1 => register1 = 1+1

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b10110_100_001_11111; // RTI



        #100
        reset = 1;
        #100
        reset = 0;
        #100 write_enable_fm=0;
        #300 interrupt=1;
        #100 interrupt=0;
    end

    always #50 begin
        clk = ~clk;
    end
endmodule

// STD R1, R2
// ADD R1, R2
// NOT R3
// NOP
// LDD R2, R7

// result changed
// R2 = 3, R3 = 1111_1111_1111_1100 , R7 = 2
// MEMORY (WITH LOCATION 010) = 1 
