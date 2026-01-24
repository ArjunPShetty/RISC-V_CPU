# IF stage
module fetch_stage (
    input  wire         clk,
    input  wire         rst_n,
    
    // PC control signals
    input  wire [31:0]  pc_next,
    input  wire         pc_src,      // 0: PC+4, 1: Branch/Jump target
    
    // Interface with instruction memory
    output wire [31:0]  pc_addr,
    input  wire [31:0]  instr_data,
    
    // Pipeline register output
    output reg  [31:0]  if_pc,
    output reg  [31:0]  if_instr,
    output reg          if_valid
);

    reg [31:0] pc_reg;

    // Program Counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc_reg <= `PC_RESET;
            if_pc <= 32'b0;
            if_instr <= 32'b0;
            if_valid <= 1'b0;
        end else begin
            if (pc_src) begin
                pc_reg <= pc_next;
                if_pc <= pc_next;
                if_instr <= instr_data;
                if_valid <= 1'b1;
            end else begin
                pc_reg <= pc_reg + 4;
                if_pc <= pc_reg;
                if_instr <= instr_data;
                if_valid <= 1'b1;
            end
        end
    end

    assign pc_addr = pc_reg;

endmodule