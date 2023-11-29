// VerifAI TestGuru
// tests for: instr_realign.sv

import riscv;

module testbench;

    logic clk_i;
    logic rst_ni;
    logic flush_i;
    logic valid_i;
    logic serving_unaligned_o;
    logic [riscv::VLEN-1:0] address_i;
    logic [FETCH_WIDTH-1:0] data_i;
    logic [INSTR_PER_FETCH-1:0] valid_o;
    logic [INSTR_PER_FETCH-1:0][riscv::VLEN-1:0] addr_o;
    logic [INSTR_PER_FETCH-1:0][31:0] instr_o;

    instr_realign #(
        .FETCH_WIDTH(FETCH_WIDTH),
        .INSTR_PER_FETCH(INSTR_PER_FETCH)
    ) dut(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .flush_i(flush_i),
        .valid_i(valid_i),
        .serving_unaligned_o(serving_unaligned_o),
        .address_i(address_i),
        .data_i(data_i),
        .valid_o(valid_o),
        .addr_o(addr_o),
        .instr_o(instr_o)
    );

    initial begin
        clk_i = 1'b0;
        forever #10 clk_i = ~clk_i;
    end

    initial begin
        rst_ni = 1'b1;
        #10 rst_ni = 1'b0;

        address_i = 32'h00000000;
        data_i = 32'h00000000;
        valid_i = 1'b1;

        #100
        $finish;
    end
endmodule
