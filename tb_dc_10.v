`timescale 1ns/1ps

module tb_dc_10;

    reg clk;
    reg reset;
    reg enable;

    reg [31:0] A;
    reg [31:0] B;
    reg [1:0]  op;

    wire [31:0] baseline_result;
    wire [15:0] baseline_counter;

    wire [31:0] low_power_result;
    wire [15:0] low_power_counter;

    integer cycle_count;
    integer error_count;

    baseline_top baseline_inst (
        .clk(clk), .reset(reset), .enable(enable),
        .A(A), .B(B), .op(op),
        .result(baseline_result), .counter(baseline_counter)
    );

    low_power_top low_power_inst (
        .clk(clk), .reset(reset), .enable(enable),
        .A(A), .B(B), .op(op),
        .result(low_power_result), .counter(low_power_counter)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1'b1; enable = 1'b1; A = 32'd10; B = 32'd5; op = 2'b00;
        cycle_count = 0; error_count = 0;
        repeat (2) @(posedge clk);
        @(negedge clk); reset = 1'b0;

        for (cycle_count = 0; cycle_count < 1000; cycle_count = cycle_count + 1) begin
            enable = (cycle_count < 100) ? 1'b1 : 1'b0;

            if (cycle_count < 250) begin A=32'd10; B=32'd5; op=2'b00; end
            else if (cycle_count < 500) begin A=32'd100; B=32'd25; op=2'b01; end
            else if (cycle_count < 750) begin A=32'hAAAA5555; B=32'h12345678; op=2'b10; end
            else begin A=32'hFFFF0000; B=32'h00FF00FF; op=2'b11; end

            @(posedge clk);
        end
        #10;
        $display("DC 10%%: Errors=%0d", error_count);
        $finish;
    end

    always @(posedge clk) begin
        #1;
        if (!reset) begin
            if (baseline_result !== low_power_result) error_count = error_count + 1;
            if (baseline_counter !== low_power_counter) error_count = error_count + 1;
        end
    end

endmodule