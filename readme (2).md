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

### Test Program

The instruction memory is pre-loaded with a test program:

```assembly
# Address  # Instruction      # Description
0x0000:    addi $1, $0, 10    # Load 10 into $1
0x0004:    addi $2, $0, 20    # Load 20 into $2
0x0008:    add  $3, $1, $2    # $3 = $1 + $2 = 30
0x000C:    sub  $4, $3, $1    # $4 = $3 - $1 = 20
0x0010:    and  $5, $3, $2    # $5 = $3 & $2 = 20
0x0014:    or   $6, $4, $5    # $6 = $4 | $5 = 20
0x0018:    slt  $7, $1, $2    # $7 = ($1 < $2) = 1
0x001C:    beq  $1, $2, -1    # Branch if $1 == $2 (not taken)
0x0020:    j    0             # Jump to address 0
```

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

### Expected Results

When running the complete CPU test, you should see:
- PC incrementing from 0x00000000 to 0x00000020
- Register writes showing correct computation results
- Final register state:
  - $1 = 10, $2 = 20, $3 = 30, $4 = 20, $5 = 20, $6 = 20, $7 = 1

## Design Decisions

1. **Single-Cycle Implementation**: Simple design where each instruction completes in one clock cycle
2. **Harvard Architecture**: Separate instruction and data memories
3. **Word Addressing**: All memory accesses are 32-bit aligned
4. **Synchronous Reset**: All sequential elements reset on clock edge
5. **Combinational Reads**: Register file and data memory provide immediate read access

## Limitations

1. **No Pipeline**: Single-cycle design limits performance
2. **Limited ISA**: Only basic MIPS instructions supported
3. **No Exceptions**: No exception or interrupt handling
4. **Fixed Memory Size**: 4KB instruction and data memories
5. **No Cache**: Direct memory access only

## Extensions

This basic CPU can be extended with:
- Pipeline stages for better performance
- Floating-point unit (FPU)
- Memory management unit (MMU)
- Cache hierarchy
- Exception handling
- More comprehensive instruction set
- Hazard detection and forwarding

## Verification

Each module includes comprehensive testbenches that verify:
- Functional correctness
- Edge cases and error conditions
- Interface compliance
- Performance characteristics

The complete CPU testbench runs the pre-loaded program and verifies all register contents match expected values.

## License

This project is provided as educational material for learning computer architecture and Verilog HDL.