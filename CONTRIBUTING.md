# Contributing to RISC-V_CPU

Thank you for your interest in contributing to RISC-V_CPU.

## How to Contribute
1. Fork the repository
2. Create a new branch for your feature or fix
3. Follow existing RTL coding and documentation standards
4. Add or update testbenches where applicable
5. Commit with clear and descriptive messages
6. Submit a pull request

## Repository Structure

Contributors are expected to follow the repository organization below:

RISC-V_CPU/
├── LICENSE
├── README.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── SECURITY.md
├── .gitignore
├── .gitattributes
├── Makefile
│
├── rtl/                              # RTL Design (Mandatory)
│   ├── top/
│   │   ├── riscv_top.v
│   │   └── riscv_top_params.vh
│   │
│   ├── core/
│   │   ├── if_stage.v                # Instruction Fetch
│   │   ├── id_stage.v                # Instruction Decode
│   │   ├── ex_stage.v                # Execute
│   │   ├── mem_stage.v               # Memory
│   │   ├── wb_stage.v                # Write Back
│   │   ├── control_unit.v            # Main Control
│   │   ├── hazard_unit.v             # Pipeline Hazard Control
│   │   ├── forwarding_unit.v         # Data Forwarding
│   │   ├── branch_unit.v             # Branch Prediction/Resolution
│   │   └── pipeline_regs.v           # Pipeline Registers
│   │
│   ├── alu/
│   │   ├── alu.v                     # Arithmetic Logic Unit
│   │   ├── alu_control.v
│   │   ├── multiplier.v              # Optional: Hardware multiplier
│   │   ├── divider.v                 # Optional: Hardware divider
│   │   └── shifter.v                 # Barrel shifter
│   │
│   ├── regfile/
│   │   ├── register_file.v           # Register File (32x32)
│   │   └── register_file_banked.v    # Optional: Banked for better timing
│   │
│   ├── decode/
│   │   ├── instruction_decoder.v
│   │   ├── imm_generator.v           # Immediate Generator
│   │   └── decoder_utils.v
│   │
│   ├── memory/
│   │   ├── icache.v                  # Instruction Cache
│   │   │   ├── icache_ctrl.v
│   │   │   └── icache_mem.v
│   │   │
│   │   ├── dcache.v                  # Data Cache
│   │   │   ├── dcache_ctrl.v
│   │   │   └── dcache_mem.v
│   │   │
│   │   ├── memory_interface.v        # Memory Bus Interface
│   │   ├── mmu.v                     # Memory Management Unit
│   │   ├── tlb.v                     # Translation Lookaside Buffer
│   │   └── bus/
│   │       ├── axi_interface.v       # AXI4 Interface
│   │       ├── ahb_interface.v       # AHB Interface
│   │       └── wishbone_interface.v  # Wishbone Interface
│   │
│   ├── csr/
│   │   ├── csr_file.v                # Control & Status Registers
│   │   ├── csr_registers.v           # CSR definitions
│   │   └── interrupt_controller.v    # Interrupt Controller
│   │
│   ├── debug/
│   │   ├── debug_module.v            # RISC-V Debug Module
│   │   └── jtag_tap.v                # JTAG TAP Controller
│   │
│   ├── common/
│   │   ├── defines.vh                # Global definitions
│   │   ├── parameters.vh             # Global parameters
│   │   ├── typedefs.svh              # SystemVerilog types
│   │   ├── muxes.v                   # Multiplexers
│   │   ├── synchronizers.v           # CDC synchronizers
│   │   └── reset_sync.v              # Reset synchronizer
│   │
│   └── peripherals/                  # Optional: Built-in peripherals
│       ├── uart.v
│       ├── gpio.v
│       ├── timer.v
│       └── plic.v                    # Platform-Level Interrupt Controller
│
├── verification/                     # Verification (Mandatory)
│   ├── tb/
│   │   ├── top_tb.sv                 # Top-level testbench
│   │   ├── alu_tb.sv
│   │   ├── regfile_tb.sv
│   │   ├── decoder_tb.sv
│   │   ├── cache_tb.sv
│   │   ├── csr_tb.sv
│   │   └── bus_tb.sv
│   │
│   ├── tests/
│   │   ├── riscv_isa/                # RISC-V ISA Tests
│   │   │   ├── rv32ui/               # Base Integer Tests
│   │   │   ├── rv32si/               # Supervisor Tests
│   │   │   ├── rv32mi/               # Machine Mode Tests
│   │   │   └── compliance/           # Compliance Tests
│   │   │
│   │   ├── directed/
│   │   │   ├── arithmetic/
│   │   │   ├── memory/
│   │   │   ├── branch/
│   │   │   └── interrupt/
│   │   │
│   │   ├── random/
│   │   │   └── riscv_dv/             # Random Instruction Generator
│   │   │
│   │   └── regression/
│   │       ├── smoke/                # Quick tests
│   │       ├── nightly/              # Full regression
│   │       └── weekly/               # Extended tests
│   │
│   ├── uvm/                          # UVM Environment (Preferred)
│   │   ├── env/
│   │   │   ├── riscv_env.sv
│   │   │   ├── riscv_env_cfg.sv
│   │   │   └── riscv_virtual_sequencer.sv
│   │   │
│   │   ├── agents/
│   │   │   ├── instruction_agent/
│   │   │   ├── memory_agent/
│   │   │   └── interrupt_agent/
│   │   │
│   │   ├── sequences/
│   │   │   ├── base_seq.sv
│   │   │   ├── riscv_base_seq.sv
│   │   │   └── test_lib.sv
│   │   │
│   │   ├── scoreboards/
│   │   │   ├── scoreboard.sv
│   │   │   └── reference_model.sv
│   │   │
│   │   ├── coverage/
│   │   │   ├── instruction_cov.sv
│   │   │   ├── register_cov.sv
│   │   │   └── functional_cov.sv
│   │   │
│   │   └── tests/
│   │       └── riscv_base_test.sv
│   │
│   ├── assertions/
│   │   ├── cpu_assertions.sv         # SystemVerilog Assertions
│   │   ├── formal/
│   │   │   └── properties.sv         # Formal verification properties
│   │   └── clock_domain_crossing.sv
│   │
│   └── models/
│       ├── iss/                      # Instruction Set Simulator
│       │   ├── spike_model.py
│       │   └── riscv_iss.cpp
│       │
│       └── performance/
│           └── cycle_model.py
│
├── sw/                               # Software Support
│   ├── linker/
│   │   ├── riscv.ld                  # Linker script
│   │   ├── memory_map.ld
│   │   └── sections.ld
│   │
│   ├── startup/
│   │   ├── crt0.S                    # Startup assembly
│   │   ├── vectors.S                 # Exception vectors
│   │   └── bootloader/               # Optional bootloader
│   │
│   ├── tests/
│   │   ├── hello_world.c
│   │   ├── exceptions.c
│   │   ├── interrupt_test.c
│   │   ├── cache_test.c
│   │   └── benchmark/
│   │       ├── coremark/
│   │       └── dhrystone/
│   │
│   ├── lib/
│   │   ├── stdlib/                   # Standard library
│   │   ├── drivers/                  # Peripheral drivers
│   │   └── bsp/                      # Board Support Package
│   │
│   └── toolchain/
│       ├── build.sh
│       ├── compile.py
│       └── makefile.common
│
├── docs/                             # Documentation (Mandatory)
│   ├── architecture_spec.md
│   ├── microarchitecture.md
│   ├── pipeline_diagram.pdf
│   ├── isa_support_matrix.md
│   ├── memory_map.md
│   ├── verification_plan.md
│   ├── integration_guide.md
│   ├── programming_guide.md
│   ├── performance_numbers.md
│   ├── known_limitations.md
│   ├── changelog.md
│   └── presentations/
│       └── design_review.pptx
│
├── scripts/                          # Build & Automation Scripts
│   ├── sim/
│   │   ├── run_iverilog.sh
│   │   ├── run_verilator.sh
│   │   ├── run_questa.do
│   │   ├── run_vcs.sh
│   │   └── run_xcelium.sh
│   │
│   ├── synth/
│   │   ├── yosys.tcl
│   │   ├── dc.tcl                    # Design Compiler
│   │   ├── genus.tcl
│   │   └── innovus.tcl               # Place & Route
│   │
│   ├── lint/
│   │   ├── verilator_lint.sh
│   │   ├── spyglass.tcl
│   │   └── ascent_lint.tcl
│   │
│   ├── formal/
│   │   ├── jasper.tcl
│   │   └── symbiyosys.tcl
│   │
│   ├── power/
│   │   ├── power_estimation.tcl
│   │   └── upf/                      # Unified Power Format
│   │
│   └── utils/
│       ├── check_licenses.py
│       ├── code_format.py
│       └── generate_docs.py
│
├── fpga/                             # FPGA Support
│   ├── constraints/
│   │   ├── xdc/                      # Xilinx
│   │   ├── sdc/                      # Intel/Altera
│   │   └── pcf/                      # Lattice
│   │
│   ├── implementation/
│   │   ├── vivado/
│   │   │   └── riscv_fpga.tcl
│   │   ├── quartus/
│   │   │   └── riscv_fpga.tcl
│   │   └── icestorm/
│   │       └── riscv_fpga.tcl
│   │
│   └── boards/
│       ├── zedboard/
│       ├── de10_nano/
│       └── ice40/
│
├── asic/                             # ASIC Implementation
│   ├── constraints/
│   │   ├── timing.sdc
│   │   ├── design_constraints.tcl
│   │   └── floorplan_constraints.tcl
│   │
│   ├── floorplan/
│   │   ├── floorplan.def
│   │   ├── io.def
│   │   └── placement.tcl
│   │
│   ├── power/
│   │   ├── power_intent.upf
│   │   ├── cpft.tcl
│   │   └── low_power.tcl
│   │
│   ├── physical/
│   │   ├── cts.tcl                   # Clock Tree Synthesis
│   │   ├── routing.tcl
│   │   ├── drc.tcl                   # Design Rule Check
│   │   └── lvs.tcl                   # Layout vs Schematic
│   │
│   └── reports/
│       ├── timing.rpt
│       ├── area.rpt
│       ├── power.rpt
│       └── drc.rpt
│
├── quality/                          # Quality Reports
│   ├── lint/
│   │   ├── lint_report.txt
│   │   └── waiver_file.rvl
│   │
│   ├── cdc/
│   │   ├── cdc_report.txt
│   │   └── cdc_waivers.txt
│   │
│   ├── rdc/
│   │   └── rdc_report.txt
│   │
│   ├── synthesis/
│   │   ├── qor_report.txt            # Quality of Results
│   │   └── utilization.rpt
│   │
│   └── coverage/
│       ├── functional_cov/
│       │   └── coverage_report.html
│       └── code_cov/
│           └── code_coverage.rpt
│
├── .github/                          # CI/CD Automation
│   └── workflows/
│       ├── rtl_lint.yml
│       ├── simulation.yml
│       ├── regression.yml
│       ├── synthesis.yml
│       ├── formal_verification.yml
│       └── documentation.yml
│
├── docker/                           # Containerization
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── scripts/
│       └── setup_env.sh
│
├── third_party/                      # External IP/Tools
│   ├── riscv-opcodes/                # RISC-V Opcodes
│   ├── riscv-tests/                  # Official test suite
│   └── bsd/                          # BSD licensed components
│
└── config/                           # Configuration Files
    ├── core_config.yml               # Core configuration
    ├── verification_config.yml
    ├── synthesis_config.yml
    └── fpga_config.yml
    

## Coding Guidelines
- Use synthesizable Verilog/SystemVerilog constructs only
- Follow synchronous design practices
- Avoid hard-coded values; use parameters
- Maintain readability and modularity

## Reporting Issues
Please use the GitHub Issues tab to report bugs or request enhancements.

All contributions must comply with the Code of Conduct.