`timescale 1ns/1ps

module tb_power_low;

    reg clk;
    reg reset;
    reg enable;
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] op;

    wire [31:0] result;
    wire [15:0] counter;

    low_power_top dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .counter(counter)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset  = 1'b1;
        enable = 1'b0;
        A      = 32'h00000001;
        B      = 32'h00000005;
        op     = 2'b00;

        #20;
        reset = 1'b0;

        repeat (100) begin
            @(negedge clk);
            enable = 1'b1;
            A = A + 32'd1;
            B = B + 32'd2;
            op = op + 2'b01;
        end

        repeat (300) begin
            @(negedge clk);
            enable = 1'b0;
        end

        repeat (100) begin
            @(negedge clk);
            enable = 1'b1;
            A = A + 32'd3;
            B = B + 32'd1;
            op = op + 2'b01;
        end

        repeat (300) begin
            @(negedge clk);
            enable = 1'b0;
        end

        repeat (200) begin
            @(negedge clk);
            enable = 1'b1;
            A = A + 32'd2;
            B = B + 32'd4;
            op = op + 2'b01;
        end

        #25;
        $finish;
    end

endmodule
