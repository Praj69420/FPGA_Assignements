`timescale 1ns/1ps

module rv32_lab_top (
    input wire clk,
    input wire rst_n
);
    wire [31:0] i_addr;
    wire [31:0] i_data;
    wire [31:0] d_addr;
    wire [31:0] d_wdata;
    wire [3:0]  d_wstrb;
    wire [31:0] d_rdata;

    rv32_core core (
        .clk(clk),
        .rst_n(rst_n),
        .instr_addr(i_addr),
        .instr_data(i_data),
        .data_addr(d_addr),
        .data_wdata(d_wdata),
        .data_wstrb(d_wstrb),
        .data_rdata(d_rdata)
    );

    instruction_rom rom (
        .addr(i_addr),
        .rdata(i_data)
    );

    data_ram ram (
        .clk(clk),
        .addr(d_addr),
        .wdata(d_wdata),
        .wstrb(d_wstrb),
        .rdata(d_rdata)
    );
endmodule
