module alu (
    input  wire [31:0]  operand_a,
    input  wire [31:0]  operand_b,
    input  wire [3:0]   alu_op,
    output reg  [31:0]  result,
    output wire         zero_flag
);

    wire signed [31:0] signed_a = operand_a;
    wire signed [31:0] signed_b = operand_b;

    always @(*) begin
        case (alu_op)
            `ALU_ADD:  result = operand_a + operand_b;
            `ALU_SUB:  result = operand_a - operand_b;
            `ALU_SLL:  result = operand_a << operand_b[4:0];
            `ALU_SLT:  result = (signed_a < signed_b) ? 32'b1 : 32'b0;
            `ALU_SLTU: result = (operand_a < operand_b) ? 32'b1 : 32'b0;
            `ALU_XOR:  result = operand_a ^ operand_b;
            `ALU_SRL:  result = operand_a >> operand_b[4:0];
            `ALU_SRA:  result = signed_a >>> operand_b[4:0];
            `ALU_OR:   result = operand_a | operand_b;
            `ALU_AND:  result = operand_a & operand_b;
            default:   result = 32'b0;
        endcase
    end

    assign zero_flag = (result == 32'b0);

endmodule