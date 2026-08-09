`timescale 1ns / 1ps

module fft_tb;

parameter int N = 8;

logic clk;
logic rst;
logic signed [15:0] x_r [0:N-1];
logic signed [15:0] x_i [0:N-1];
logic signed [31:0] y_r [0:N-1];
logic signed [31:0] y_i [0:N-1];

fft #(.N(N)) dut (
    .clk(clk),
    .rst(rst),
    .x_r(x_r),
    .x_i(x_i),
    .y_r(y_r),
    .y_i(y_i)
);

initial begin
    $dumpfile("fft.vcd");
    $dumpvars(0, fft_tb);

    clk = 0;
    rst = 1;

    x_r[0] = 1; x_i[0] = 0;
    x_r[1] = 0; x_i[1] = 0;
    x_r[2] = 0; x_i[2] = 0;
    x_r[3] = 0; x_i[3] = 0;
    x_r[4] = 0; x_i[4] = 0;
    x_r[5] = 0; x_i[5] = 0;
    x_r[6] = 0; x_i[6] = 0;
    x_r[7] = 0; x_i[7] = 0;

    #1 rst = 0;

    #5;

    $display("y_r[0]=%d, y_i[0]=%d", y_r[0], y_i[0]);
    $display("y_r[1]=%d, y_i[1]=%d", y_r[1], y_i[1]);
    $display("y_r[2]=%d, y_i[2]=%d", y_r[2], y_i[2]);
    $display("y_r[3]=%d, y_i[3]=%d", y_r[3], y_i[3]);
    $display("y_r[4]=%d, y_i[4]=%d", y_r[4], y_i[4]);
    $display("y_r[5]=%d, y_i[5]=%d", y_r[5], y_i[5]);
    $display("y_r[6]=%d, y_i[6]=%d", y_r[6], y_i[6]);
    $display("y_r[7]=%d, y_i[7]=%d", y_r[7], y_i[7]);

    #10 $finish;
end

endmodule
