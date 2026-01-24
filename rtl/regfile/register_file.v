module register_file (
    input  wire                     clk,
    input  wire                     rst_n,
    
    // Read port 1
    input  wire [4:0]               rs1_addr,
    output reg  [31:0]              rs1_data,
    
    // Read port 2
    input  wire [4:0]               rs2_addr,
    output reg  [31:0]              rs2_data,
    
    // Write port
    input  wire [4:0]               rd_addr,
    input  wire [31:0]              rd_data,
    input  wire                     rd_we
);

    // Register file memory
    reg [31:0] regfile [0:31];
    integer i;

    // Initialize register file
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regfile[i] = 32'b0;
        end
        regfile[2] = 32'h7FFFFFF0;  // Initialize stack pointer
    end

    // Read ports (asynchronous read)
    always @(*) begin
        if (!rst_n) begin
            rs1_data = 32'b0;
            rs2_data = 32'b0;
        end else begin
            rs1_data = (rs1_addr == 5'b0) ? 32'b0 : regfile[rs1_addr];
            rs2_data = (rs2_addr == 5'b0) ? 32'b0 : regfile[rs2_addr];
        end
    end

    // Write port (synchronous write)
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1) begin
                regfile[i] <= 32'b0;
            end
            regfile[2] <= 32'h7FFFFFF0;  // Reset stack pointer
        end else if (rd_we && (rd_addr != 5'b0)) begin
            regfile[rd_addr] <= rd_data;
        end
    end

endmodule