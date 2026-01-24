## Repository Structure

Contributors are expected to follow the repository organization below:

RISC-V_CPU/
├── README.md
├── LICENSE
├── .gitignore
├── Makefile

├── rtl/
│   ├── top/
│   │   └── riscv_core.v            # Top-level CPU
│   │
│   ├── core/
│   │   ├── fetch_stage.v           # IF stage
│   │   ├── decode_stage.v          # ID stage
│   │   ├── execute_stage.v         # EX stage
│   │   ├── memory_stage.v          # MEM stage
│   │   ├── writeback_stage.v       # WB stage
│   │   ├── pipeline_ctrl.v         # Pipeline control
│   │   ├── hazard_ctrl.v           # Hazard detection
│   │   ├── forward_unit.v          # Forwarding logic
│   │   └── branch_unit.v           # Branch handling
│   │
│   ├── execution/
│   │   └── alu.v                   # ALU
│   │
│   ├── regfile/
│   │   └── register_file.v         # 32x32 register file
│   │
│   ├── decode/
│   │   ├── decoder.v               # Instruction decode
│   │   └── imm_gen.v               # Immediate generator
│   │
│   ├── memory/
│   │   ├── instr_mem_if.v          # Instruction memory interface
│   │   └── data_mem_if.v           # Data memory interface
│   │
│   └── common/
│       ├── defines.v               # ISA constants
│       └── config.v                # Core parameters

├── verification/
│   ├── testbench/
│   │   └── tb_top.v                # Top testbench
│   │
│   └── tests/
│       └── rv32i/
│           ├── test_add.v
│           ├── test_load_store.v
│           ├── test_branch.v
│           └── test_jump.v

├── software/
│   ├── tests/
│   │   ├── assembly/
│   │   │   └── basic_test.S
│   │   └── c_programs/
│   │       └── hello_world.c
│   │
│   └── linker/
│       └── memory_map.ld

└── scripts/
    └── run_sim.sh                  # Compile + simulate
