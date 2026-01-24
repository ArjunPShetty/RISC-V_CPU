# Data memory interface
module data_mem_if (
    input  wire         clk,
    input  wire         rst_n,
    
    // CPU interface
    input  wire [31:0]  addr,
    input  wire [31:0]  write_data,
    input  wire         read_en,
    input  wire         write_en,
    input  wire [3:0]   write_strb,
    output reg  [31:0]  read_data,
    
    // Memory interface
    output wire [31:0]  mem_addr,
    output wire [31:0]  mem_write_data,
    output wire         mem_write_en,
    output wire [3:0]   mem_write_strb,
    input  wire [31:0]  mem_read_data
);

    // Simple data memory interface
    // For now, just pass through
    
    assign mem_addr = addr;
    assign mem_write_data = write_data;
    assign mem_write_en = write_en;
    assign mem_write_strb = write_strb;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 32'b0;
        end else if (read_en) begin
            read_data <= mem_read_data;
        end
    end

endmodule