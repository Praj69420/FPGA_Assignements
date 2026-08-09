# Advanced FPGA Design Lab Report

## Lab Title
DIT FFT 8-Point Design

## Done By
- Name: Prajwal Kandel
- Roll No.: 079BCT060

## Course
Advanced FPGA Design

## Overview
This project implements an 8-point Discrete Fourier Transform using a radix-2 decimation-in-time (DIT) FFT architecture. The design is written in SystemVerilog and structured around butterfly computations, which are the key building blocks of FFT processing.

## What Was Done
- Created the butterfly computation module for complex-number arithmetic.
- Designed the 8-point FFT datapath using multiple butterfly stages.
- Added twiddle-factor storage for the standard 8-point FFT rotation factors.
- Connected the stage outputs and arranged the final FFT output ordering.
- Developed a testbench to stimulate the FFT with sample input values.
- Fixed the RTL issues related to:
  - missing clock declaration in the butterfly module,
  - incorrect parameter placement in the FFT module,
  - unsuitable procedural logic for combinational butterfly math,
  - syntax/port errors in the module definitions.

## Implemented Modules
- `butterfly` module
  - Performs complex addition and subtraction using twiddle-factor multiplication.
- `fft` module
  - Organizes the 8-point FFT computation in stages.
- `fft_tb` module
  - Provides a simulation environment for testing FFT behavior.
- `butterfly_tb` module
  - Checks the butterfly module independently.

## Simulation and Verification
The RTL was compiled and validated using `iverilog`.

Command used:
```bash
iverilog -g2012 -Wall -o /tmp/fft_test fft.sv fft_tb.sv butterfly_tb.sv
```

Verification result:
```text
COMPILE_OK
```

## Result
The design successfully elaborates and compiles without syntax/port errors, and the project is ready for further simulation or hardware implementation testing.

## Note
This lab demonstrates the implementation of a basic 8-point FFT in FPGA-oriented HDL and lays the groundwork for more advanced DSP and FPGA designs.
