// CPU Configuration Parameters
`ifndef CONFIG_V
`define CONFIG_V

`define DATA_WIDTH      32
`define ADDR_WIDTH      32
`define REG_ADDR_WIDTH  5
`define INSTR_WIDTH     32
`define REG_FILE_SIZE   32
`define PC_RESET        32'h00000000
`define MEM_SIZE        1024  // 1KB memory

// Pipeline configuration
`define ENABLE_FORWARDING   1
`define ENABLE_BRANCH_PRED  0  // Simple always-not-taken for now

`endif