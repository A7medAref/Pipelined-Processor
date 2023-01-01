module ALU#(parameter N=16) (input[N-1:0] new_src, 
                            input[N-1:0] new_dst, 
                            input[3:0] controlSignal, 
                            output[N-1:0] out, 
                            output carryFlag, 
                            output zeroFlag, 
                            output negFlag,     
                            input[15:0] instruction,
                            input wb1,
                            input wb2,
                            input mem_write1,
                            input mem_write2,
                            input[N-1:0] result_prev1,
                            input[N-1:0] result_prev2, // older one
                            input[2:0] reg1_buf1,
                            input[2:0] reg2_buf1,
                            input[2:0] reg2_buf2,
                            input[2:0] reg2_buf3,
                            input[15:0] memory_data_output_load_case,
                            input mem_read,
                            input mem_read_load_case,
                            output[N-1:0] in_dst,
                            output[N-1:0] in_src,
                            input in_port_signal,
                            input [N-1:0] in_port);

    assign in_src = ((reg1_buf1 === reg2_buf2) && wb1) ? result_prev1 : 
                  ((reg1_buf1 === reg2_buf3) && wb2) ?
                  mem_read_load_case ? memory_data_output_load_case : result_prev2
                  : new_src;

    assign in_dst = ((reg2_buf1 === reg2_buf2) && wb1) ? result_prev1 : 
                  ((reg2_buf1 === reg2_buf3) && wb2) ? 
                  mem_read_load_case ? memory_data_output_load_case : result_prev2
                  : new_dst;

    wire is_alu;
    assign {carryFlag, out} = (controlSignal == 1) ? {0, ~in_src} :
                              (controlSignal == 2) ? (in_src + 1) :
                              (controlSignal == 3) ? (in_src - 1) : 
                              (controlSignal == 4) ? {carryFlag , in_src} :
                              (controlSignal == 5) ? (in_src + in_dst) :
                              (controlSignal == 6) ? (in_src - in_dst) :
                              (controlSignal == 7) ? (in_src & in_dst) :
                              (controlSignal == 8) ? (in_src | in_dst) :
                              (controlSignal == 9) ? {in_src[N-1], (in_src << instruction)} :// shift left
                              (controlSignal == 10) ? {0, (in_src >> instruction)} :// shift right
                              (controlSignal == 11) ? {1 , out} :
                              (controlSignal == 12) ? {0 , out} :
                              (controlSignal == 13) ? {carryFlag , in_src} : // STD or load
                              (controlSignal == 14) ? {carryFlag , instruction} : // LOAD immediate
                              (in_port_signal) ? {carryFlag, in_port} :
                              {carryFlag, out}; // NOP
// 2=ldd , 3=std,==> pass in_src
    
    assign is_alu = !(controlSignal == 4 || controlSignal >= 13);
    assign zeroFlag = (is_alu) ? !(|out) : zeroFlag;
    assign negFlag = (is_alu) ? out[N-1] : negFlag;
endmodule
