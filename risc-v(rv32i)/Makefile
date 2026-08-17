RTL = \
	rtl/core/rv32_alu.v \
	rtl/core/rv32_immediate.v \
	rtl/core/rv32_regfile.v \
	rtl/core/rv32_branch.v \
	rtl/core/rv32_lsu.v \
	rtl/core/rv32_decoder.v \
	rtl/core/rv32_core.v \
	rtl/memory/instruction_rom.v \
	rtl/memory/data_ram.v \
	rtl/rv32_lab_top.v

TB = sim/tb_rv32_lab.v
OUT = build/rv32_sim

all: sim

sim:
	mkdir -p build
	iverilog -g2012 -o $(OUT) $(RTL) $(TB)
	vvp $(OUT)

wave:
	gtkwave build/rv32_trace.vcd

clean:
	rm -f $(OUT) build/rv32_trace.vcd
