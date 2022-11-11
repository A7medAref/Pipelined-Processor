module Testing;
    localparam W = 16;
    reg [15:0] in1, in2;
    reg controlSignal;
    wire [15:0] result;

    wire carry, zero, neg;
    ALU tb1(in1, in2, controlSignal, result, carry, zero, neg);

    initial begin
        controlSignal = 0;
        in1 = 1;
        in2 = 5;
        #50
        in1 = -1;
        in2 = -5;
        #50
        controlSignal = 1;
        in2 = 16'b1111111111111111;
    end
endmodule