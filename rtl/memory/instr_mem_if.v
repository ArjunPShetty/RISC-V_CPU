# Instruction memory interface
module instr_mem_if (
    input  wire         clk,
    input  wire         rst_n,
    
    // CPU interface
    input  wire [31:0]  addr,
    output reg  [31:0]  data,
    
    // Memory interface
    output wire [31:0]  mem_addr,
    input  wire [31:0]  mem_data
);

    // Simple instruction memory interface
    // For now, just pass through
    
    assign mem_addr = {addr[31:2], 2'b00};  // Word-aligned
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 32'b0;
        end else begin
            data <= mem_data;
        end
    end

endmodule