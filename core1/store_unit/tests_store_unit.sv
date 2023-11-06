# VerifAI TestGuru
# tests for: store_unit.sv
```
module test_store_unit;

    logic clk, rst_ni;
    logic flush;
    logic no_st_pending_o;
    logic store_buffer_empty_o;
    logic valid_i, lsu_ctrl_i;
    logic pop_st_o;
    logic commit_i;
    logic commit_ready_o;
    logic amo_valid_commit_i;
    logic valid_o, trans_id_o, result_o, ex_o;
    logic translation_req_o;
    logic [riscv::VLEN-1:0] vaddr_o;
    logic [riscv::PLEN-1:0] paddr_i;
    exception_t ex_i;
    logic dtlb_hit_i;
    logic [11:0] page_offset_i;
    logic page_offset_matches_o;
    amo_req_t amo_req_o;
    amo_resp_t amo_resp_i;
    dcache_req_o_t req_port_i;
    dcache_req_i_t req_port_o;

    store_unit dut(
        .clk_i,
        .rst_ni,
        .flush_i,
        .no_st_pending_o,
        .store_buffer_empty_o,
        .valid_i,
        .lsu_ctrl_i,
        .pop_st_o,
        .commit_i,
        .commit_ready_o,
        .amo_valid_commit_i,
        .valid_o,
        .trans_id_o,
        .result_o,
        .ex_o,
        .translation_req_o,
        .vaddr_o,
        .paddr_i,
        .ex_i,
        .dtlb_hit_i,
        .page_offset_i,
        .page_offset_matches_o,
        .amo_req_o,
        .amo_resp_i,
        .req_port_i,
        .req_port_o
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_ni = 1'b1;
        #10 rst_ni = 1'b0;

        valid_i = 1'b0;
        lsu_ctrl_i = '0;
        pop_st_o = 1'b0;
        commit_i = 1'b0;
        amo_valid_commit_i = 1'b0;

        #100;

        valid_i = 1'b1;
        lsu_ctrl_i = riscv::lsu_ctrl_t'(
            .op     = riscv::OP_STORE,
            .rd     = '0,
            .rs1    = '0,
            .rs2    = '0,
            .imm    = '0,
            .be     = '0,
            .data   = '0,
            .trans_id = '0
        );

        #100;

        valid_i = 1'b0;
        lsu_ctrl_i = '0;
        pop_st_o = 1'b0;
        commit_i = 1'b0;
        amo_valid_commit_i = 1'b0;

        #100;

        valid_i = 1'b1;
        lsu_ctrl_i = riscv::lsu_ctrl_t'(
            .op     = riscv::OP_AMO_ADDW,
            .rd     = '0,
            .rs1    = '0,
            .rs2    = '0,
            .imm    = '0,
            .be     = '0,
            .data   = '0,
            .trans_id = '0
        