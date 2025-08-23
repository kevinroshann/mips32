# MIPS 32-bit Single-Cycle Processor

A complete implementation of a MIPS 32-bit single-cycle processor in Verilog with minimum ISA support.

## Architecture Overview

This MIPS CPU implements a single-cycle datapath supporting the following instruction types:
- **R-type**: ADD, SUB, AND, OR, SLT, SLL, SRL, XOR, NOR
- **I-type**: ADDI, ANDI, ORI, SLTI, LW, SW, BEQ
- **J-type**: JUMP

## Module Descriptions

### Core CPU Modules

1. **`pc.v`** - Program Counter
   - Maintains current instruction address
   - Synchronous reset to 0x00000000
   - Updates on clock edge with next PC value

2. **`imem.v`** - Instruction Memory
   - 4KB ROM (1024 × 32-bit words)
   - Pre-loaded with test program
   - Word-addressed (auto-converts byte addresses)
   - Optional `.hex` file loading support

3. **`regfile.v`** - Register File
   - 32 × 32-bit registers ($0 to $31)
   - Dual read ports, single write port
   - $0 register hardwired to zero
   - Synchronous write, combinational read

4. **`alu.v`** - Arithmetic Logic Unit
   - Supports 9 operations: ADD, SUB, AND, OR, SLT, SLL, SRL, XOR, NOR
   - 32-bit operands and result
   - Zero flag output for branch decisions

5. **`control.v`** - Main Control Unit
   - Decodes instruction opcode
   - Generates control signals for datapath
   - Supports R-type, I-type, and J-type instructions

6. **`alu_control.v`** - ALU Control Unit
   - Maps ALU operation codes and function fields
   - Generates 4-bit ALU control signals
   - Handles R-type and immediate operations

7. **`sign_extend.v`** - Sign Extension Unit
   - Extends 16-bit immediates to 32 bits
   - Supports both sign and zero extension

8. **`dmem.v`** - Data Memory
   - 4KB RAM (1024 × 32-bit words)
   - Synchronous write, asynchronous read
   - Pre-initialized with test data

9. **`mux.v`** - Multiplexer Modules
   - Parametric 2:1, 3:1, and 4:1 multiplexers
   - Used throughout the datapath for signal routing

10. **`mips_cpu.v`** - Top-Level CPU
    - Integrates all modules into complete processor
    - Implements single-cycle MIPS datapath
    - Handles PC updates, branching, and jumping

## Instruction Set Architecture (ISA)

### Supported Instructions

| Type | Instruction | Opcode | Function | Description |
|------|-------------|--------|----------|-------------|
| R | ADD | 000000 | 100000 | Add registers |
| R | SUB | 000000 | 100010 | Subtract registers |
| R | AND | 000000 | 100100 | Bitwise AND |
| R | OR | 000000 | 100101 | Bitwise OR |
| R | SLT | 000000 | 101010 | Set less than |
| I | ADDI | 001000 | - | Add immediate |
| I | ANDI | 001100 | - | AND immediate |
| I | ORI | 001101 | - | OR immediate |
| I | LW | 100011 | - | Load word |
| I | SW | 101011 | - | Store word |
| I | BEQ | 000100 | - | Branch if equal |
| J | J | 000010 | - | Jump |


## File Structure

```
mips_cpu/
├── src/
│   ├── pc.v              # Program Counter
│   ├── imem.v            # Instruction Memory
│   ├── regfile.v         # Register File
│   ├── alu.v             # ALU
│   ├── control.v         # Main Control
│   ├── alu_control.v     # ALU Control
│   ├── sign_extend.v     # Sign Extension
│   ├── dmem.v            # Data Memory
│   ├── mux.v             # Multiplexers
│   └── mips_cpu.v        # Top-level CPU
├── tb/
│   ├── pc_tb.v           # PC Testbench
│   ├── imem_tb.v         # Instruction Memory Testbench
│   ├── regfile_tb.v      # Register File Testbench
│   ├── alu_tb.v          # ALU Testbench
│   ├── control_tb.v      # Control Unit Testbench
│   └── mips_cpu_tb.v     # Complete CPU Testbench
├── Makefile              # Build system
└── shell.nix             # this is a nix shell for the packages you need
└── README.md             # This file
```

## Building and Testing

### Prerequisites
- Icarus Verilog (iverilog) or another Verilog simulator
- Make utility

### Running Tests

Test individual modules:
```bash
make test_pc        # Test Program Counter
make test_imem      # Test Instruction Memory
make test_regfile   # Test Register File
make test_alu       # Test ALU
make test_control   # Test Control Unit
```

Test complete CPU:
```bash
make test_cpu       # Test complete processor
```

Test everything:
```bash
make test_all       # Run all tests
```

Clean build files:
```bash
make clean
```


