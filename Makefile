# RISC-V CPU Makefile
# Author: Your Name
# Date: $(shell date)

# Tools
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave
RISC64_GCC = riscv64-unknown-elf-gcc
RISC64_OBJDUMP = riscv64-unknown-elf-objdump

# Directories
RTL_DIR = rtl
TB_DIR = verification/testbench
BUILD_DIR = build
SIM_DIR = sim

# Source files
DEFINES = $(RTL_DIR)/common/defines.v $(RTL_DIR)/common/config.v

RTL_SOURCES = \
	$(RTL_DIR)/regfile/register_file.v \
	$(RTL_DIR)/execution/alu.v \
	$(RTL_DIR)/decode/decoder.v \
	$(RTL_DIR)/decode/imm_gen.v \
	$(RTL_DIR)/core/fetch_stage.v \
	$(RTL_DIR)/core/decode_stage.v \
	$(RTL_DIR)/core/execute_stage.v \
	$(RTL_DIR)/core/memory_stage.v \
	$(RTL_DIR)/core/writeback_stage.v \
	$(RTL_DIR)/core/forward_unit.v \
	$(RTL_DIR)/core/hazard_ctrl.v \
	$(RTL_DIR)/core/pipeline_ctrl.v \
	$(RTL_DIR)/core/branch_unit.v \
	$(RTL_DIR)/memory/instr_mem_if.v \
	$(RTL_DIR)/memory/data_mem_if.v \
	$(RTL_DIR)/top/riscv_core.v

TB_SOURCES = $(TB_DIR)/tb_top.v

# Default target
all: compile simulate

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Compilation
compile: $(BUILD_DIR)/tb_top.vvp

$(BUILD_DIR)/tb_top.vvp: $(RTL_SOURCES) $(TB_SOURCES) $(DEFINES) | $(BUILD_DIR)
	$(IVERILOG) -o $@ \
		-I$(RTL_DIR)/common \
		$(DEFINES) \
		$(RTL_SOURCES) \
		$(TB_SOURCES)

# Simulation
simulate: $(BUILD_DIR)/tb_top.vvp
	cd $(BUILD_DIR) && $(VVP) tb_top.vvp

# View waveform
wave: $(BUILD_DIR)/wave.vcd
	$(GTKWAVE) $(BUILD_DIR)/wave.vcd &

# Clean
clean:
	rm -rf $(BUILD_DIR)/*
	rm -f *.vcd
	rm -f *.out

# Run test
test: clean compile simulate

# Help
help:
	@echo "Available targets:"
	@echo "  all       : Compile and simulate (default)"
	@echo "  compile   : Compile Verilog sources"
	@echo "  simulate  : Run simulation"
	@echo "  wave      : View waveform"
	@echo "  clean     : Remove generated files"
	@echo "  test      : Clean, compile and simulate"
	@echo "  help      : Show this help message"

.PHONY: all compile simulate wave clean test help