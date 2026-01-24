# Immediate generator
module imm_gen (
    input  wire [31:0]  instr,
    input  wire [2:0]   imm_type,  // From decoder based on opcode
    output reg  [31:0]  imm_out
);

    always @(*) begin
        case (imm_type)
            3'b000: // I-type
                imm_out = {{20{instr[31]}}, instr[31:20]};
            3'b001: // S-type
                imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            3'b010: // B-type
                imm_out = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            3'b011: // U-type
                imm_out = {instr[31:12], 12'b0};
            3'b100: // J-type
                imm_out = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            default:
                imm_out = 32'b0;
        endcase
    end

endmodule