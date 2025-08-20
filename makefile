# Makefile for MIPS CPU Verilog Project

# Simulator (change to your preferred simulator)
SIM = iverilog
VVP = vvp

# Source files
SOURCES = pc.v imem.v regfile.v alu.v control.v alu_control.v \
          sign_extend.v dmem.v mux.v mips_cpu.v

# Testbench files
TESTBENCHES = pc_tb.v imem_tb.v regfile_tb.v alu_tb.v control_tb.v mips_cpu_tb.v

# Default target
all: test_all

# Individual module tests
test_pc: pc.v pc_tb.v
	$(SIM) -o pc_test pc.v pc_tb.v
	$(VVP) pc_test
	rm -f pc_test

test_imem: imem.v imem_tb.v
	$(SIM) -o imem_test imem.v imem_tb.v
	$(VVP) imem_test
	rm -f imem_test

test_regfile: regfile.v regfile_tb.v
	$(SIM) -o regfile_test regfile.v regfile_tb.v
	$(VVP) regfile_test
	rm -f regfile_test

test_alu: alu.v alu_tb.v
	$(SIM) -o alu_test alu.v alu_tb.v
	$(VVP) alu_test
	rm -f alu_test

test_control: control.v control_tb.v
	$(SIM) -o control_test control.v control_tb.v
	$(VVP) control_test
	rm -f control_test

# Full CPU test
test_cpu: $(SOURCES) mips_cpu_tb.v
	$(SIM) -o cpu_test $(SOURCES) mips_cpu_tb.v
	$(VVP) cpu_test
	rm -f cpu_test

# Test all modules
test_all: test_pc test_imem test_regfile test_alu test_control test_cpu

# Clean build files
clean:
	rm -f *_test *.vcd *.out

# Synthesize (requires synthesis tool)
synth:
	@echo "Synthesis requires a synthesis tool like Yosys"
	@echo "Example: yosys -p 'synth_ice40 -top mips_cpu' $(SOURCES)"

# Help
help:
	@echo "Available targets:"
	@echo "  test_pc      - Test Program Counter"
	@echo "  test_imem    - Test Instruction Memory"
	@echo "  test_regfile - Test Register File"
	@echo "  test_alu     - Test ALU"
	@echo "  test_control - Test Control Unit"
	@echo "  test_cpu     - Test Complete CPU"
	@echo "  test_all     - Test all modules"
	@echo "  clean        - Remove build files"
	@echo "  synth        - Synthesis info"
	@echo "  help         - Show this help"

.PHONY: all test_pc test_imem test_regfile test_alu test_control test_cpu test_all clean synth help