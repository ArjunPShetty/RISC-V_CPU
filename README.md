# RISC-V_CPU

RISC-V_CPU is an open-source, industry-oriented implementation of a **RISC-V processor core** written in **synthesizable Verilog HDL**.  

This repository aims to provide a clean, modular, and extensible RISC-V CPU baseline that contributors can study, verify, and enhance.

---

## Architecture Overview

- ISA: **RISC-V RV32I (Base Integer Instruction Set)**
- Microarchitecture: **Classic 5-stage pipeline**
  - Instruction Fetch (IF)
  - Instruction Decode (ID)
  - Execute (EX)
  - Memory Access (MEM)
  - Write Back (WB)
- Pipeline features:
  - Modular pipeline stages
  - Centralized control logic
  - ALU control and instruction decoding
  - Forwarding and hazard handling (incremental)
  - Synthesis-safe control paths

---

## **Key Features Implemented:**

1. **5-stage Pipeline**: IF, ID, EX, MEM, WB
2. **RV32I ISA Support**: All base integer instructions
3. **Data Forwarding**: EX→EX and MEM→EX forwarding paths
4. **Hazard Detection**: Load-use hazard stalling
5. **Branch Handling**: Basic branch prediction (always-not-taken)
6. **Memory System**: Byte/halfword/word memory access
7. **Complete Testbench**: With sample test program
8. **Build System**: Makefile and simulation scripts

---

## Project Goals

- Provide a **realistic industry-style RISC-V RTL codebase**
- Serve as a **learning and contribution platform** for EC / VLSI students
- Enable contributors to work on:
  - Instruction decoding
  - Control logic
  - Pipeline hazards
  - Verification and testbenches
  - RTL refactoring and cleanup

Keeping the project structure and documentation updated helps maintain clarity, improves collaboration, and ensures the project remains accessible to new contributors.

---

License
This project is licensed under the MIT License.
See the LICENSE file for details.

Maintainer
Arjun P Shetty
Open to collaboration, mentorship, and community contributions.

---

## Documentation
Detailed design and verification documents are available in the `docs/` directory.

## Contributing
Please read `CONTRIBUTING.md` before submitting changes.

## Security
See `SECURITY.md` for responsible disclosure.

## Getting Started

### Clone the Repository
```bash
git clone https://github.com/ArjunPShetty/RISC-V_CPU.git
cd RISC-V_CPU

