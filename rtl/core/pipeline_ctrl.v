# Pipeline control
module pipeline_ctrl (
    input  wire         clk,
    input  wire         rst_n,
    
    // Hazard detection inputs
    input  wire         hazard_stall,
    input  wire         hazard_flush,
    
    // Branch prediction inputs
    input  wire         branch_taken,
    
    // Control outputs
    output reg          if_stall,
    output reg          id_stall,
    output reg          ex_stall,
    output reg          mem_stall,
    output reg          wb_stall,
    
    output reg          if_flush,
    output reg          id_flush,
    output reg          ex_flush,
    output reg          mem_flush,
    output reg          wb_flush
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            if_stall <= 1'b0;
            id_stall <= 1'b0;
            ex_stall <= 1'b0;
            mem_stall <= 1'b0;
            wb_stall <= 1'b0;
            
            if_flush <= 1'b0;
            id_flush <= 1'b0;
            ex_flush <= 1'b0;
            mem_flush <= 1'b0;
            wb_flush <= 1'b0;
        end else begin
            // Handle stalls
            if (hazard_stall) begin
                if_stall <= 1'b1;
                id_stush <= 1'b1;
                ex_flush <= 1'b1;
            end else begin
                if_stall <= 1'b0;
                id_stall <= 1'b0;
            end
            
            // Handle flushes (for branches/jumps)
            if (branch_taken) begin
                if_flush <= 1'b1;
                id_flush <= 1'b1;
                ex_flush <= 1'b1;
            end else begin
                if_flush <= 1'b0;
                id_flush <= 1'b0;
                ex_flush <= 1'b0;
            end
        end
    end

endmodule