## **Complete Files List :**

### **1. Configuration & Common Files:**
1. **`rtl/common/defines.v`** - RISC-V instruction opcodes, ALU operations, branch types, control signals
2. **`rtl/common/config.v`** - CPU parameters (data width, address width, memory size, pipeline config)

### **2. Core CPU Components:**
3. **`rtl/regfile/register_file.v`** - 32x32 register file with dual read, single write port
4. **`rtl/execution/alu.v`** - Arithmetic Logic Unit with all RV32I operations
5. **`rtl/decode/decoder.v`** - Instruction decoder to extract opcode, registers, immediates
6. **`rtl/decode/imm_gen.v`** - Immediate value generator for all instruction formats

### **3. Pipeline Stages:**
7. **`rtl/core/fetch_stage.v`** - Instruction Fetch stage with PC logic
8. **`rtl/core/decode_stage.v`** - Decode stage with control unit and register read
9. **`rtl/core/execute_stage.v`** - Execute stage with ALU and branch evaluation
10. **`rtl/core/memory_stage.v`** - Memory stage for load/store operations
11. **`rtl/core/writeback_stage.v`** - Writeback stage for register write

### **4. Pipeline Control Logic:**
12. **`rtl/core/pipeline_ctrl.v`** - Pipeline control for stalls/flushes
13. **`rtl/core/hazard_ctrl.v`** - Hazard detection unit
14. **`rtl/core/forward_unit.v`** - Data forwarding unit
15. **`rtl/core/branch_unit.v`** - Branch target calculation and control

### **5. Memory Interfaces:**
16. **`rtl/memory/instr_mem_if.v`** - Instruction memory interface
17. **`rtl/memory/data_mem_if.v`** - Data memory interface

### **6. Top-Level & Testbench:**
18. **`rtl/top/riscv_core.v`** - Complete CPU top-level module (pulls everything together)
19. **`verification/testbench/tb_top.v`** - Full testbench with memory simulation

### **7. Build & Project Files:**
20. **`Makefile`** - Complete build system with compile, simulate, clean targets
21. **`scripts/run_sim.sh`** - Simulation script with compilation and execution

### **8. Software/Test Files:**
22. **`software/tests/assembly/basic_test.S`** - Assembly test program
23. **`software/linker/memory_map.ld`** - Linker script for memory mapping
24. **`.gitignore`** - Git ignore file for build artifacts

### Project Structure and Feature Update Policy

Contributors are requested to **keep the project structure up to date** at all times.

* If you **create a new file, folder, or module**, please update the project structure section accordingly.
* If you **modify existing modules** or **add new features**, ensure the changes are clearly reflected in:

  * Project directory tree
  * Relevant documentation (README or docs folder)
  * Comments where applicable
* Any **major architectural change or new feature** should be briefly described so that other contributors can easily understand its purpose and usage.