# EX stage
module execute_stage (
    input  wire         clk,
    input  wire         rst_n,
    
    // Pipeline input
    input  wire [3:0]   ex_alu_op,
    input  wire         ex_alu_src,
    input  wire [31:0]  ex_rs1_data,
    input  wire [31:0]  ex_rs2_data,
    input  wire [31:0]  ex_imm,
    input  wire [31:0]  ex_pc,
    
    // Forwarding inputs
    input  wire [31:0]  forward_rs1_data,
    input  wire [31:0]  forward_rs2_data,
    input  wire [1:0]   forward_rs1_sel,
    input  wire [1:0]   forward_rs2_sel,
    
    // Branch control
    input  wire [2:0]   ex_branch_type,
    input  wire         ex_is_jal,
    input  wire         ex_is_jalr,
    
    // Outputs
    output reg  [31:0]  ex_alu_result,
    output wire [31:0]  ex_branch_target,
    output reg          ex_branch_taken,
    output reg  [31:0]  ex_store_data,
    output reg  [4:0]   ex_rd,
    output reg          ex_reg_write,
    output reg  [1:0]   ex_wb_sel,
    output reg          ex_mem_read,
    output reg          ex_mem_write,
    output reg  [2:0]   ex_mem_type
);

    // Internal signals
    reg [31:0] alu_operand_a;
    reg [31:0] alu_operand_b;
    wire [31:0] alu_result;
    wire alu_zero;
    
    // Instantiate ALU
    alu u_alu (
        .operand_a(alu_operand_a),
        .operand_b(alu_operand_b),
        .alu_op(ex_alu_op),
        .result(alu_result),
        .zero_flag(alu_zero)
    );
    
    // Forwarding multiplexers for ALU inputs
    always @(*) begin
        // ALU operand A selection
        case (forward_rs1_sel)
            2'b00: alu_operand_a = ex_rs1_data;
            2'b01: alu_operand_a = forward_rs1_data;  // Forward from MEM stage
            2'b10: alu_operand_a = forward_rs1_data;  // Forward from WB stage
            default: alu_operand_a = ex_rs1_data;
        endcase
        
        // ALU operand B selection
        if (ex_alu_src) begin
            alu_operand_b = ex_imm;
        end else begin
            case (forward_rs2_sel)
                2'b00: alu_operand_b = ex_rs2_data;
                2'b01: alu_operand_b = forward_rs2_data;  // Forward from MEM stage
                2'b10: alu_operand_b = forward_rs2_data;  // Forward from WB stage
                default: alu_operand_b = ex_rs2_data;
            endcase
        end
    end
    
    // Branch target calculation
    assign ex_branch_target = (ex_is_jalr) ? 
                             (alu_operand_a + ex_imm) & ~32'b1 :  // JALR: clear LSB
                             ex_pc + ex_imm;
    
    // Branch condition evaluation
    always @(*) begin
        ex_branch_taken = 1'b0;
        
        if (ex_is_jal || ex_is_jalr) begin
            ex_branch_taken = 1'b1;
        end else if (ex_branch_type != `BRANCH_NO) begin
            case (ex_branch_type)
                `BRANCH_EQ:  ex_branch_taken = alu_zero;
                `BRANCH_NE:  ex_branch_taken = ~alu_zero;
                `BRANCH_LT:  ex_branch_taken = (alu_operand_a < alu_operand_b);
                `BRANCH_GE:  ex_branch_taken = (alu_operand_a >= alu_operand_b);
                `BRANCH_LTU: ex_branch_taken = (alu_operand_a < alu_operand_b);
                `BRANCH_GEU: ex_branch_taken = (alu_operand_a >= alu_operand_b);
                default: ex_branch_taken = 1'b0;
            endcase
        end
    end
    
    // Store data forwarding
    always @(*) begin
        case (forward_rs2_sel)
            2'b00: ex_store_data = ex_rs2_data;
            2'b01: ex_store_data = forward_rs2_data;
            2'b10: ex_store_data = forward_rs2_data;
            default: ex_store_data = ex_rs2_data;
        endcase
    end
    
    // Pipeline registers (simplified - normally these would come from decode stage)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ex_alu_result <= 32'b0;
            ex_rd <= 5'b0;
            ex_reg_write <= 1'b0;
            ex_wb_sel <= 2'b0;
            ex_mem_read <= 1'b0;
            ex_mem_write <= 1'b0;
            ex_mem_type <= 3'b0;
        end else begin
            ex_alu_result <= alu_result;
            // These should come from pipeline registers in actual implementation
        end
    end

endmodule