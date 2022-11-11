module NDecoder
#(parameter N = 5)
( input wire [N-1 : 0] a
, output reg [(1<<N)-1 : 0] y
,input clk
);

always @(posedge clk) begin
y = 0;
y[a] = 1'b1;
end

endmodule

