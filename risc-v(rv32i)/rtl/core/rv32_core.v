`timescale 1ns/1ps

module rv32_core (
    input  wire        clk,
    input  wire        rst_n,

    output wire [31:0] instr_addr,
    input  wire [31:0] instr_data,

    output wire [31:0] data_addr,
    output wire [31:0] data_wdata,
    output wire [3:0]  data_wstrb,
    input  wire [31:0] data_rdata
);
    reg [31:0] pc;
    reg [31:0] next_pc;
    reg [31:0] writeback;

    wire [6:0] opcode = instr_data[6:0];
    wire [4:0] rd     = instr_data[11:7];
    wire [2:0] funct3 = instr_data[14:12];
    wire [4:0] rs1    = instr_data[19:15];
    wire [4:0] rs2    = instr_data[24:20];
    wire       funct7_bit5 = instr_data[30];

    wire       reg_write;
    wire       src_a_pc;
    wire       src_b_imm;
    wire [3:0] alu_op;
    wire [2:0] imm_kind;
    wire [1:0] wb_select;
    wire       mem_write;
    wire [1:0] mem_size;
    wire       load_unsigned;
    wire       branch_enable;
    wire       jal;
    wire       jalr;

    wire [31:0] imm_value;
    wire [31:0] rs1_value;
    wire [31:0] rs2_value;
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire [31:0] alu_result;
    wire        branch_take;
    wire [31:0] load_data;
    wire [31:0] pc_plus_4 = pc + 32'd4;

    assign instr_addr = pc;
    assign alu_a = src_a_pc ? pc : rs1_value;
    assign alu_b = src_b_imm ? imm_value : rs2_value;
    assign data_addr = alu_result;

    rv32_decoder decode (
        .opcode(opcode),
        .funct3(funct3),
        .funct7_bit5(funct7_bit5),
        .reg_write(reg_write),
        .src_a_pc(src_a_pc),
        .src_b_imm(src_b_imm),
        .alu_op(alu_op),
        .imm_kind(imm_kind),
        .wb_select(wb_select),
        .mem_write(mem_write),
        .mem_size(mem_size),
        .load_unsigned(load_unsigned),
        .branch_enable(branch_enable),
        .jal(jal),
        .jalr(jalr)
    );

    rv32_immediate imm_decode (
        .instruction(instr_data),
        .kind(imm_kind),
        .immediate(imm_value)
    );

    rv32_regfile rf (
        .clk(clk),
        .rst_n(rst_n),
        .write_enable(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(writeback),
        .rs1_data(rs1_value),
        .rs2_data(rs2_value)
    );

    rv32_alu execute_alu (
        .a(alu_a),
        .b(alu_b),
        .op(alu_op),
        .y(alu_result)
    );

    rv32_branch branch_check (
        .enable(branch_enable),
        .funct3(funct3),
        .left(rs1_value),
        .right(rs2_value),
        .take(branch_take)
    );

    rv32_lsu lsu (
        .store_enable(mem_write),
        .size(mem_size),
        .unsigned_load(load_unsigned),
        .store_value(rs2_value),
        .memory_value(data_rdata),
        .write_strobe(data_wstrb),
        .write_data(data_wdata),
        .load_data(load_data)
    );

    always @(*) begin
        case (wb_select)
            2'd1: writeback = load_data;
            2'd2: writeback = pc_plus_4;
            default: writeback = alu_result;
        endcase
    end

    always @(*) begin
        next_pc = pc_plus_4;

        if (branch_enable && branch_take)
            next_pc = pc + imm_value;

        if (jal)
            next_pc = pc + imm_value;

        if (jalr)
            next_pc = (rs1_value + imm_value) & 32'hffff_fffe;
    end

    always @(posedge clk) begin
        if (!rst_n)
            pc <= 32'd0;
        else
            pc <= next_pc;
    end
endmodule
