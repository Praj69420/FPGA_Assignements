`timescale 1ns/1ps

module rv32_decoder (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire       funct7_bit5,

    output reg        reg_write,
    output reg        src_a_pc,
    output reg        src_b_imm,
    output reg [3:0]  alu_op,
    output reg [2:0]  imm_kind,
    output reg [1:0]  wb_select,
    output reg        mem_write,
    output reg [1:0]  mem_size,
    output reg        load_unsigned,
    output reg        branch_enable,
    output reg        jal,
    output reg        jalr
);
    localparam ALU_ADD  = 4'd0;
    localparam ALU_SUB  = 4'd1;
    localparam ALU_AND  = 4'd2;
    localparam ALU_OR   = 4'd3;
    localparam ALU_XOR  = 4'd4;
    localparam ALU_SLL  = 4'd5;
    localparam ALU_SRL  = 4'd6;
    localparam ALU_SRA  = 4'd7;
    localparam ALU_SLT  = 4'd8;
    localparam ALU_SLTU = 4'd9;
    localparam ALU_PASS = 4'd10;

    localparam IMM_I = 3'd0;
    localparam IMM_S = 3'd1;
    localparam IMM_B = 3'd2;
    localparam IMM_U = 3'd3;
    localparam IMM_J = 3'd4;

    localparam WB_ALU = 2'd0;
    localparam WB_MEM = 2'd1;
    localparam WB_PC4 = 2'd2;

    always @(*) begin
        reg_write     = 1'b0;
        src_a_pc      = 1'b0;
        src_b_imm     = 1'b0;
        alu_op        = ALU_ADD;
        imm_kind      = IMM_I;
        wb_select     = WB_ALU;
        mem_write     = 1'b0;
        mem_size      = 2'd2;
        load_unsigned = 1'b0;
        branch_enable = 1'b0;
        jal           = 1'b0;
        jalr          = 1'b0;

        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1'b1;
                case (funct3)
                    3'b000: alu_op = funct7_bit5 ? ALU_SUB : ALU_ADD;
                    3'b001: alu_op = ALU_SLL;
                    3'b010: alu_op = ALU_SLT;
                    3'b011: alu_op = ALU_SLTU;
                    3'b100: alu_op = ALU_XOR;
                    3'b101: alu_op = funct7_bit5 ? ALU_SRA : ALU_SRL;
                    3'b110: alu_op = ALU_OR;
                    3'b111: alu_op = ALU_AND;
                    default: alu_op = ALU_ADD;
                endcase
            end

            7'b0010011: begin // I-type arithmetic
                reg_write = 1'b1;
                src_b_imm = 1'b1;
                imm_kind  = IMM_I;
                case (funct3)
                    3'b000: alu_op = ALU_ADD;
                    3'b010: alu_op = ALU_SLT;
                    3'b011: alu_op = ALU_SLTU;
                    3'b100: alu_op = ALU_XOR;
                    3'b110: alu_op = ALU_OR;
                    3'b111: alu_op = ALU_AND;
                    3'b001: alu_op = ALU_SLL;
                    3'b101: alu_op = funct7_bit5 ? ALU_SRA : ALU_SRL;
                    default: alu_op = ALU_ADD;
                endcase
            end

            7'b0000011: begin // Loads
                reg_write = 1'b1;
                src_b_imm = 1'b1;
                imm_kind  = IMM_I;
                alu_op    = ALU_ADD;
                wb_select = WB_MEM;
                case (funct3)
                    3'b000: begin mem_size = 2'd0; load_unsigned = 1'b0; end // LB
                    3'b001: begin mem_size = 2'd1; load_unsigned = 1'b0; end // LH
                    3'b010: begin mem_size = 2'd2; load_unsigned = 1'b0; end // LW
                    3'b100: begin mem_size = 2'd0; load_unsigned = 1'b1; end // LBU
                    3'b101: begin mem_size = 2'd1; load_unsigned = 1'b1; end // LHU
                    default: reg_write = 1'b0;
                endcase
            end

            7'b0100011: begin // Stores
                src_b_imm = 1'b1;
                imm_kind  = IMM_S;
                alu_op    = ALU_ADD;
                mem_write = 1'b1;
                case (funct3)
                    3'b000: mem_size = 2'd0; // SB
                    3'b001: mem_size = 2'd1; // SH
                    3'b010: mem_size = 2'd2; // SW
                    default: mem_write = 1'b0;
                endcase
            end

            7'b1100011: begin // Branches
                imm_kind      = IMM_B;
                branch_enable = 1'b1;
            end

            7'b1101111: begin // JAL
                reg_write = 1'b1;
                imm_kind  = IMM_J;
                wb_select = WB_PC4;
                jal       = 1'b1;
            end

            7'b1100111: begin // JALR
                reg_write = 1'b1;
                src_b_imm = 1'b1;
                imm_kind  = IMM_I;
                wb_select = WB_PC4;
                alu_op    = ALU_ADD;
                jalr      = 1'b1;
            end

            7'b0110111: begin // LUI
                reg_write = 1'b1;
                src_b_imm = 1'b1;
                imm_kind  = IMM_U;
                alu_op    = ALU_PASS;
            end

            7'b0010111: begin // AUIPC
                reg_write = 1'b1;
                src_a_pc  = 1'b1;
                src_b_imm = 1'b1;
                imm_kind  = IMM_U;
                alu_op    = ALU_ADD;
            end

            default: begin
                // Unsupported instruction behaves like NOP.
            end
        endcase
    end
endmodule
