`timescale 1ns/1ps

module rv32_lsu (
    input  wire        store_enable,
    input  wire [1:0]  size,
    input  wire        unsigned_load,
    input  wire [31:0] store_value,
    input  wire [31:0] memory_value,
    output reg  [3:0]  write_strobe,
    output reg  [31:0] write_data,
    output reg  [31:0] load_data
);
    always @(*) begin
        write_strobe = 4'b0000;
        write_data   = store_value;

        if (store_enable) begin
            case (size)
                2'd0: write_strobe = 4'b0001; // SB
                2'd1: write_strobe = 4'b0011; // SH
                default: write_strobe = 4'b1111; // SW
            endcase
        end

        case (size)
            2'd0: begin
                if (unsigned_load)
                    load_data = {24'd0, memory_value[7:0]};
                else
                    load_data = {{24{memory_value[7]}}, memory_value[7:0]};
            end
            2'd1: begin
                if (unsigned_load)
                    load_data = {16'd0, memory_value[15:0]};
                else
                    load_data = {{16{memory_value[15]}}, memory_value[15:0]};
            end
            default: load_data = memory_value;
        endcase
    end
endmodule
