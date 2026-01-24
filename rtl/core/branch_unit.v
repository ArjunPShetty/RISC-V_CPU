# Branch handling
module branch_unit (
    // Branch info from EX stage
    input  wire         ex_branch_taken,
    input  wire [31:0]  ex_branch_target,
    input  wire         ex_is_jal,
    input  wire         ex_is_jalr,
    
    // Current PC
    input  wire [31:0]  if_pc,
    
    // Control outputs
    output reg          branch_taken,
    output reg  [31:0]  branch_target,
    output reg          pc_src
);

    always @(*) begin
        branch_taken = ex_branch_taken;
        branch_target = ex_branch_target;
        
        // Determine PC source
        if (ex_branch_taken) begin
            pc_src = 1'b1;  // Use branch target
        end else begin
            pc_src = 1'b0;  // Use PC + 4
        end
    end

endmodule