`timescale 1ns/1ps

module tb_rv32_lab;
    reg clk;
    reg rst_n;
    integer cycles;

    rv32_lab_top dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("build/rv32_trace.vcd");
        $dumpvars(0, tb_rv32_lab);

        rst_n = 1'b0;
        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        for (cycles = 0; cycles < 20; cycles = cycles + 1)
            @(posedge clk);

        $display("x5  = %0d", dut.core.rf.regs[5]);
        $display("x6  = %0d", dut.core.rf.regs[6]);
        $display("x7  = %0d", dut.core.rf.regs[7]);
        $display("x8  = %0d", dut.core.rf.regs[8]);
        $display("x9  = %0d", dut.core.rf.regs[9]);
        $display("x10 = %0d", dut.core.rf.regs[10]);
        $display("RAM[128] = %0d", {dut.ram.mem[131], dut.ram.mem[130], dut.ram.mem[129], dut.ram.mem[128]});

        if ((dut.core.rf.regs[10] == 32'd42) &&
            ({dut.ram.mem[131], dut.ram.mem[130], dut.ram.mem[129], dut.ram.mem[128]} == 32'd25))
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $finish;
    end
endmodule
