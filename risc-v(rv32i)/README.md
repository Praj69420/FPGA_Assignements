# RV32I Single-Cycle Processor

A small single-cycle RISC-V RV32I processor written in Verilog for FPGA lab practice.

## Main blocks


Supported instructions include common RV32I arithmetic, logical, load/store, branch, jump, LUI and AUIPC instructions.

## Run

```bash
make
```
which executes
iverilog -g2012 -o build/rv32_sim \
    rtl/core/*.v \
    rtl/memory/*.v \
    rtl/rv32_lab_top.v \
    sim/tb_rv32_lab.v

vvp build/rv32_sim

Open the waveform with:

```bash
make wave
```
which executes
gtkwave build/rv32_trace.vcd



## Test program
0x00     addi x5,x0,7            x5  = 7
0x04     addi x6,x0,3            x6  = 3
0x08     slli x7,x5,2            x7  = 28
0x0C     sub x8,x7,x6            x8  = 25
0x10     sw x8,128(x0)           RAM[128] = 25
0x14     lw x9,128(x0)           x9  = 25
0x18     beq x9,x8,+8            branch taken
0x20     addi x10,x0,42          x10 = 42
0x24     jal x0,0                loop

Its output should be:
```text
x5  = 7
x6  = 3
x7  = 28
x8  = 25
x9  = 25
x10 = 42
RAM[128] = 25
TEST PASSED
```

## Repository Overview

A small single-cycle RISC-V RV32I processor written in Verilog for FPGA lab practice (Advanced FPGA Design Lab).

What this repository implements

- A simple single-cycle RV32I CPU core and supporting RTL for lab and simulation.
- The design is intentionally small and educational — suitable for studying datapath and control in a single-cycle implementation.

Top-level layout

- `rtl/` : top-level wrapper and structural RTL.
- `rtl/core/` : CPU datapath and control modules (ALU, decoder, regfile, branch, lsu, immediate).
- `rtl/memory/` : instruction ROM and data RAM models.
- `sim/` : testbench(s) used to exercise the design (`tb_rv32_lab.v`).
- `programs/` : example assembly programs that can be loaded into the instruction ROM.
- `build/` : build artifacts produced by the simulation flow (sim executable, VCD traces).

What happens when you build and run

1. `make` compiles the RTL and testbench using `iverilog`, producing `build/rv32_sim`.

```bash
iverilog -g2012 -o build/rv32_sim \
    rtl/core/*.v \
    rtl/memory/*.v \
    rtl/rv32_lab_top.v \
    sim/tb_rv32_lab.v

vvp build/rv32_sim
```

2. The testbench runs the CPU with the program stored in the instruction ROM. During simulation the testbench prints register values and RAM contents and writes a VCD waveform to `build/rv32_trace.vcd`.

3. Open the waveform with:

```bash
make wave
# (this runs `gtkwave build/rv32_trace.vcd`)
```

What the testbench checks

- The included test program (see `programs/demo.S`) executes a sequence of immediate, arithmetic, shift, memory and control instructions.
- The testbench monitors selected register values and memory locations and prints a short transcript. If the transcript matches the expected results the testbench prints `TEST PASSED`.

Example test program (brief)

0x00     addi x5,x0,7            x5  = 7
0x04     addi x6,x0,3            x6  = 3
0x08     slli x7,x5,2            x7  = 28
0x0C     sub x8,x7,x6            x8  = 25
0x10     sw x8,128(x0)           RAM[128] = 25
0x14     lw x9,128(x0)           x9  = 25
0x18     beq x9,x8,+8            branch taken
0x20     addi x10,x0,42          x10 = 42
0x24     jal x0,0                loop

Expected output from the testbench:

```text
x5  = 7
x6  = 3
x7  = 28
x8  = 25
x9  = 25
x10 = 42
RAM[128] = 25
TEST PASSED
```
<image src="output.png">
<image src="waveform_vcd.png">

Prajwal Kandel

PUL079BCT060 

Advanced FPGA Design Lab
