`timescale 1ns / 1ps

module butterfly #(
    parameter int N = 16
) (
    input logic signed [N-1:0] a_r, a_i, b_r, b_i, w_r, w_i,
    output logic signed [N-1:0] sum_r, sum_i, diff_r, diff_i
);

    always_comb begin
        sum_r = a_r + (b_r * w_r - b_i * w_i);
        sum_i = a_i + (b_r * w_i + b_i * w_r);
        diff_r = a_r - (b_r * w_r - b_i * w_i);
        diff_i = a_i - (b_r * w_i + b_i * w_r);
    end

endmodule

module fft #(
    parameter int N = 16,
    parameter int STAGES = 3
) (
    input logic clk,
    input logic rst,
    input logic signed [N-1:0] x_r [0:7],
    input logic signed [N-1:0] x_i [0:7],
    output logic signed [N-1:0] y_r [0:7],
    output logic signed [N-1:0] y_i [0:7]
);

    // Twiddle factors for 8-point FFT
    // W^0 = 1
    // W^1 = 0.707 - 0.707j
    // W^2 = -j
    // W^3 = -0.707 - 0.707j

    logic signed [N-1:0] w_r [0:3];
    logic signed [N-1:0] w_i [0:3];

    wire signed [N-1:0] stage1_r [0:7];
    wire signed [N-1:0] stage1_i [0:7];
    wire signed [N-1:0] stage2_r [0:7];
    wire signed [N-1:0] stage2_i [0:7];
    wire signed [N-1:0] stage3_r [0:7];
    wire signed [N-1:0] stage3_i [0:7];

    butterfly #(.N(N)) bf0_stage1(x_r[0], x_i[0], x_r[4], x_i[4], w_r[0], w_i[0], stage1_r[0], stage1_i[0], stage1_r[4], stage1_i[4]);
    butterfly #(.N(N)) bf1_stage1(x_r[1], x_i[1], x_r[5], x_i[5], w_r[1], w_i[1], stage1_r[1], stage1_i[1], stage1_r[5], stage1_i[5]);
    butterfly #(.N(N)) bf2_stage1(x_r[2], x_i[2], x_r[6], x_i[6], w_r[2], w_i[2], stage1_r[2], stage1_i[2], stage1_r[6], stage1_i[6]);
    butterfly #(.N(N)) bf3_stage1(x_r[3], x_i[3], x_r[7], x_i[7], w_r[3], w_i[3], stage1_r[3], stage1_i[3], stage1_r[7], stage1_i[7]);

    butterfly #(.N(N)) bf0_stage2(stage1_r[0], stage1_i[0], stage1_r[2], stage1_i[2], w_r[0], w_i[0], stage2_r[0], stage2_i[0], stage2_r[2], stage2_i[2]);
    butterfly #(.N(N)) bf1_stage2(stage1_r[1], stage1_i[1], stage1_r[3], stage1_i[3], w_r[2], w_i[2], stage2_r[1], stage2_i[1], stage2_r[3], stage2_i[3]);
    butterfly #(.N(N)) bf2_stage2(stage1_r[4], stage1_i[4], stage1_r[6], stage1_i[6], w_r[0], w_i[0], stage2_r[4], stage2_i[4], stage2_r[6], stage2_i[6]);
    butterfly #(.N(N)) bf3_stage2(stage1_r[5], stage1_i[5], stage1_r[7], stage1_i[7], w_r[2], w_i[2], stage2_r[5], stage2_i[5], stage2_r[7], stage2_i[7]);

    butterfly #(.N(N)) bf0_stage3(stage2_r[0], stage2_i[0], stage2_r[1], stage2_i[1], w_r[0], w_i[0], stage3_r[0], stage3_i[0], stage3_r[1], stage3_i[1]);
    butterfly #(.N(N)) bf1_stage3(stage2_r[2], stage2_i[2], stage2_r[3], stage2_i[3], w_r[0], w_i[0], stage3_r[2], stage3_i[2], stage3_r[3], stage3_i[3]);
    butterfly #(.N(N)) bf2_stage3(stage2_r[4], stage2_i[4], stage2_r[5], stage2_i[5], w_r[0], w_i[0], stage3_r[4], stage3_i[4], stage3_r[5], stage3_i[5]);
    butterfly #(.N(N)) bf3_stage3(stage2_r[6], stage2_i[6], stage2_r[7], stage2_i[7], w_r[0], w_i[0], stage3_r[6], stage3_i[6], stage3_r[7], stage3_i[7]);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            w_r[0] <= 16'h4000; w_i[0] <= 16'h0000;
            w_r[1] <= 16'h2d41; w_i[1] <= 16'hd2be;
            w_r[2] <= 16'h0000; w_i[2] <= 16'hc000;
            w_r[3] <= 16'hd2be; w_i[3] <= 16'hd2be;
        end else begin
            w_r[0] <= w_r[0];
            w_i[0] <= w_i[0];
            w_r[1] <= w_r[1];
            w_i[1] <= w_i[1];
            w_r[2] <= w_r[2];
            w_i[2] <= w_i[2];
            w_r[3] <= w_r[3];
            w_i[3] <= w_i[3];
        end
    end

    assign y_r[0] = stage3_r[0];
    assign y_i[0] = stage3_i[0];
    assign y_r[1] = stage3_r[4];
    assign y_i[1] = stage3_i[4];
    assign y_r[2] = stage3_r[2];
    assign y_i[2] = stage3_i[2];
    assign y_r[3] = stage3_r[6];
    assign y_i[3] = stage3_i[6];
    assign y_r[4] = stage3_r[1];
    assign y_i[4] = stage3_i[1];
    assign y_r[5] = stage3_r[5];
    assign y_i[5] = stage3_i[5];
    assign y_r[6] = stage3_r[3];
    assign y_i[6] = stage3_i[3];
    assign y_r[7] = stage3_r[7];
    assign y_i[7] = stage3_i[7];

endmodule
