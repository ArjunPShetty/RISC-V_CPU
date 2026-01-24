#!/bin/bash
# Compile and simulate script
# RISC-V CPU Simulation Script
# Usage: ./run_sim.sh [test_name]

set -e

# Configuration
BUILD_DIR="../build"
TEST_NAME=${1:-"basic_test"}
WAVE_FORMAT="vcd"

echo "========================================"
echo "RISC-V CPU Simulation"
echo "Test: $TEST_NAME"
echo "========================================"

# Create build directory
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# Clean previous build
echo "Cleaning previous build..."
rm -f *.vvp *.vcd

# Compile
echo "Compiling sources..."
iverilog -o tb_top.vvp \
    -I../rtl/common \
    ../rtl/common/defines.v \
    ../rtl/common/config.v \
    ../rtl/regfile/register_file.v \
    ../rtl/execution/alu.v \
    ../rtl/decode/decoder.v \
    ../rtl/decode/imm_gen.v \
    ../rtl/core/fetch_stage.v \
    ../rtl/core/decode_stage.v \
    ../rtl/core/execute_stage.v \
    ../rtl/core/memory_stage.v \
    ../rtl/core/writeback_stage.v \
    ../rtl/core/forward_unit.v \
    ../rtl/core/hazard_ctrl.v \
    ../rtl/core/pipeline_ctrl.v \
    ../rtl/core/branch_unit.v \
    ../rtl/memory/instr_mem_if.v \
    ../rtl/memory/data_mem_if.v \
    ../rtl/top/riscv_core.v \
    ../verification/testbench/tb_top.v

# Check if compilation succeeded
if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

echo "Compilation successful!"

# Run simulation
echo "Running simulation..."
vvp tb_top.vvp

# Check simulation result
if [ $? -ne 0 ]; then
    echo "Simulation failed!"
    exit 1
fi

echo "========================================"
echo "Simulation completed successfully!"
echo "========================================"

# Optional: Open waveform
if [ "$2" == "--wave" ]; then
    if [ -f wave.vcd ]; then
        echo "Opening waveform viewer..."
        gtkwave wave.vcd &
    else
        echo "Warning: No waveform file found"
    fi
fi