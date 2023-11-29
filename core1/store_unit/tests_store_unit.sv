// VerifAI TestGuru
// tests for: store_unit.sv

module testbench;

    logic clk = 0;
    logic rst_ni;
    logic flush_i;
    logic no_st_pending_o;
    logic store_buffer_empty_o;
    logic valid_i;
    lsu_ctrl_t lsu_ctrl_i;
    logic pop_st_o;
    logic commit_i;
    logic commit_ready_o;
    logic amo_valid_commit_i;
    logic valid_o;
    logic [TRANS_ID_BITS-1:0] trans_id_o;
    riscv::xlen_t result_o;
    exception_t ex_o;
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
        .clk_i(clk),
        .rst_ni(rst_ni),
        .flush_i(flush_i),
        .no_st_pending_o(no_st_pending_o),
        .store_buffer_empty_o(store_buffer_empty_o),
        .valid_i(valid_i),
        .lsu_ctrl_i(lsu_ctrl_i),
        .pop_st_o(pop_st_o),
        .commit_i(commit_i),
        .commit_ready_o(commit_ready_o),
        .amo_valid_commit_i(amo_valid_commit_i),
        .valid_o(valid_o),
        .trans_id_o(trans_id_o),
        .result_o(result_o),
        .ex_o(ex_o),
        .translation_req_o(translation_req_o),
        .vaddr_o(vaddr_o),
        .paddr_i(paddr_i),
        .ex_i(ex_i),
        .dtlb_hit_i(dtlb_hit_i),
        .page_offset_i(page_offset_i),
        .page_offset_matches_o(page_offset_matches_o),
        .amo_req_o(amo_req_o),
        .amo_resp_i(amo_resp_i),
        .req_port_i(req_port_i),
        .req_port_o(req_port_o)
    );

    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst_ni = 1'b1;
        #100; rst_ni = 1'b0;

        valid_i = 1'b1;
        lsu_ctrl_i.operator = AMO_LRD;
        lsu_ctrl_i.vaddr = 32'h1000;
        lsu_ctrl_i.data = 32'h1234;
        lsu_ctrl_i.be = 4'b1111;
        lsu_ctrl_i.data_size = 2'b11;
        #100;
        valid_i = 1'b0;
        #100;
        valid_i = 1'b1;
        lsu_ctrl_i.operator = AMO_LRD;
        lsu_ctrl_i.vaddr = 32'h1004;
        lsu_ctrl_i.data = 32'h5678;
        lsu_ctrl_i.be = 4'b1111;
        lsu_ctrl_i.data_size = 2'b11;
        #100;
        valid_i = 1'b0;
        #100;
        valid_i = 1'b1;
        lsu_ctrl_i.operator = AMO_LRD;
        lsu_ctrl_i.vaddr = 32'h1008;
        lsu_ctrl_i.data = 32'h9012;
        lsu_ctrl_i.be = 4'b1111;
        lsu_ctrl_amo_re And the following recommended fixes
        #100; valid_i = 1'b0;
        #100;
        #100; valid_i = 1'b0;
    end
end
