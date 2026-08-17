`timescale 1ns/1ps

module instruction_rom #(
    parameter WORDS = 256,
    parameter INIT_FILE = "programs/demo.hex"
) (
    input  wire [31:0] addr,
    output wire [31:0] rdata
);
    reg [31:0] mem [0:WORDS-1];

    initial begin
        $readmemh(INIT_FILE, mem);
    end

    assign rdata = mem[addr[9:2]];
endmodule
