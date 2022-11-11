module ALU#(parameter N=16) (input[N-1:0] in_src, input[N-1:0] in_dst, input controlSignal, 
            output[N-1:0] out, output carryFlay, output zeroFlag, output negFlag);

    assign {carryFlay, out} = (controlSignal == 0) ? (in_src + in_dst) : ~in_dst;
    
    
    // assign carryFlay = !(in_src[N-1] ^ in_dst) && (in_src[N-1] != out[N-1]);
    assign zeroFlag = !(|out) ? 1 : 0;
    assign negFlag = out[N-1];
endmodule
