
// VerifAI TestGuru
// tests for: csr_buffer.sv

module csr_buffer_tb;

    logic clk;
    logic rst_n;
    logic flush;

    fu_data_t fu_data;

    logic csr_ready;
    logic csr_valid;
    riscv::xlen_t csr_result;
    logic csr_commit;
    logic [11:0] csr_addr;

    csr_buffer #(
        .XLEN(64)
    ) csr_buffer_i (
        .clk_i(clk),
        .rst_ni(rst_n),
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
        rst_n = 1;
        flush = 0;

        fu_data = '{default: 0};

        csr_ready = 0;
        csr_valid = 0;
        csr_result = 0;
        csr_commit = 0;
        csr_addr = 0;

        #10;
        rst_n = 0;

        #100;
        fu_data = '{default: 0, operand_b: 10};
        csr_valid = 1;
        #10;
        csr_valid = 0;
        #10;
        csr_commit = 1;
        #10;
        csr_commit = 0;
        #10;
        flush = 1;
        #10;
        flush = 0;
        #10;
        csr_valid = 1;
        #10;
        csr_valid = 0;
        #10;
        csr_commit = 1;
        #10;
        csr_commit = 0;
        #10;
        flush = 1;
        #10;
        flush = 0;
        #10;
    end

    always #5 clk = ~clk;

endmodule
