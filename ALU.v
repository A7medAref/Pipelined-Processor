module ALU#(parameter N=16) (input[N-1:0] in_src, input[N-1:0] in_dst, input[3:0] controlSignal, 
            output[N-1:0] out, output carryFlag, output zeroFlag, output negFlag, input[2:0] flags);
    wire is_alu;
    assign {carryFlag, out} = (controlSignal == 1) ? {0, ~in_src} :
                              (controlSignal == 2) ? (in_src + 1) :
                              (controlSignal == 3) ? (in_src - 1) : 
                              (controlSignal == 4) ? {carryFlag , in_dst} :
                              (controlSignal == 5) ? (in_src + in_dst) :
                              (controlSignal == 6) ? (in_src - in_dst) :
                              (controlSignal == 7) ? (in_src & in_dst) :
                              (controlSignal == 8) ? (in_src | in_dst) :
                              (controlSignal == 9) ? (in_src) :// TODO: need immediate value
                              (controlSignal == 10) ? (in_src) :// TODO: need immediate value
                              (controlSignal == 11) ? {1 , out} :
                              (controlSignal == 12) ? {0 , out} :
                              (controlSignal == 13) ? {carryFlag , in_src} : // STD or load
                              {carryFlag, out}; // NOP
// 2=ldd , 3=std,==> pass in_src
    
    assign is_alu = !(controlSignal == 4 || controlSignal >= 13);
    assign zeroFlag = (is_alu) ? !(|out) : zeroFlag;
    assign negFlag = (is_alu) ? out[N-1] : negFlag;
endmodule
