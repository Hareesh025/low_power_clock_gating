module processing_unit (
    input         clk,
    input         reset,
    input         enable,
    input  [31:0] A,
    input  [31:0] B,
    input  [1:0]  op,

    output [31:0] result,
    output [15:0] counter
);

    wire [31:0] alu_result;

    reg [31:0] accumulator;
    reg [15:0] counter_reg;

    reg        reg_write_en;
    reg [2:0]  reg_write_addr;
    reg [31:0] reg_write_data;

    wire [31:0] reg_read_data;

    // 32-bit ALU
    alu32 alu_inst (
        .A(A),
        .B(B),
        .op(op),
        .Y(alu_result)
    );

    // 8 x 32-bit register bank
    reg_bank reg_bank_inst (
        .clk(clk),
        .reset(reset),
        .write_en(reg_write_en),
        .write_addr(reg_write_addr),
        .write_data(reg_write_data),
        .read_addr(3'b000),
        .read_data(reg_read_data)
    );

    // Functional enable.
    // Both baseline and low-power designs use the same
    // functional behavior. The low-power top additionally
    // controls the clock using BUFGCE.
    always @(posedge clk) begin
        if (reset) begin
            accumulator    <= 32'b0;
            counter_reg    <= 16'b0;
            reg_write_en   <= 1'b0;
            reg_write_addr <= 3'b000;
            reg_write_data <= 32'b0;
        end
        else if (enable) begin
            accumulator    <= alu_result;
            counter_reg    <= counter_reg + 16'd1;

            reg_write_en   <= 1'b1;
            reg_write_addr <= 3'b000;
            reg_write_data <= alu_result;
        end
        else begin
            accumulator    <= accumulator;
            counter_reg    <= counter_reg;
            reg_write_en   <= 1'b0;
        end
    end

    assign result  = accumulator;
    assign counter = counter_reg;

endmodule