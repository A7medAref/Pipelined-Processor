module aa_pipe_tb;

    wire[15:0] data_test0, data_test1, data_test2, data_test3,
            data_test4, data_test5, data_test6, data_test7;

	reg clk, reset;
	reg [15:0] instruction;
    wire[15:0] result;
    
    pipelined_processor ds(
        clk,
        reset,
        instruction,
        data_test0, data_test1, data_test2, data_test3,
        data_test4, data_test5, data_test6, data_test7,
        result
    );

    initial begin
        reset = 1;
        #50
        reset = 0;
        #50
        clk=0;
        instruction = 16'b0110010110111111;
        #50
        clk=0;
        instruction = 16'b0010010110111111;
    end

    always #50 begin
        clk = ~clk;
    end
endmodule