# RISC-V_CPU

RISC-V_CPU is an open-source, industry-oriented implementation of a **RISC-V processor core** written in **synthesizable Verilog HDL**.  
The project is designed to follow **professional RTL design, verification, and documentation practices** suitable for **ASIC and FPGA development**, as well as for educational and research purposes.

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

## Key Features

- Fully synthesizable **Verilog RTL**
- Clean, modular, and readable design
- Pipeline-based CPU microarchitecture
- RV32I instruction support
- Structured control unit and ALU decoder
- Verification-ready repository layout
- Lint-friendly and synthesis-safe coding style
- Open-source and extensible for future enhancements

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
- Maintain a scope suitable for **mentored open-source programs** (e.g., GSSoC)

---

License
This project is licensed under the MIT License.
See the LICENSE file for details.

Maintainer
Arjun P Shetty
Open to collaboration, mentorship, and community contributions.

---

## Getting Started

### Clone the Repository
```bash
git clone https://github.com/ArjunPShetty/RISC-V_CPU.git
cd RISC-V_CPU

