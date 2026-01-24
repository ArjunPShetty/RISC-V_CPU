# Top-level CPU module
module riscv_core (
    input  wire         clk,
    input  wire         rst_n,
    
    // Instruction memory interface
    output wire [31:0]  imem_addr,
    input  wire [31:0]  imem_data,
    
    // Data memory interface
    output wire [31:0]  dmem_addr,
    output wire         dmem_write_en,
    output wire [3:0]   dmem_write_strb,
    output wire [31:0]  dmem_write_data,
    input  wire [31:0]  dmem_read_data
);

    // Pipeline registers
    wire [31:0] if_pc, if_instr;
    wire [31:0] id_pc, id_instr;
    wire [31:0] ex_pc, ex_alu_result;
    wire [31:0] mem_alu_result, mem_wb_data;
    
    // Control signals
    wire [3:0] id_alu_op, ex_alu_op;
    wire id_alu_src, ex_alu_src;
    wire id_mem_read, ex_mem_read, mem_mem_read;
    wire id_mem_write, ex_mem_write, mem_mem_write;
    wire [2:0] id_mem_type, ex_mem_type, mem_mem_type;
    wire id_reg_write, ex_reg_write, mem_reg_write, wb_reg_write;
    wire [1:0] id_wb_sel, ex_wb_sel, mem_wb_sel;
    wire [2:0] id_branch_type, ex_branch_type;
    wire id_is_jal, ex_is_jal;
    wire id_is_jalr, ex_is_jalr;
    
    // Hazard and forwarding
    wire hazard_stall, hazard_flush;
    wire [1:0] forward_rs1_sel, forward_rs2_sel;
    wire [31:0] forward_rs1_data, forward_rs2_data;
    
    // Branch control
    wire branch_taken;
    wire [31:0] branch_target;
    wire pc_src;
    
    // Register file
    wire [31:0] rs1_data, rs2_data;
    wire [4:0] rs1_addr, rs2_addr;
    wire [4:0] wb_rd_addr;
    wire [31:0] wb_rd_data;
    wire wb_rd_we;
    
    // Instruction fetch stage
    fetch_stage u_fetch (
        .clk(clk),
        .rst_n(rst_n),
        .pc_next(branch_target),
        .pc_src(pc_src),
        .pc_addr(imem_addr),
        .instr_data(imem_data),
        .if_pc(if_pc),
        .if_instr(if_instr),
        .if_valid()
    );
    
    // IF/ID pipeline register
    reg [31:0] if_id_pc;
    reg [31:0] if_id_instr;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            if_id_pc <= 32'b0;
            if_id_instr <= 32'b0;
        end else if (!hazard_stall) begin
            if (hazard_flush) begin
                if_id_pc <= 32'b0;
                if_id_instr <= 32'b0;
            end else begin
                if_id_pc <= if_pc;
                if_id_instr <= if_instr;
            end
        end
    end
    
    // Decode stage
    decode_stage u_decode (
        .clk(clk),
        .rst_n(rst_n),
        .id_pc(if_id_pc),
        .id_instr(if_id_instr),
        .id_valid(1'b1),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .id_alu_op(id_alu_op),
        .id_alu_src(id_alu_src),
        .id_mem_read(id_mem_read),
        .id_mem_write(id_mem_write),
        .id_mem_type(id_mem_type),
        .id_reg_write(id_reg_write),
        .id_wb_sel(id_wb_sel),
        .id_branch_type(id_branch_type),
        .id_is_jal(id_is_jal),
        .id_is_jalr(id_is_jalr),
        .id_rs1_data(),
        .id_rs2_data(),
        .id_imm(),
        .id_rd(),
        .id_rs1(),
        .id_rs2(),
        .id_pc_out(id_pc),
        .stall(hazard_stall),
        .flush(hazard_flush)
    );
    
    // Register file
    register_file u_regfile (
        .clk(clk),
        .rst_n(rst_n),
        .rs1_addr(rs1_addr),
        .rs1_data(rs1_data),
        .rs2_addr(rs2_addr),
        .rs2_data(rs2_data),
        .rd_addr(wb_rd_addr),
        .rd_data(wb_rd_data),
        .rd_we(wb_rd_we)
    );
    
    // ID/EX pipeline register
    reg [31:0] id_ex_rs1_data, id_ex_rs2_data;
    reg [31:0] id_ex_imm, id_ex_pc;
    reg [4:0] id_ex_rd, id_ex_rs1, id_ex_rs2;
    reg id_ex_reg_write, id_ex_mem_read, id_ex_mem_write;
    reg [2:0] id_ex_mem_type;
    reg [1:0] id_ex_wb_sel;
    reg [3:0] id_ex_alu_op;
    reg id_ex_alu_src;
    reg [2:0] id_ex_branch_type;
    reg id_ex_is_jal, id_ex_is_jalr;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            id_ex_rs1_data <= 32'b0;
            id_ex_rs2_data <= 32'b0;
            id_ex_imm <= 32'b0;
            id_ex_pc <= 32'b0;
            id_ex_rd <= 5'b0;
            id_ex_rs1 <= 5'b0;
            id_ex_rs2 <= 5'b0;
            id_ex_reg_write <= 1'b0;
            id_ex_mem_read <= 1'b0;
            id_ex_mem_write <= 1'b0;
            id_ex_mem_type <= 3'b0;
            id_ex_wb_sel <= 2'b0;
            id_ex_alu_op <= 4'b0;
            id_ex_alu_src <= 1'b0;
            id_ex_branch_type <= 3'b0;
            id_ex_is_jal <= 1'b0;
            id_ex_is_jalr <= 1'b0;
        end else if (!hazard_stall) begin
            if (hazard_flush) begin
                id_ex_rs1_data <= 32'b0;
                id_ex_rs2_data <= 32'b0;
                id_ex_imm <= 32'b0;
                id_ex_pc <= 32'b0;
                id_ex_rd <= 5'b0;
                id_ex_rs1 <= 5'b0;
                id_ex_rs2 <= 5'b0;
                id_ex_reg_write <= 1'b0;
                id_ex_mem_read <= 1'b0;
                id_ex_mem_write <= 1'b0;
                id_ex_mem_type <= 3'b0;
                id_ex_wb_sel <= 2'b0;
                id_ex_alu_op <= 4'b0;
                id_ex_alu_src <= 1'b0;
                id_ex_branch_type <= 3'b0;
                id_ex_is_jal <= 1'b0;
                id_ex_is_jalr <= 1'b0;
            end else begin
                id_ex_rs1_data <= rs1_data;
                id_ex_rs2_data <= rs2_data;
                // These would come from decode stage outputs
                id_ex_pc <= id_pc;
                id_ex_rd <= 5'b0;  // Would come from decode
                id_ex_rs1 <= 5'b0; // Would come from decode
                id_ex_rs2 <= 5'b0; // Would come from decode
                id_ex_reg_write <= id_reg_write;
                id_ex_mem_read <= id_mem_read;
                id_ex_mem_write <= id_mem_write;
                id_ex_mem_type <= id_mem_type;
                id_ex_wb_sel <= id_wb_sel;
                id_ex_alu_op <= id_alu_op;
                id_ex_alu_src <= id_alu_src;
                id_ex_branch_type <= id_branch_type;
                id_ex_is_jal <= id_is_jal;
                id_ex_is_jalr <= id_is_jalr;
            end
        end
    end
    
    // Execute stage
    execute_stage u_execute (
        .clk(clk),
        .rst_n(rst_n),
        .ex_alu_op(id_ex_alu_op),
        .ex_alu_src(id_ex_alu_src),
        .ex_rs1_data(id_ex_rs1_data),
        .ex_rs2_data(id_ex_rs2_data),
        .ex_imm(id_ex_imm),
        .ex_pc(id_ex_pc),
        .forward_rs1_data(forward_rs1_data),
        .forward_rs2_data(forward_rs2_data),
        .forward_rs1_sel(forward_rs1_sel),
        .forward_rs2_sel(forward_rs2_sel),
        .ex_branch_type(id_ex_branch_type),
        .ex_is_jal(id_ex_is_jal),
        .ex_is_jalr(id_ex_is_jalr),
        .ex_alu_result(ex_alu_result),
        .ex_branch_target(branch_target),
        .ex_branch_taken(branch_taken),
        .ex_store_data(),
        .ex_rd(),
        .ex_reg_write(),
        .ex_wb_sel(),
        .ex_mem_read(),
        .ex_mem_write(),
        .ex_mem_type()
    );
    
    // EX/MEM pipeline register
    reg [31:0] ex_mem_alu_result, ex_mem_store_data;
    reg [4:0] ex_mem_rd;
    reg ex_mem_reg_write, ex_mem_mem_read, ex_mem_mem_write;
    reg [2:0] ex_mem_mem_type;
    reg [1:0] ex_mem_wb_sel;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ex_mem_alu_result <= 32'b0;
            ex_mem_store_data <= 32'b0;
            ex_mem_rd <= 5'b0;
            ex_mem_reg_write <= 1'b0;
            ex_mem_mem_read <= 1'b0;
            ex_mem_mem_write <= 1'b0;
            ex_mem_mem_type <= 3'b0;
            ex_mem_wb_sel <= 2'b0;
        end else begin
            ex_mem_alu_result <= ex_alu_result;
            // Store data and other signals would come from execute stage
            ex_mem_rd <= id_ex_rd;
            ex_mem_reg_write <= id_ex_reg_write;
            ex_mem_mem_read <= id_ex_mem_read;
            ex_mem_mem_write <= id_ex_mem_write;
            ex_mem_mem_type <= id_ex_mem_type;
            ex_mem_wb_sel <= id_ex_wb_sel;
        end
    end
    
    // Memory stage
    memory_stage u_memory (
        .clk(clk),
        .rst_n(rst_n),
        .mem_alu_result(ex_mem_alu_result),
        .mem_store_data(ex_mem_store_data),
        .mem_mem_read(ex_mem_mem_read),
        .mem_mem_write(ex_mem_mem_write),
        .mem_mem_type(ex_mem_mem_type),
        .mem_rd(ex_mem_rd),
        .mem_reg_write(ex_mem_reg_write),
        .mem_wb_sel(ex_mem_wb_sel),
        .mem_addr(dmem_addr),
        .mem_write_data(dmem_write_data),
        .mem_write_en(dmem_write_en),
        .mem_write_strb(dmem_write_strb),
        .mem_read_data(dmem_read_data),
        .mem_wb_data(mem_wb_data),
        .mem_wb_rd(),
        .mem_wb_reg_write(mem_reg_write)
    );
    
    // MEM/WB pipeline register
    reg [31:0] mem_wb_wb_data;
    reg [4:0] mem_wb_rd;
    reg mem_wb_reg_write;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem_wb_wb_data <= 32'b0;
            mem_wb_rd <= 5'b0;
            mem_wb_reg_write <= 1'b0;
        end else begin
            mem_wb_wb_data <= mem_wb_data;
            mem_wb_rd <= ex_mem_rd;
            mem_wb_reg_write <= mem_reg_write;
        end
    end
    
    // Writeback stage
    writeback_stage u_writeback (
        .clk(clk),
        .rst_n(rst_n),
        .wb_data(mem_wb_wb_data),
        .wb_rd(mem_wb_rd),
        .wb_reg_write(mem_wb_reg_write),
        .wb_rd_addr(wb_rd_addr),
        .wb_rd_data(wb_rd_data),
        .wb_rd_we(wb_rd_we)
    );
    
    // Forwarding unit
    forward_unit u_forward (
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),
        .ex_mem_rd(ex_mem_rd),
        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_rd(mem_wb_rd),
        .mem_wb_reg_write(mem_wb_reg_write),
        .forward_rs1_sel(forward_rs1_sel),
        .forward_rs2_sel(forward_rs2_sel)
    );
    
    // Hazard control
    hazard_ctrl u_hazard (
        .if_id_rs1(5'b0),  // Would come from decode
        .if_id_rs2(5'b0),  // Would come from decode
        .id_mem_read(id_mem_read),
        .id_ex_rd(id_ex_rd),
        .id_ex_mem_read(id_ex_mem_read),
        .pc_stall(),
        .if_id_stall(hazard_stall),
        .if_id_flush(hazard_flush),
        .id_ex_flush()
    );
    
    // Branch unit
    branch_unit u_branch (
        .ex_branch_taken(branch_taken),
        .ex_branch_target(branch_target),
        .ex_is_jal(id_ex_is_jal),
        .ex_is_jalr(id_ex_is_jalr),
        .if_pc(if_pc),
        .branch_taken(),
        .branch_target(),
        .pc_src(pc_src)
    );
    
    // Forwarding data sources
    assign forward_rs1_data = (forward_rs1_sel == 2'b01) ? ex_mem_alu_result : mem_wb_wb_data;
    assign forward_rs2_data = (forward_rs2_sel == 2'b01) ? ex_mem_alu_result : mem_wb_wb_data;

endmodule