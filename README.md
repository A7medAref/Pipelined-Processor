# Pipelined Processor Implementation

## Overview

This project implements a Risc processor using Verilog, designed to execute a subset of MIPS instructions with stages for instruction fetch, decode, execute, memory access, and write-back. It also includes basic interrupt handling.

## Tools Used

- **Verilog**: Hardware description language.
- **ModelSim**: Functional simulation and verification.
- **Python**: Assembler script to convert assembly language to machine code.

## About

In this project, we apply a Harvard architecture with two memory units: Instruction memory and Data memory.

The processor has a RISC-like instruction set architecture with eight 2-byte general-purpose registers (R0 to R7). These registers are separate from the program counter (PC) and stack pointer (SP) registers.

### Memory Layout

- **Instruction Memory**:

  - Address space: 2 Megabytes
  - Word addressable: 16-bit width
  - Starts with the interrupt area ([0 to 2^5-1]), followed by the instructions area ([2^5 to 2^20]).
- **Data Memory**:

  - Address space: 4 Kilobytes
  - Word addressable: 16-bit width
  - Starts with the data area, followed by the stack area ([2^11-1 and up]).

### Program Counter (PC)

The PC spans the instruction memory address space and is initialized to 2^5, where the program code starts.

### Stack Pointer (SP)

The SP points to the top of the stack and is initialized to 2^11-1.

### Interrupt Handling

When an interrupt occurs, the processor completes the current instructions, saves the processor state (flags), and the next instruction address (PC) is saved on the stack. The PC is then loaded from address 0 where the interrupt code resides. The `RTI` instruction restores the PC and flags, resuming normal program flow.

## Instructions Implemented

### No Operands

- NOP
- SETC
- CLRC

#### One Operand

- NOT Rdst
- INC Rdst
- DEC Rdst
- OUT Rdst
- IN Rdst
- PUSH Rdst
- POP Rdst

#### Two Operands

- ADD Rsrc, Rdst
- SUB Rsrc, Rdst
- MUL Rsrc, Rdst
- DIV Rsrc, Rdst
- AND Rsrc, Rdst
- OR Rsrc, Rdst
- XOR Rsrc, Rdst
- NOR Rsrc, Rdst
- MOV Rsrc, Rdst
- SHL Rsrc, Rdst
- SHR Rsrc, Rdst
- LW Rsrc, Rdst
- SW Rsrc, Rdst
- LDM Rsrc, Rdst
- LDD Rsrc, Rdst
- STD Rsrc, Rdst

#### Control Instructions

- BEQ Rsrc, Rdst
- BNE Rsrc, Rdst
- JMP address
- JZ address
- JN address
- JC address
- CALL address
- RET
- RTI

#### Usage Instructions

1. Clone the repository and navigate to the project directory.
2. Open the project in **ModelSim**.
3. Load the Verilog files and run the simulation.
4. Verify the results using provided testbenches.
