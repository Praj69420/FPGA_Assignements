
// A simple butterfly for the FFT.
// It calculates:
//   sum  = a + (b * w)
//   diff = a - (b * w)
// The multiplication is a complex multiplication.
// We use integer arithmetic. Twiddle factors are scaled by 2^7 (128).
// After the complex multiplication, the product is scaled back down by shifting right by 7.
module butterfly (
    input  logic signed [31:0] a_r, a_i, b_r, b_i,
    input  logic signed [15:0] w_r, w_i, // Scaled Twiddle factor
    output logic signed [31:0] sum_r, sum_i, diff_r, diff_i
);
    logic signed [47:0] prod_r_full, prod_i_full;
    logic signed [31:0] prod_r, prod_i;

    // Complex multiplication: (b_r * w_r - b_i * w_i) + j*(b_r * w_i + b_i * w_r)
    assign prod_r_full = $signed(b_r) * $signed(w_r) - $signed(b_i) * $signed(w_i);
    assign prod_i_full = $signed(b_r) * $signed(w_i) + $signed(b_i) * $signed(w_r);

    // Scale down the product, since twiddle factors are scaled up by 2^7
    assign prod_r = prod_r_full >>> 7;
    assign prod_i = prod_i_full >>> 7;

    assign sum_r  = a_r + prod_r;
    assign sum_i  = a_i + prod_i;
    assign diff_r = a_r - prod_r;
    assign diff_i = a_i - prod_i;
endmodule

module fft
#(
    parameter int N = 8
)
(
    input  logic clk,
    input  logic rst,
    input  logic signed [15:0] x_r [0:N-1],
    input  logic signed [15:0] x_i [0:N-1],
    output logic signed [31:0] y_r [0:N-1],
    output logic signed [31:0] y_i [0:N-1]
);

    // Twiddle factors scaled by 2^7 = 128
    // W^0 = 1
    localparam signed [15:0] W0_R = 128;
    localparam signed [15:0] W0_I = 0;
    // W^1 = 0.707 - 0.707j
    localparam signed [15:0] W1_R = 90;
    localparam signed [15:0] W1_I = -90;
    // W^2 = -j
    localparam signed [15:0] W2_R = 0;
    localparam signed [15:0] W2_I = -128;
    // W^3 = -0.707 - 0.707j
    localparam signed [15:0] W3_R = -90;
    localparam signed [15:0] W3_I = -90;

    // Intermediate signals for FFT stages
    logic signed [31:0] s1_r [0:N-1], s1_i [0:N-1];
    logic signed [31:0] s2_r [0:N-1], s2_i [0:N-1];
    logic signed [31:0] s3_r [0:N-1], s3_i [0:N-1];
    
    // Sign-extend inputs
    logic signed [31:0] x_r_ext [0:N-1], x_i_ext [0:N-1];
    always_comb begin
        for (int i=0; i<N; i++) begin
            x_r_ext[i] = x_r[i];
            x_i_ext[i] = x_i[i];
        end
    end

    // Stage 1: 4 butterflies
    // Twiddle factor for all is W^0 (1)
    butterfly b1_0(x_r_ext[0], x_i_ext[0], x_r_ext[4], x_i_ext[4], W0_R, W0_I, s1_r[0], s1_i[0], s1_r[4], s1_i[4]);
    butterfly b1_1(x_r_ext[1], x_i_ext[1], x_r_ext[5], x_i_ext[5], W0_R, W0_I, s1_r[1], s1_i[1], s1_r[5], s1_i[5]);
    butterfly b1_2(x_r_ext[2], x_i_ext[2], x_r_ext[6], x_i_ext[6], W0_R, W0_I, s1_r[2], s1_i[2], s1_r[6], s1_i[6]);
    butterfly b1_3(x_r_ext[3], x_i_ext[3], x_r_ext[7], x_i_ext[7], W0_R, W0_I, s1_r[3], s1_i[3], s1_r[7], s1_i[7]);

    // Stage 2: 4 butterflies
    butterfly b2_0(s1_r[0], s1_i[0], s1_r[2], s1_i[2], W0_R, W0_I, s2_r[0], s2_i[0], s2_r[2], s2_i[2]);
    butterfly b2_1(s1_r[1], s1_i[1], s1_r[3], s1_i[3], W2_R, W2_I, s2_r[1], s2_i[1], s2_r[3], s2_i[3]);
    butterfly b2_2(s1_r[4], s1_i[4], s1_r[6], s1_i[6], W0_R, W0_I, s2_r[4], s2_i[4], s2_r[6], s2_i[6]);
    butterfly b2_3(s1_r[5], s1_i[5], s1_r[7], s1_i[7], W2_R, W2_I, s2_r[5], s2_i[5], s2_r[7], s2_i[7]);

    // Stage 3: 4 butterflies
    butterfly b3_0(s2_r[0], s2_i[0], s2_r[1], s2_i[1], W0_R, W0_I, s3_r[0], s3_i[0], s3_r[1], s3_i[1]);
    butterfly b3_1(s2_r[2], s2_i[2], s2_r[3], s2_i[3], W1_R, W1_I, s3_r[2], s3_i[2], s3_r[3], s3_i[3]);
    butterfly b3_2(s2_r[4], s2_i[4], s2_r[5], s2_i[5], W2_R, W2_I, s3_r[4], s3_i[4], s3_r[5], s3_i[5]);
    butterfly b3_3(s2_r[6], s2_i[6], s2_r[7], s2_i[7], W3_R, W3_I, s3_r[6], s3_i[6], s3_r[7], s3_i[7]);
    
    // Output reordering (bit-reversal)
    // y[000] = s3[000]
    // y[001] = s3[100]
    // y[010] = s3[010]
    // y[011] = s3[110]
    // y[100] = s3[001]
    // y[101] = s3[101]
    // y[110] = s3[011]
    // y[111] = s3[111]
    always_comb begin
        y_r[0] = s3_r[0]; y_i[0] = s3_i[0];
        y_r[1] = s3_r[4]; y_i[1] = s3_i[4];
        y_r[2] = s3_r[2]; y_i[2] = s3_i[2];
        y_r[3] = s3_r[6]; y_i[3] = s3_i[6];
        y_r[4] = s3_r[1]; y_i[4] = s3_i[1];
        y_r[5] = s3_r[5]; y_i[5] = s3_i[5];
        y_r[6] = s3_r[3]; y_i[6] = s3_i[3];
        y_r[7] = s3_r[7]; y_i[7] = s3_i[7];
    end

endmodule
