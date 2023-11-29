// VerifAI TestGuru
// tests for: amo_buffer.sv

`include "testbench.sv"

module amo_buffer_tb;

    logic clk, rst;
    logic flush;

    logic valid, ready;
    riscv::amo_t amo_op;
    riscv::paddr_t paddr;
    riscv::xlen_t data;
    logic [1:0] data_size;

    riscv::amo_req_t amo_req;
    riscv::amo_resp_t amo_resp;

    logic amo_valid_commit;
    logic no_st_pending;

    amo_buffer #(
        .DEPTH(2)
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
        forever #5 clk = ~clk;
    end

    initial begin
        valid <= 0;
        ready <= 1;
        amo_op <= '0;
        paddr <= '0;
        data <= '0;
        data_size <= '0;

        amo_valid_commit = 0;
        no_st_pending = 0;

        #10
        valid <= 1;
        amo_op <= riscv::amo_op_add;
        paddr <= 'h1000;
        data <= 'h1234;
        data_size <= 2'b01;

        #10
        valid <= 0;

        #10
        amo_valid_commit = 1;
        no_st_pending = 1;

        #10
        $display("amo_req.req = %b", amo_req.req);
        $display("amo_req.amo_op = %d", amo_req.amo_op);
        $display("amo_req.size = %d", amo_req.size);
        $display("amo_req.operand_a = %h", amo_req.operand_a);
        $display("amo_req.operand_b = %h", amo_req.operand_b);

        #10
        $finish();
    end

endmodule
