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
    wire mem_write;

    wire[15:0] show;

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
        mem_write,
        show);

    initial begin
        ////////////////////// LOADING THE PROGRAM
        clk=1;
        rst_fm=1;
        write_addr_fm=32'b0000_0000_0000_0010_0000;
        // write_data_fm=16'b11001_001_010_11111; // Add R1, R2
        write_data_fm=16'b00001_001_010_11111; // SETC
        
        #100 rst_fm=0;
        
        #100 write_enable_fm=1;
        
        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b10010_111_010_11111; // jump r3

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b01100_011_100_11111; // Std r3, r4
        
        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b00011_111_001_11101; // NOT r7

        #100 write_addr_fm=write_addr_fm+1;
        write_data_fm=16'b00011_111_001_11101; // NOT r7

        // #100 write_addr_fm=write_addr_fm+1;
        // write_data_fm=16'b00000_01110111111; // NOP

        // // #100 write_addr_fm=write_addr_fm+1;
        // write_data_fm=16'b00100_0_111_0111111; // LDD

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

// STD R1, R2
// ADD R1, R2
// NOT R3
// NOP
// LDD R2, R7

// result changed
// R2 = 3, R3 = 1111_1111_1111_1100 , R7 = 2
// MEMORY (WITH LOCATION 010) = 1 