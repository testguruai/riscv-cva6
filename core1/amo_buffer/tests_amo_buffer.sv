# VerifAI TestGuru
# tests for: amo_buffer.sv
```
`include "testbench.sv"

module amo_buffer_tb;

    logic clk, rst;
    logic flush;

    logic valid, ready;
    ariane_pkg::amo_t amo_op;
    logic [riscv::PLEN-1:0] paddr;
    riscv::xlen_t data;
    logic [1:0] data_size;

    ariane_pkg::amo_req_t amo_req;
    ariane_pkg::amo_resp_t amo_resp;

    logic amo_valid_commit;
    logic no_st_pending;

    amo_buffer #(
        .DEPTH(1)
    ) amo_buffer_i (
        .clk_i(clk),
        .rst_ni(rst),
        .flush_i(flush),

        .valid_i(valid),
        .ready_o(ready),
        .amo_op_i(amo_op),
        .paddr_i(paddr),
        .data_i(data),
        .data_size_i(data_size),

        .amo_req_o(amo_req),
        .amo_resp_i(amo_resp),

        .amo_valid_commit_i(amo_valid_commit),
        .no_st_pending_i(no_st_pending)
    );

    initial begin
        clk = 0;
        rst = 1;
        #10;
        rst = 0;

        valid = 1;
        amo_op = ariane_pkg::amo_op::amo_add;
        paddr = 'h0;
        data = 'h1;
        data_size = 2'b01;

        #10;
        valid = 0;

        #10;
        amo_valid_commit = 1;

        #10;
        no_st_pending = 1;

        #10;
        valid = 1;
        amo_op = ariane_pkg::amo_op::amo_add;
        paddr = 'h1;
        data = 'h2;
        data_size = 2'b01;

        #10;
        valid = 0;

        #10;
        amo_valid_commit = 0;

        #10;
        no_st_pending = 0;

        #10;
        valid = 1;
        amo_op = ariane_pkg::amo_op::amo_add;
        paddr = 'h2;
        data = 'h3;
        data_size = 2'b01;

        #10;
        valid = 0;

        #10;
        $stop;
    end

    always #5 clk = ~clk;

endmodule
```