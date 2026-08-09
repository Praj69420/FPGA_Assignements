`timescale 1ns / 1ps

module butterfly_tb;

parameter N = 16;

logic signed [N-1:0] a_r, a_i, b_r, b_i, w_r, w_i;
logic signed [N-1:0] sum_r, sum_i, diff_r, diff_i;

butterfly #(.N(N)) dut (
    .a_r(a_r),
    .a_i(a_i),
    .b_r(b_r),
    .b_i(b_i),
    .w_r(w_r),
    .w_i(w_i),
    .sum_r(sum_r),
    .sum_i(sum_i),
    .diff_r(diff_r),
    .diff_i(diff_i)
);

initial begin
    a_r = 16'h1000; a_i = 16'h0000;
    b_r = 16'h2000; b_i = 16'h0000;
    w_r = 16'h4000; w_i = 16'h0000;

    #10;

    $monitor("sum_r=%h, sum_i=%h, diff_r=%h, diff_i=%h", sum_r, sum_i, diff_r, diff_i);

    #10 $finish;
end

endmodule
