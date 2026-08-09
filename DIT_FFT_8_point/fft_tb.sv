`timescale 1ns / 1ps

module fft_tb;

parameter N = 16;

logic clk;
logic rst;
logic signed [N-1:0] x_r [0:7];
logic signed [N-1:0] x_i [0:7];
logic signed [N-1:0] y_r [0:7];
logic signed [N-1:0] y_i [0:7];

fft dut (.*);

always begin
    #5 clk = ~clk;
end

initial begin
    clk = 0;
    rst = 1;
    x_r[0] = 16'h1000; x_i[0] = 16'h0000;
    x_r[1] = 16'h2000; x_i[1] = 16'h0000;
    x_r[2] = 16'h3000; x_i[2] = 16'h0000;
    x_r[3] = 16'h4000; x_i[3] = 16'h0000;
    x_r[4] = 16'h5000; x_i[4] = 16'h0000;
    x_r[5] = 16'h6000; x_i[5] = 16'h0000;
    x_r[6] = 16'h7000; x_i[6] = 16'h0000;
    x_r[7] = 16'h8000; x_i[7] = 16'h0000;

    #10 rst = 0;

    #100;

    $monitor("y_r[0]=%h, y_i[0]=%h, y_r[1]=%h, y_i[1]=%h, y_r[2]=%h, y_i[2]=%h, y_r[3]=%h, y_i[3]=%h, y_r[4]=%h, y_i[4]=%h, y_r[5]=%h, y_i[5]=%h, y_r[6]=%h, y_i[6]=%h, y_r[7]=%h, y_i[7]=%h",
             y_r[0], y_i[0], y_r[1], y_i[1], y_r[2], y_i[2], y_r[3], y_i[3], y_r[4], y_i[4], y_r[5], y_i[5], y_r[6], y_i[6], y_r[7], y_i[7]);

    #20 $finish;
end

endmodule
