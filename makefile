# Makefile for MIPS CPU Verilog Project

# Simulator (change to your preferred simulator)
SIM = iverilog
VVP = vvp

# Folders
SRC_DIR = src
TB_DIR  = tb

# Source files
SOURCES = $(SRC_DIR)/pc.v $(SRC_DIR)/imem.v $(SRC_DIR)/regfile.v \
          $(SRC_DIR)/alu.v $(SRC_DIR)/control.v $(SRC_DIR)/alu_control.v \
          $(SRC_DIR)/sign_extend.v $(SRC_DIR)/dmem.v $(SRC_DIR)/mux.v \
          $(SRC_DIR)/mips_cpu.v

# Testbench files
TESTBENCHES = $(TB_DIR)/pc_tb.v $(TB_DIR)/imem_tb.v $(TB_DIR)/regfile_tb.v \
              $(TB_DIR)/alu_tb.v $(TB_DIR)/control_tb.v $(TB_DIR)/mips_cpu_tb.v

# Default target
all: test_all

# Individual module tests
test_pc: $(SRC_DIR)/pc.v $(TB_DIR)/pc_tb.v
	$(SIM) -o pc_test $^
	$(VVP) pc_test
	rm -f pc_test

test_imem: $(SRC_DIR)/imem.v $(TB_DIR)/imem_tb.v
	$(SIM) -o imem_test $^
	$(VVP) imem_test
	rm -f imem_test

test_regfile: $(SRC_DIR)/regfile.v $(TB_DIR)/regfile_tb.v
	$(SIM) -o regfile_test $^
	$(VVP) regfile_test
	rm -f regfile_test

test_alu: $(SRC_DIR)/alu.v $(TB_DIR)/alu_tb.v
	$(SIM) -o alu_test $^
	$(VVP) alu_test
	rm -f alu_test

test_control: $(SRC_DIR)/control.v $(TB_DIR)/control_tb.v
	$(SIM) -o control_test $^
	$(VVP) control_test
	rm -f control_test

# Full CPU test
test_cpu: $(SOURCES) $(TB_DIR)/mips_cpu_tb.v
	$(SIM) -o cpu_test $^
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
