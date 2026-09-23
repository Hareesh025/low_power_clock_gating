module baseline_top (
    input         clk,
    input         reset,
    input         enable,
    input  [31:0] A,
    input  [31:0] B,
    input  [1:0]  op,

    output [31:0] result,
    output [15:0] counter
);

    processing_unit processing_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .counter(counter)
    );

endmodule