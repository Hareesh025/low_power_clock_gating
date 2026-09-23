`timescale 1ns/1ps

module tb_compare;

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

    // =========================================================
    // Baseline Design
    // =========================================================
    baseline_top baseline_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .A(A),
        .B(B),
        .op(op),
        .result(baseline_result),
        .counter(baseline_counter)
    );

    // =========================================================
    // Low-Power Design
    // =========================================================
    low_power_top low_power_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .A(A),
        .B(B),
        .op(op),
        .result(low_power_result),
        .counter(low_power_counter)
    );

    // =========================================================
    // 100 MHz Clock
    // 10 ns period
    // =========================================================
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // =========================================================
    // Main Test
    // =========================================================
    initial begin

        reset       = 1'b1;
        enable      = 1'b1;
        A           = 32'd10;
        B           = 32'd5;
        op          = 2'b00;

        cycle_count = 0;
        error_count = 0;

        // Keep reset active for two clock cycles
        repeat (2) @(posedge clk);

        // Change reset away from the clock edge
        @(negedge clk);
        reset = 1'b0;

        // =====================================================
        // 1000 test cycles
        // 30% ACTIVE / 70% IDLE
        //
        // 0-99     ACTIVE
        // 100-399  IDLE
        // 400-499  ACTIVE
        // 500-799  IDLE
        // 800-999  ACTIVE
        // =====================================================

        for (cycle_count = 0; cycle_count < 1000; cycle_count = cycle_count + 1) begin

            // ---------------------------------------------
            // Enable pattern
            // ---------------------------------------------
            if ((cycle_count >= 0 && cycle_count < 100) ||
                (cycle_count >= 400 && cycle_count < 500) ||
                (cycle_count >= 800 && cycle_count < 1000))
                enable = 1'b1;
            else
                enable = 1'b0;

            // ---------------------------------------------
            // ALU workload
            // ---------------------------------------------
            if (cycle_count < 250) begin
                A  = 32'd10;
                B  = 32'd5;
                op = 2'b00;       // ADD
            end
            else if (cycle_count < 500) begin
                A  = 32'd100;
                B  = 32'd25;
                op = 2'b01;       // SUB
            end
            else if (cycle_count < 750) begin
                A  = 32'hAAAA5555;
                B  = 32'h12345678;
                op = 2'b10;       // XOR
            end
            else begin
                A  = 32'hFFFF0000;
                B  = 32'h00FF00FF;
                op = 2'b11;       // AND
            end

            // Wait for the next active clock edge
            @(posedge clk);
        end

        // Allow final outputs to settle
        #10;

        // =====================================================
        // Final Result
        // =====================================================

        $display("");
        $display("=================================================");
        $display("        LOW POWER CLOCK GATING TEST");
        $display("=================================================");
        $display("Simulation completed.");
        $display("Total test cycles = %0d", cycle_count);
        $display("Error count       = %0d", error_count);

        if (error_count == 0)
            $display("PASS: Baseline and Low-Power outputs match.");
        else
            $display("FAIL: Functional mismatch detected.");

        $display("=================================================");

        $finish;
    end

    // =========================================================
    // Functional Equivalence Check
    // =========================================================
    always @(posedge clk) begin
        #1;

        if (!reset) begin

            if (baseline_result !== low_power_result) begin
                $display(
                    "ERROR at %0t ns: RESULT mismatch | Baseline=%h LowPower=%h",
                    $time,
                    baseline_result,
                    low_power_result
                );

                error_count = error_count + 1;
            end

            if (baseline_counter !== low_power_counter) begin
                $display(
                    "ERROR at %0t ns: COUNTER mismatch | Baseline=%d LowPower=%d",
                    $time,
                    baseline_counter,
                    low_power_counter
                );

                error_count = error_count + 1;
            end

        end
    end

endmodule