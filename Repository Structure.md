## Repository Structure

Contributors are expected to follow the repository organization below:

RISC-V_CPU/
├── LICENSE
├── README.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── .gitignore
├── Makefile
│
├── rtl/                              # RTL Design (Verilog Only)
│   ├── top/
│   │   ├── riscv_core.v              # Top-level CPU core
│   │   ├── riscv_soc.v               # System-on-Chip (optional)
│   │   └── riscv_top.v               # Top with peripherals
│   │
│   ├── core/
│   │   ├── riscv_pipeline.v          # Main pipeline wrapper
│   │   ├── fetch_stage.v             # Instruction fetch
│   │   ├── decode_stage.v            # Instruction decode
│   │   ├── execute_stage.v           # Execute
│   │   ├── memory_stage.v            # Memory access
│   │   ├── writeback_stage.v         # Write back
│   │   ├── pipeline_ctrl.v           # Pipeline control
│   │   ├── hazard_ctrl.v             # Hazard detection
│   │   ├── forward_unit.v            # Data forwarding
│   │   └── branch_unit.v             # Branch handling
│   │
│   ├── execution/
│   │   ├── alu.v                     # Arithmetic Logic Unit
│   │   ├── alu_ctrl.v                # ALU control
│   │   ├── mul_div_unit.v            # Multiply/Divide (optional)
│   │   ├── shifter.v                 # Barrel shifter
│   │   └── compare_unit.v            # Comparison unit
│   │
│   ├── regfile/
│   │   ├── register_file.v           # 32x32 register file
│   │   └── regfile_forward.v         # Register forwarding
│   │
│   ├── decode/
│   │   ├── decoder.v                 # Instruction decoder
│   │   ├── imm_gen.v                 # Immediate generator
│   │   └── csr_addr_decode.v         # CSR address decode
│   │
│   ├── memory/
│   │   ├── data_mem_if.v             # Data memory interface
│   │   ├── instr_mem_if.v            # Instruction memory interface
│   │   ├── cache/
│   │   │   ├── cache_controller.v    # Cache controller
│   │   │   ├── cache_sram.v          # Cache memory
│   │   │   └── cache_tags.v          # Tag memory
│   │   ├── bus/
│   │   │   ├── wishbone_if.v         # Wishbone interface
│   │   │   ├── axi_lite_if.v         # AXI-Lite interface
│   │   │   └── bus_arbiter.v         # Bus arbiter
│   │   └── mmu/
│   │       ├── mmu.v                 # Memory Management Unit
│   │       └── tlb.v                 # Translation Lookaside Buffer
│   │
│   ├── csr/
│   │   ├── csr_file.v                # Control & Status Registers
│   │   ├── csr_regs.v                # CSR register definitions
│   │   ├── interrupt_ctrl.v          # Interrupt controller
│   │   └── timer_unit.v              # Timer unit
│   │
│   ├── debug/
│   │   ├── debug_module.v            # Debug module
│   │   └── jtag_dtm.v                # JTAG Debug Transport Module
│   │
│   ├── common/
│   │   ├── defines.v                 # Global definitions
│   │   ├── config.v                  # Configuration parameters
│   │   ├── muxes.v                   # Multiplexers
│   │   ├── flipflops.v               # Flip-flop collections
│   │   ├── sync_reset.v              # Reset synchronizer
│   │   └── clock_gating.v            # Clock gating cells
│   │
│   └── peripherals/                  # On-chip peripherals
│       ├── uart/
│       │   ├── uart_core.v
│       │   ├── uart_tx.v
│       │   └── uart_rx.v
│       ├── gpio/
│       │   ├── gpio_core.v
│       │   └── gpio_pads.v
│       ├── spi/
│       │   ├── spi_master.v
│       │   └── spi_slave.v
│       └── plic.v                    # Platform-Level Interrupt Controller
│
├── verification/                     # Verification (Verilog TBs)
│   ├── testbench/
│   │   ├── tb_top.v                  # Top-level testbench
│   │   ├── tb_memory.v               # Memory model
│   │   ├── tb_peripherals.v          # Peripheral models
│   │   ├── tb_monitor.v              # Monitor
│   │   ├── tb_checker.v              # Checker/Scoreboard
│   │   └── tb_driver.v               # Test driver
│   │
│   ├── tests/
│   │   ├── unit_tests/
│   │   │   ├── test_alu.v
│   │   │   ├── test_regfile.v
│   │   │   ├── test_decoder.v
│   │   │   ├── test_cache.v
│   │   │   └── test_csr.v
│   │   │
│   │   ├── isa_tests/
│   │   │   ├── rv32i_tests/          # Base integer tests
│   │   │   │   ├── test_add.v
│   │   │   │   ├── test_load_store.v
│   │   │   │   ├── test_branch.v
│   │   │   │   └── test_jump.v
│   │   │   ├── rv32m_tests/          # Multiply/divide tests
│   │   │   │   ├── test_mul.v
│   │   │   │   └── test_div.v
│   │   │   ├── rv32c_tests/          # Compressed tests (optional)
│   │   │   └── rv32zicsr_tests/      # CSR tests
│   │   │
│   │   ├── integration_tests/
│   │   │   ├── test_pipeline.v
│   │   │   ├── test_interrupts.v
│   │   │   ├── test_exceptions.v
│   │   │   └── test_cache_coherency.v
│   │   │
│   │   ├── performance_tests/
│   │   │   ├── test_dhrystone.v
│   │   │   └── test_coremark.v
│   │   │
│   │   └── compliance_tests/         # RISC-V compliance suite
│   │       ├── rv32ui/
│   │       ├── rv32um/
│   │       └── rv32ua/               # Atomic (optional)
│   │
│   ├── models/
│   │   ├── golden_model/             # Reference model
│   │   │   ├── riscv_model.v
│   │   │   ├── instruction_sim.v
│   │   │   └── memory_model.v
│   │   └── iss_wrapper/              # ISS interface
│   │       ├── spike_wrapper.v
│   │       └── riscv_iss_if.v
│   │
│   └── coverage/
│       ├── functional_cov.v          # Functional coverage (manual)
│       ├── code_cov.v                # Code coverage hooks
│       └── assertion_cov.v           # Assertion coverage
│
├── software/                         # Software Support
│   ├── boot/
│   │   ├── bootrom.v                 # Boot ROM RTL
│   │   ├── bootloader.c              # Bootloader C code
│   │   └── vectors.S                 # Exception vectors
│   │
│   ├── tests/
│   │   ├── assembly/
│   │   │   ├── basic_test.S
│   │   │   ├── interrupt_test.S
│   │   │   └── exception_test.S
│   │   ├── c_programs/
│   │   │   ├── hello_world.c
│   │   │   ├── fibonacci.c
│   │   │   ├── matrix_mult.c
│   │   │   └── sort_test.c
│   │   └── benchmarks/
│   │       ├── dhrystone/
│   │       ├── coremark/
│   │       └── embench/
│   │
│   ├── lib/
│   │   ├── crt0.S                    # Startup code
│   │   ├── syscalls.c                # System calls
│   │   ├── printf.c                  # Minimal printf
│   │   ├── string.c                  # String functions
│   │   └── drivers/
│   │       ├── uart.c
│   │       ├── gpio.c
│   │       └── timer.c
│   │
│   ├── linker/
│   │   ├── memory_map.ld             # Memory map
│   │   ├── sections.ld               # Section placement
│   │   └── scripts/
│   │       ├── sim.ld                # Simulation linker script
│   │       ├── fpga.ld               # FPGA linker script
│   │       └── asic.ld               # ASIC linker script
│   │
│   └── toolchain/
│       ├── build_tools.sh            # Toolchain setup
│       ├── compile_script.sh         # Compilation script
│       └── run_sim.sh                # Simulation run script
│
├── docs/                             # Documentation
│   ├── specification/
│   │   ├── architecture.md           # Architecture spec
│   │   ├── microarchitecture.md      # Microarchitecture details
│   │   ├── pipeline.md               # Pipeline description
│   │   ├── memory_system.md          # Memory hierarchy
│   │   ├── interrupt_system.md       # Interrupt handling
│   │   └── debug_system.md           # Debug features
│   │
│   ├── implementation/
│   │   ├── design_guide.md           # Design guidelines
│   │   ├── coding_style.md           # Verilog coding style
│   │   ├── timing_closure.md         # Timing considerations
│   │   └── area_optimization.md      # Area optimization
│   │
│   ├── verification/
│   │   ├── verification_plan.md      # Verification strategy
│   │   ├── test_plan.md              # Test plan
│   │   ├── coverage_plan.md          # Coverage goals
│   │   └── regression.md             # Regression testing
│   │
│   ├── software/
│   │   ├── programming_guide.md      # Software guide
│   │   ├── api_reference.md          # Driver APIs
│   │   ├── boot_sequence.md          # Boot process
│   │   └── porting_guide.md          # Porting to new platforms
│   │
│   ├── integration/
│   │   ├── fpga_integration.md       # FPGA integration guide
│   │   ├── asic_integration.md       # ASIC integration guide
│   │   └── soc_integration.md        # SoC integration guide
│   │
│   └── diagrams/                     # Visual documentation
│       ├── pipeline_diagram.svg
│       ├── block_diagram.svg
│       ├── memory_map.svg
│       └── timing_diagrams/
│
├── scripts/                          # Automation Scripts
│   ├── simulation/
│   │   ├── run_simulation.sh         # Generic simulation script
│   │   ├── run_iverilog.sh           # Icarus Verilog
│   │   ├── run_verilator.sh          # Verilator
│   │   ├── run_modelsim.sh           # ModelSim/Questa
│   │   ├── run_vcs.sh                # VCS
│   │   └── run_xsim.sh               # Xilinx Vivado Sim
│   │
│   ├── synthesis/
│   │   ├── synth_generic.tcl         # Generic synthesis
│   │   ├── synth_yosys.tcl           # Yosys synthesis
│   │   ├── synth_vivado.tcl          # Vivado synthesis
│   │   ├── synth_quartus.tcl         # Quartus synthesis
│   │   └── synth_dc.tcl              # Design Compiler
│   │
│   ├── lint/
│   │   ├── run_verilator_lint.sh     # Verilator linting
│   │   ├── lint_checklist.txt        # Lint checklist
│   │   └── waiver_file.txt           # Lint waivers
│   │
│   ├── formal/
│   │   ├── formal_setup.tcl          # Formal verification setup
│   │   ├── property_check.tcl        # Property checking
│   │   └── equivalence_check.tcl     # Equivalence checking
│   │
│   ├── power/
│   │   ├── power_analysis.tcl        # Power analysis
│   │   └── clock_gating_insertion.tcl
│   │
│   └── utils/
│       ├── check_code_style.py       # Code style checker
│       ├── generate_docs.py          # Documentation generator
│       ├── update_configs.py         # Configuration updater
│       └── create_release.py         # Release packaging
│
├── fpga/                             # FPGA Implementation
│   ├── constraints/
│   │   ├── clocks.xdc               # Clock constraints
│   │   ├── pins.xdc                 # Pin constraints
│   │   ├── timing.xdc               # Timing exceptions
│   │   └── area.xdc                 # Area constraints
│   │
│   ├── projects/
│   │   ├── xilinx/
│   │   │   ├── zynq7000/
│   │   │   │   └── zedboard/
│   │   │   ├── artix7/
│   │   │   │   └── nexys4/
│   │   │   └── kintex7/
│   │   │       └── kc705/
│   │   ├── intel/
│   │   │   ├── cyclone5/
│   │   │   │   └── de10_nano/
│   │   │   └── max10/
│   │   │       └── de10_lite/
│   │   ├── lattice/
│   │   │   └── ice40/
│   │   │       └── icebreaker/
│   │   └── quicklogic/
│   │       └── quickfeather/
│   │
│   └── bitstreams/                   # Pre-built bitstreams
│       ├── README.md
│       └── versioned/
│
├── asic/                             # ASIC Implementation
│   ├── flow/
│   │   ├── synthesis/
│   │   │   ├── constraints.sdc       # Timing constraints
│   │   │   ├── synthesis.tcl         # Synthesis script
│   │   │   └── reports/              # Synthesis reports
│   │   ├── floorplan/
│   │   │   ├── floorplan.tcl
│   │   │   ├── io_placement.tcl
│   │   │   └── power_plan.tcl
│   │   ├── placement/
│   │   │   ├── placement.tcl
│   │   │   ├── optimization.tcl
│   │   │   └── clock_tree.tcl
│   │   ├── routing/
│   │   │   ├── global_route.tcl
│   │   │   ├── detailed_route.tcl
│   │   │   └── fill_insertion.tcl
│   │   └── verification/
│   │       ├── drc_check.tcl
│   │       ├── lvs_check.tcl
│   │       └── timing_signoff.tcl
│   │
│   ├── libraries/                    # Technology libraries
│   │   ├── std_cells.lib
│   │   ├── memory_compiler.lib
│   │   └── io_cells.lib
│   │
│   └── tapeout/                      # Tapeout files
│       ├── gds/
│       ├── lef/
│       └── verilog_netlist/
│
├── config/                           # Configuration Files
│   ├── core_config.v                 # Core configuration (Verilog)
│   ├── memory_config.v               # Memory configuration
│   ├── peripheral_config.v           # Peripheral configuration
│   ├── test_config.v                 # Test configuration
│   └── platform_config.v             # Platform configuration
│
├── tools/                            # Development Tools
│   ├── verilog_tools/
│   │   ├── code_linter/
│   │   ├── auto_formatter/
│   │   └── template_generator/
│   ├── test_tools/
│   │   ├── test_generator/
│   │   └── coverage_analyzer/
│   └── analysis_tools/
│       ├── power_estimator/
│       ├── area_analyzer/
│       └── timing_analyzer/
│
└── ci_cd/                           # Continuous Integration
    ├── Jenkinsfile
    ├── gitlab-ci.yml
    ├── workflows/
    │   ├── lint_check.yml
    │   ├── simulation_test.yml
    │   ├── synthesis_check.yml
    │   └── regression_test.yml
    └── reports/
        ├── test_results/
        ├── coverage_reports/
        └── quality_metrics/