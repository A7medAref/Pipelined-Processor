module decode_alu_stages_tb;
	reg clk, reset;
	reg [2:0] write_addr;
	reg [15:0] write_data;
	reg [15:0] instruction;
	reg write_en;
    wire [15:0] result;

decodingStage ds(
    clk,
    reset,
	write_addr,
	write_data,
	instruction,
	write_en,
    result);

    initial begin
        reset = 1;
        #50
        reset = 0;
        #50
        clk=0;
        instruction = 16'b0110010110111111;
        write_addr = 0;
        write_data = 1;
        write_en = 0;
        #50
        clk=0;
        instruction = 16'b0010010110111111;
    end

    always #50 begin
        clk = ~clk;
    end
endmodule