`timescale 1ns/1ps

module rv32_branch (
    input  wire        enable,
    input  wire [2:0]  funct3,
    input  wire [31:0] left,
    input  wire [31:0] right,
    output reg         take
);
    always @(*) begin
        take = 1'b0;
        if (enable) begin
            case (funct3)
                3'b000: take = (left == right);                    // BEQ
                3'b001: take = (left != right);                    // BNE
                3'b100: take = ($signed(left) < $signed(right));   // BLT
                3'b101: take = ($signed(left) >= $signed(right));  // BGE
                3'b110: take = (left < right);                     // BLTU
                3'b111: take = (left >= right);                    // BGEU
                default: take = 1'b0;
            endcase
        end
    end
endmodule
