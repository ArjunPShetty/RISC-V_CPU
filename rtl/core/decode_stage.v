# ID stage
module decode_stage (
    input  wire         clk,
    input  wire         rst_n,
    
    // Pipeline input
    input  wire [31:0]  id_pc,
    input  wire [31:0]  id_instr,
    input  wire         id_valid,
    
    // Register file interface
    output wire [4:0]   rs1_addr,
    output wire [4:0]   rs2_addr,
    input  wire [31:0]  rs1_data,
    input  wire [31:0]  rs2_data,
    
    // Control signals output
    output reg  [3:0]   id_alu_op,
    output reg          id_alu_src,
    output reg          id_mem_read,
    output reg          id_mem_write,
    output reg  [2:0]   id_mem_type,
    output reg          id_reg_write,
    output reg  [1:0]   id_wb_sel,
    output reg  [2:0]   id_branch_type,
    output reg          id_is_jal,
    output reg          id_is_jalr,
    
    // Data outputs
    output reg  [31:0]  id_rs1_data,
    output reg  [31:0]  id_rs2_data,
    output reg  [31:0]  id_imm,
    output reg  [4:0]   id_rd,
    output reg  [4:0]   id_rs1,
    output reg  [4:0]   id_rs2,
    output reg  [31:0]  id_pc_out,
    
    // Hazard control
    input  wire         stall,
    input  wire         flush
);

    // Internal wires
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;
    
    wire is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc;
    
    // Instantiate decoder
    decoder u_decoder (
        .instr(id_instr),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .is_load(is_load),
        .is_store(is_store),
        .is_branch(is_branch),
        .is_jal(is_jal),
        .is_jalr(is_jalr),
        .is_lui(is_lui),
        .is_auipc(is_auipc)
    );
    
    // Immediate generator
    imm_gen u_imm_gen (
        .instr(id_instr),
        .imm_type(funct3),  // Simplified - should be based on opcode
        .imm_out(id_imm)
    );
    
    // Control unit logic
    always @(*) begin
        if (!id_valid || stall || flush) begin
            // Default control signals
            id_alu_op = `ALU_ADD;
            id_alu_src = 1'b0;
            id_mem_read = 1'b0;
            id_mem_write = 1'b0;
            id_mem_type = 3'b000;
            id_reg_write = 1'b0;
            id_wb_sel = 2'b00;
            id_branch_type = `BRANCH_NO;
            id_is_jal = 1'b0;
            id_is_jalr = 1'b0;
            id_rd = 5'b0;
            id_rs1 = 5'b0;
            id_rs2 = 5'b0;
        end else begin
            // Set default values
            id_alu_op = `ALU_ADD;
            id_alu_src = 1'b0;
            id_mem_read = 1'b0;
            id_mem_write = 1'b0;
            id_reg_write = 1'b0;
            id_wb_sel = 2'b00;
            id_branch_type = `BRANCH_NO;
            id_is_jal = 1'b0;
            id_is_jalr = 1'b0;
            
            // Set register addresses
            id_rd = rd;
            id_rs1 = rs1;
            id_rs2 = rs2;
            
            // ALU control
            case (opcode)
                `OPCODE_OP_IMM: begin
                    id_alu_src = 1'b1;
                    id_reg_write = 1'b1;
                    id_wb_sel = 2'b00;  // ALU result
                    
                    case (funct3)
                        3'b000: id_alu_op = `ALU_ADD;  // ADDI
                        3'b010: id_alu_op = `ALU_SLT;  // SLTI
                        3'b011: id_alu_op = `ALU_SLTU; // SLTIU
                        3'b100: id_alu_op = `ALU_XOR;  // XORI
                        3'b110: id_alu_op = `ALU_OR;   // ORI
                        3'b111: id_alu_op = `ALU_AND;  // ANDI
                        3'b001: id_alu_op = `ALU_SLL;  // SLLI
                        3'b101: id_alu_op = (funct7[5] ? `ALU_SRA : `ALU_SRL); // SRLI/SRAI
                        default: id_alu_op = `ALU_ADD;
                    endcase
                end
                
                `OPCODE_OP: begin
                    id_alu_src = 1'b0;
                    id_reg_write = 1'b1;
                    id_wb_sel = 2'b00;
                    
                    case (funct3)
                        3'b000: id_alu_op = (funct7[5] ? `ALU_SUB : `ALU_ADD); // ADD/SUB
                        3'b001: id_alu_op = `ALU_SLL;  // SLL
                        3'b010: id_alu_op = `ALU_SLT;  // SLT
                        3'b011: id_alu_op = `ALU_SLTU; // SLTU
                        3'b100: id_alu_op = `ALU_XOR;  // XOR
                        3'b101: id_alu_op = (funct7[5] ? `ALU_SRA : `ALU_SRL); // SRL/SRA
                        3'b110: id_alu_op = `ALU_OR;   // OR
                        3'b111: id_alu_op = `ALU_AND;  // AND
                        default: id_alu_op = `ALU_ADD;
                    endcase
                end
                
                `OPCODE_LOAD: begin
                    id_alu_src = 1'b1;
                    id_mem_read = 1'b1;
                    id_reg_write = 1'b1;
                    id_wb_sel = 2'b01;  // Memory data
                    id_mem_type = funct3;
                    id_alu_op = `ALU_ADD;
                end
                
                `OPCODE_STORE: begin
                    id_alu_src = 1'b1;
                    id_mem_write = 1'b1;
                    id_mem_type = funct3;
                    id_alu_op = `ALU_ADD;
                end
                
                `OPCODE_BRANCH: begin
                    id_alu_src = 1'b0;
                    id_branch_type = funct3;
                    id_alu_op = `ALU_SUB;  // For comparison
                end
                
                `OPCODE_JAL: begin
                    id_reg_write = 1'b1;
                    id_wb_sel = 2'b10;  // PC + 4
                    id_is_jal = 1'b1;
                end
                
                `OPCODE_JALR: begin
                    id_alu_src = 1'b1;
                    id_reg_write = 1'b1;
                    id_wb_sel = 2'b10;
                    id_is_jalr = 1'b1;
                    id_alu_op = `ALU_ADD;
                end
                
                `OPCODE_LUI: begin
                    id_alu_src = 1'b1;
                    id_reg_write = 1'b1;
                    id_wb_sel = 2'b11;  // Immediate
                    id_alu_op = `ALU_ADD;  // Actually just pass immediate
                end
                
                `OPCODE_AUIPC: begin
                    id_alu_src = 1'b1;
                    id_reg_write = 1'b1;
                    id_wb_sel = 2'b00;  // ALU result (PC + imm)
                    id_alu_op = `ALU_ADD;
                end
                
                default: begin
                    // Default: do nothing
                end
            endcase
        end
    end
    
    // Register file connections
    assign rs1_addr = rs1;
    assign rs2_addr = rs2;
    
    // Pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            id_rs1_data <= 32'b0;
            id_rs2_data <= 32'b0;
            id_pc_out <= 32'b0;
        end else if (!stall) begin
            if (flush) begin
                id_rs1_data <= 32'b0;
                id_rs2_data <= 32'b0;
                id_pc_out <= 32'b0;
            end else begin
                id_rs1_data <= rs1_data;
                id_rs2_data <= rs2_data;
                id_pc_out <= id_pc;
            end
        end
    end

endmodule