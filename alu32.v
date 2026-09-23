module alu32 (
    input  [31:0] A,
    input  [31:0] B,
    input  [1:0]  op,
    output reg [31:0] Y
);

    always @(*) begin
        case (op)
            2'b00: Y = A + B;   // ADD
            2'b01: Y = A - B;   // SUB
            2'b10: Y = A ^ B;   // XOR
            2'b11: Y = A & B;   // AND
            default: Y = 32'b0;
        endcase
    end

endmodule