# Forwarding logic
module forward_unit (
    // ID/EX register addresses
    input  wire [4:0]   id_ex_rs1,
    input  wire [4:0]   id_ex_rs2,
    
    // EX/MEM register write info
    input  wire [4:0]   ex_mem_rd,
    input  wire         ex_mem_reg_write,
    
    // MEM/WB register write info
    input  wire [4:0]   mem_wb_rd,
    input  wire         mem_wb_reg_write,
    
    // Forwarding control signals
    output reg  [1:0]   forward_rs1_sel,
    output reg  [1:0]   forward_rs2_sel
);

    always @(*) begin
        // Default: no forwarding
        forward_rs1_sel = 2'b00;
        forward_rs2_sel = 2'b00;
        
        // EX hazard: forward from EX/MEM
        if (ex_mem_reg_write && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs1)) begin
            forward_rs1_sel = 2'b01;
        end
        if (ex_mem_reg_write && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs2)) begin
            forward_rs2_sel = 2'b01;
        end
        
        // MEM hazard: forward from MEM/WB
        if (mem_wb_reg_write && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rs1)) begin
            // Only forward if not already forwarded from EX
            if (!(ex_mem_reg_write && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs1))) begin
                forward_rs1_sel = 2'b10;
            end
        end
        if (mem_wb_reg_write && (mem_wb_rd != 5'b0) && (mem_wb_rd == id_ex_rs2)) begin
            // Only forward if not already forwarded from EX
            if (!(ex_mem_reg_write && (ex_mem_rd != 5'b0) && (ex_mem_rd == id_ex_rs2))) begin
                forward_rs2_sel = 2'b10;
            end
        end
    end

endmodule