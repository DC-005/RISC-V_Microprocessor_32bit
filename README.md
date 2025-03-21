# RISC-V_32Bit_Pipelined_Microprocessor

## Introduction
This project implements a 32-bit RISC-V microcontroller using a 5-stage pipelined architecture, based on the design principles outlined in Digital Design and Computer Architecture by David Money Harris & Sarah L. Harris.
RISC-V is an open-source Reduced Instruction Set Computing (RISC) architecture that provides a simple yet powerful instruction set for efficient computing. To enhance performance, we employ pipelining, a technique that allows overlapping instruction execution across multiple hardware stages, increasing instruction throughput.

## Tools Used
- Xilinx Vivado
- VS Code

## What is Pipelining?
Pipelining is a key concept in modern processor design that divides instruction execution into distinct stages, allowing multiple instructions to be processed simultaneously. This improves efficiency by keeping different parts of the processor active at all times.

A 5-stage pipeline typically consists of:

1) Instruction Fetch (F)
2) Instruction Decode (D)
3) Execute (E)
4) Memory Access (M)
5) Writeback (W)
By implementing pipelining, we significantly reduce instruction execution time compared to a single-cycle or multi-cycle design. However, this introduces challenges such as data hazards, control hazards, and structural hazards, which we address in this project.

## Project Approach
We designed our microcontroller in the following stages:

- Datapath Design: Implemented a 5-stage pipelined datapath based on RISC-V architecture. Fetch was designed separately to interface with the instruction memory, contorl unit and the rest of the datapath. Instruction memory, Data memory, Decode, Execute, Memory & Writeback modules were made separately.
- Control Unit: Designed a control unit to generate control signals for instruction execution. Control unit was first implemented piecewise and then integrated into one module.
- Hazard Handling: Implemented hazard detection (like stalling & flushing) and forwarding units to mitigate pipeline stalls.
- Integration & Testing: Combined all components and tested.

## Microarchitecture Overview
#### Microarchitecture Schematic


#### RTL View


#### The microarchitecture consists of:

- Instruction Memory: for fetching RISC-V instructions
- Register File: for storing operands and results
- ALU Components: for executing instructions, PC (Program Counter) control, arithmetic operations, MUX operations and data forwarding
- Extend: for sign extending the immidiate value and executing jump/branch type instructions
- Data Memory: for load/store operations
- Pipelining Registers: for storing intermidiate values in between steps & interconnections
- Control Unit: for managing instruction execution
- Hazard Detection & Forwarding Units: for handling pipeline hazards

## Pipeline Stages
1. Instruction Fetch (F)
- Fetches the next instruction from Instruction Memory.
- Updates the Program Counter (PC).
2. Instruction Decode (D)
- Decodes the fetched instruction to determine opcode, source registers, and destination registers.
- Reads operand values from the Register File.
3. Execute (E)
- Performs arithmetic or logical operations using the ALU.
- Computes memory addresses for load/store instructions.
- Determines branch outcomes.
4. Memory Access (M)
- Reads or writes data to/from Data Memory for load/store instructions.
- Passes computed values forward for further processing.
5. Writeback (W)
- Writes results back to the Register File for use in future instructions.

## Control Unit
The Control Unit generates control signals for various components of the pipeline, ensuring proper execution of instructions.

- Main Control: Decodes the instruction and produces control signals.
- ALU Control: Determines the correct ALU operation based on instruction type.
- Branch Control: Handles conditional branching.

## Hazard Handling
Pipeline execution can lead to hazards:

#### 1. Data Hazards
- Occur when an instruction depends on the result of a previous instruction.
- Handled using forwarding or stalling when necessary.
#### 2. Control Hazards
- Arise from branch instructions, where the next instruction is uncertain.
- Mitigated using branch prediction or flushing incorrect instructions.
#### 3. Structural Hazards
- Occur when multiple instructions require the same hardware resource simultaneously.
- Resolved through pipelined memory access and register forwarding mechanisms.

## Resources
1. Digital Design and Computer Architecture – David Money Harris & Sarah L. Harris
2. The RISC-V Instruction Set Manual Volume I Unprivileged Architecture (RISV32I)
   https://drive.google.com/file/d/1uviu1nH-tScFfgrovvFCrj7Omv8tFtkp/view
