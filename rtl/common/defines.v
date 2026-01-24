// RISC-V RV32I Instruction Definitions
`ifndef DEFINES_V
`define DEFINES_V

// Instruction opcodes (bits 6:0)
`define OPCODE_LOAD     7'b0000011
`define OPCODE_STORE    7'b0100011
`define OPCODE_OP_IMM   7'b0010011
`define OPCODE_OP       7'b0110011
`define OPCODE_BRANCH   7'b1100011
`define OPCODE_JAL      7'b1101111
`define OPCODE_JALR     7'b1100111
`define OPCODE_LUI      7'b0110111
`define OPCODE_AUIPC    7'b0010111
`define OPCODE_SYSTEM   7'b1110011

// ALU operations
`define ALU_ADD     4'b0000
`define ALU_SUB     4'b0001
`define ALU_SLL     4'b0010
`define ALU_SLT     4'b0011
`define ALU_SLTU    4'b0100
`define ALU_XOR     4'b0101
`define ALU_SRL     4'b0110
`define ALU_SRA     4'b0111
`define ALU_OR      4'b1000
`define ALU_AND     4'b1001

// Branch types
`define BRANCH_NO   3'b000
`define BRANCH_EQ   3'b001
`define BRANCH_NE   3'b010
`define BRANCH_LT   3'b011
`define BRANCH_GE   3'b100
`define BRANCH_LTU  3'b101
`define BRANCH_GEU  3'b110

// Memory operation types
`define MEM_BYTE    3'b000
`define MEM_HALF    3'b001
`define MEM_WORD    3'b010
`define MEM_BYTE_U  3'b100
`define MEM_HALF_U  3'b101

// Control signals
`define PC_SRC_PC4      2'b00
`define PC_SRC_BRANCH   2'b01
`define PC_SRC_JAL      2'b10
`define PC_SRC_JALR     2'b11

// Data hazard types
`define HAZARD_NONE     2'b00
`define HAZARD_LOAD     2'b01
`define HAZARD_STRUCT   2'b10

// Pipeline register widths
`define IF_ID_WIDTH     64
`define ID_EX_WIDTH     150
`define EX_MEM_WIDTH    108
`define MEM_WB_WIDTH    106

`endif