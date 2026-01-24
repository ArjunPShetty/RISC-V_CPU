## Repository Structure

Contributors are expected to follow the repository organization below:

RISC-V_CPU/
├── README.md
├── LICENSE
├── .gitignore
├── Makefile
├── rtl/
│ ├── top/
│ │ └── riscv_core.v
│ ├── core/
│ │ ├── fetch_stage.v
│ │ ├── decode_stage.v
│ │ ├── execute_stage.v
│ │ ├── memory_stage.v
│ │ ├── writeback_stage.v
│ │ ├── pipeline_ctrl.v
│ │ ├── hazard_ctrl.v
│ │ ├── forward_unit.v
│ │ └── branch_unit.v
│ ├── execution/
│ │ └── alu.v
│ ├── regfile/
│ │ └── register_file.v
│ ├── decode/
│ │ ├── decoder.v
│ │ └── imm_gen.v
│ ├── memory/
│ │ ├── instr_mem_if.v
│ │ └── data_mem_if.v
│ └── common/
│ ├── defines.v
│ └── config.v
├── verification/
│ ├── testbench/
│ │ └── tb_top.v
│ └── tests/
│ └── rv32i/
│ ├── test_add.v
│ ├── test_load_store.v
│ ├── test_branch.v
│ └── test_jump.v
├── software/
│ ├── tests/
│ │ ├── assembly/
│ │ │ └── basic_test.S
│ │ └── c_programs/
│ │ └── hello_world.c
│ └── linker/
│ └── memory_map.ld
└── scripts/
└── run_sim.sh