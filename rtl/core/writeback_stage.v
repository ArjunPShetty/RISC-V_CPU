# WB stage
module writeback_stage (
    input  wire         clk,
    input  wire         rst_n,
    
    // Pipeline input
    input  wire [31:0]  wb_data,
    input  wire [4:0]   wb_rd,
    input  wire         wb_reg_write,
    
    // Register file interface
    output wire [4:0]   wb_rd_addr,
    output wire [31:0]  wb_rd_data,
    output wire         wb_rd_we
);

    // Direct connections
    assign wb_rd_addr = wb_rd;
    assign wb_rd_data = wb_data;
    assign wb_rd_we = wb_reg_write;

endmodule