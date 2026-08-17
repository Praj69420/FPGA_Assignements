`timescale 1ns/1ps

module data_ram #(
    parameter BYTES = 1024
) (
    input  wire        clk,
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    input  wire [3:0]  wstrb,
    output wire [31:0] rdata
);
    reg [7:0] mem [0:BYTES-1];
    integer i;

    initial begin
        for (i = 0; i < BYTES; i = i + 1)
            mem[i] = 8'd0;
    end

    assign rdata = {
        mem[addr + 32'd3],
        mem[addr + 32'd2],
        mem[addr + 32'd1],
        mem[addr]
    };

    always @(posedge clk) begin
        if (wstrb[0]) mem[addr]         <= wdata[7:0];
        if (wstrb[1]) mem[addr + 32'd1] <= wdata[15:8];
        if (wstrb[2]) mem[addr + 32'd2] <= wdata[23:16];
        if (wstrb[3]) mem[addr + 32'd3] <= wdata[31:24];
    end
endmodule
