module jump_detection_unit 
(
    input[2:0] jump_type, 
    input[2:0] CCR, 
    output jump_occur
);
    assign jump_occur = 
    (jump_type == 2 && flags[1]) || 
    (jump_type == 3 && flags[2]) ||
    (jump_type == 4 && flags[0]);
endmodule