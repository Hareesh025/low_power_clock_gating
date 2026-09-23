module reg_bank (
    input        clk,
    input        reset,
    input        write_en,
    input  [2:0] write_addr,
    input  [31:0] write_data,
    input  [2:0] read_addr,
    output [31:0] read_data
);

    reg [31:0] registers [0:7];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (write_en) begin
            registers[write_addr] <= write_data;
        end
    end

    assign read_data = registers[read_addr];

endmodule