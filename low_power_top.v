module low_power_top (
    input         clk,
    input         reset,
    input         enable,
    input  [31:0] A,
    input  [31:0] B,
    input  [1:0]  op,

    output [31:0] result,
    output [15:0] counter
);

    // FPGA-friendly low-power implementation (Version 1).
    // Uses clock-enable based activity suppression.
    // The global clock remains on the dedicated clock network.
    // The target sequential logic updates only when enable is active.
    // This suppresses unnecessary switching without creating a fabric-generated clock.

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