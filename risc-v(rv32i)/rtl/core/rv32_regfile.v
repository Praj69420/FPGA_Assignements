`timescale 1ns/1ps

module rv32_regfile (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        write_enable,
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  rd,
    input  wire [31:0] write_data,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data
);
    reg [31:0] regs [0:31];
    integer i;

    assign rs1_data = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign rs2_data = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'd0;
        end else if (write_enable && (rd != 5'd0)) begin
            regs[rd] <= write_data;
        end

        regs[0] <= 32'd0;
    end
endmodule
