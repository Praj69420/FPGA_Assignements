# Equivalent source of programs/demo.hex
# This file is for readability only; no assembler is required.

addi x5,  x0, 7
addi x6,  x0, 3
slli x7,  x5, 2
sub  x8,  x7, x6
sw   x8,  128(x0)
lw   x9,  128(x0)
beq  x9,  x8, pass
addi x10, x0, 1
pass:
addi x10, x0, 42
jal  x0,  0
