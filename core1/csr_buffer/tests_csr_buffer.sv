# VerifAI TestGuru
# tests for: csr_buffer.sv
```
`include "ariane_pkg.sv"

module csr_buffer_tb;

    logic clk, rst;
    logic flush;

    fu_data_t fu_data;

    logic csr_ready;
    logic csr_valid;
    riscv::xlen_t csr_result;
    logic csr_commit;
    logic [11:0] csr_addr;

    csr_buffer #(
        .CSR_ADDR_WIDTH(12)
    ) csr_buffer_i (
        .clk_i(clk),
        .rst_ni(rst),
        .flush_i(flush),

        .fu_data_i(fu_data),

        .csr_ready_o(csr_ready),
        .csr_valid_i(csr_valid),
        .csr_result_o(csr_result),
        .csr_commit_i(csr_commit),
        .csr_addr_o(csr_addr)
    );

    initial begin
        clk = 0;
        rst = 1;
        flush = 0;

        fu_data = '{default: 0};

        csr_ready = 1'b1;
        csr_valid = 1'b0;
        csr_result = 0;
        csr_commit = 1'b0;
        csr_addr = 0;

        #10;
        rst = 0;

        #100;
        fu_data = '{operand_a: 10, operand_b: 20, csr_op: 'CSRRW, csr_addr: 10};
        csr_valid = 1'b1;
        #10;
        csr_valid = 1'b0;
        #10;
        csr_commit = 1'b1;
        #10;
        csr_commit = 1'b0;
        #10;
        flush = 1'b1;
        #10;
        flush = 1'b0;

        #1000;
        $finish;
    end

    always #5 clk = ~clk;

endmodule
```