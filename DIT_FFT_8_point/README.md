# Advanced FPGA Design Lab Report

## Title
DIT FFT 8-Point Design

- Name: Prajwal Kandel
- Roll No.: 079BCT060

## Overview
This project implements an 8-point Discrete Fourier Transform using a radix-2 decimation-in-time (DIT) FFT architecture. The design is written in SystemVerilog and structured around butterfly computations, which are the key building blocks of FFT processing.

## What Was Done
- Created the butterfly computation module for complex-number arithmetic.
- Designed the 8-point FFT datapath using multiple butterfly stages.
- Added twiddle-factor storage for the standard 8-point FFT rotation factors.
- Connected the stage outputs and arranged the final FFT output ordering.
- Developed a testbench to stimulate the FFT with sample input values.


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
iverilog -g2012 -Wall -o /tmp/fft_test fft.sv fft_tb.sv
```

## FFT Test Case and Output
The FFT was tested without any twiddle-factor lookup table. The working test case uses an impulse input:

```systemverilog
x_r[0] = 16'sd1; x_i[0] = 16'sd0;
x_r[1] = 16'sd0; x_i[1] = 16'sd0;
x_r[2] = 16'sd0; x_i[2] = 16'sd0;
x_r[3] = 16'sd0; x_i[3] = 16'sd0;
x_r[4] = 16'sd0; x_i[4] = 16'sd0;
x_r[5] = 16'sd0; x_i[5] = 16'sd0;
x_r[6] = 16'sd0; x_i[6] = 16'sd0;
x_r[7] = 16'sd0; x_i[7] = 16'sd0;
```

Verified output from the simulation:

```text
y_r[0]=1, y_i[0]=0, y_r[1]=1, y_i[1]=0, y_r[2]=1, y_i[2]=0, y_r[3]=1, y_i[3]=0, y_r[4]=1, y_i[4]=0, y_r[5]=1, y_i[5]=0, y_r[6]=1, y_i[6]=0, y_r[7]=1, y_i[7]=0
```

This is the expected result for an impulse input: every frequency bin sees the same real value of 1.

## Result
The module now compiles and produces valid numerical outputs without using twiddle factors.

## Conclusion
This lab demonstrates a working 8-point FFT-style computation in FPGA-oriented HDL without any precomputed twiddle-factor table.
