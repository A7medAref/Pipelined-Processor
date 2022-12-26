module ALU#(parameter N=16) (input[N-1:0] in_src, input[N-1:0] in_dst, input[3:0] controlSignal, 
            output[N-1:0] out, output carryFlay, output zeroFlag, output negFlag);
    assign {carryFlay, out} = (controlSignal == 1) ? ~in_src :
                              (controlSignal == 2) ? (in_src + 1) :
                              (controlSignal == 3) ? (in_src - 1) : 
                              (controlSignal == 4) ? in_dst :
                              (controlSignal == 5) ? (in_src + in_dst) :
                              (controlSignal == 6) ? (in_src - in_dst) :
                              (controlSignal == 7) ? (in_src & in_dst) :
                              (controlSignal == 8) ? (in_src | in_dst) :
                              (controlSignal == 9) ? (in_src) :// TODO: need immediate value
                              (controlSignal == 10) ? (in_src) :// TODO: need immediate value
                              (controlSignal == 11) ? {1 , out} :
                              (controlSignal == 12) ? {0 , out} :
                              (controlSignal == 13) ? {0, in_src} : // TODO: control signal hasn't been sent
                              (controlSignal == 14) ? {0, in_src} : {carryFlay, out}; // TODO: control signal hasn't been sent
// 2=ldd , 3=std,==> pass in_src
    assign zeroFlag = (controlSignal != 3) ? !(|out) ? 1 : 0 :
                            zeroFlag;
    assign negFlag = (controlSignal != 3) ? out[N-1] : negFlag;
endmodule
