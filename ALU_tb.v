module Testing;
    localparam W = 16;
    reg [15:0] in1, in2;
    reg [3:0] controlSignal;
    wire [15:0] result;

    wire carry, zero, neg;
    ALU tb1(in1, in2, controlSignal, result, carry, zero, neg);

    initial begin
        controlSignal = 0;
        in1 = 1;
        in2 = 5;
        #50
        controlSignal = 5;
        in1 = -1;
        in2 = -5;
        #50
        in1 = 20;
        in2 = 30;
        controlSignal = 2;
        #50
        controlSignal = 1;
        in2 = 16'b1111111111111111;
        #50
        controlSignal = 2;
        in1 = 5;
        #50
        controlSignal = 3;
        in1 = 10;
        #50
        controlSignal = 4;
        in1 = 100;
        #50        
        controlSignal = 6;
        in1 = 3;
        in2 = 10;
        #50
        in1 = 10;
        in2 = 3;
        #50
        controlSignal = 7;
        in1 = 10;
        in2 = 5;
        #50
        controlSignal = 8;
        #50;
        controlSignal = 11;
        #50;
        controlSignal = 12;
        #50;
        controlSignal = 2;
        in1 = 16'b1111111111111110;

    end
endmodule