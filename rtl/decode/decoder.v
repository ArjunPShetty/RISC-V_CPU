module decoder (
    input  wire [31:0]          instr,
    output reg  [6:0]           opcode,
    output reg  [4:0]           rd,
    output reg  [2:0]           funct3,
    output reg  [4:0]           rs1,
    output reg  [4:0]           rs2,
    output reg  [6:0]           funct7,
    output reg  [11:0]          csr_addr,
    output reg                  is_load,
    output reg                  is_store,
    output reg                  is_branch,
    output reg                  is_jal,
    output reg                  is_jalr,
    output reg                  is_lui,
    output reg                  is_auipc,
    output reg                  is_system
);

    always @(*) begin
        opcode = instr[6:0];
        rd = instr[11:7];
        funct3 = instr[14:12];
        rs1 = instr[19:15];
        rs2 = instr[24:20];
        funct7 = instr[31:25];
        csr_addr = instr[31:20];

        // Instruction type detection
        is_load = (opcode == `OPCODE_LOAD);
        is_store = (opcode == `OPCODE_STORE);
        is_branch = (opcode == `OPCODE_BRANCH);
        is_jal = (opcode == `OPCODE_JAL);
        is_jalr = (opcode == `OPCODE_JALR);
        is_lui = (opcode == `OPCODE_LUI);
        is_auipc = (opcode == `OPCODE_AUIPC);
        is_system = (opcode == `OPCODE_SYSTEM);
    end

endmodule