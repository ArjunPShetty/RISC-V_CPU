# Hazard detection
module hazard_ctrl (
    // Instruction decode info
    input  wire [4:0]   if_id_rs1,
    input  wire [4:0]   if_id_rs2,
    input  wire         id_mem_read,
    
    // Pipeline register info
    input  wire [4:0]   id_ex_rd,
    input  wire         id_ex_mem_read,
    
    // Control signals
    output reg          pc_stall,
    output reg          if_id_stall,
    output reg          if_id_flush,
    output reg          id_ex_flush
);

    // Load-use hazard detection
    always @(*) begin
        // Default values
        pc_stall = 1'b0;
        if_id_stall = 1'b0;
        if_id_flush = 1'b0;
        id_ex_flush = 1'b0;
        
        // Load-use hazard: stall pipeline for one cycle
        if (id_ex_mem_read && ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2))) begin
            pc_stall = 1'b1;
            if_id_stall = 1'b1;
            id_ex_flush = 1'b1;
        end
        
        // Branch/jump hazard: flush IF/ID and ID/EX
        // This would be triggered by branch unit
    end

endmodule