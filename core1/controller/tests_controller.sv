# VerifAI TestGuru
# tests for: controller.sv
```
module controller_tb;

    logic clk;
    logic rst_ni;

    logic set_pc_commit_o;
    logic flush_if_o;
    logic flush_unissued_instr_o;
    logic flush_id_o;
    logic flush_ex_o;
    logic flush_bp_o;
    logic flush_icache_o;
    logic flush_dcache_o;
    logic flush_dcache_ack_i;
    logic flush_tlb_o;

    logic halt_csr_i;
    logic halt_o;
    logic eret_i;
    logic ex_valid_i;
    logic set_debug_pc_i;
    bp_resolve_t resolved_branch_i;
    logic flush_csr_i;
    logic fence_i_i;
    logic fence_i;
    logic sfence_vma_i;
    logic flush_commit_i;

    controller #(
        .WT_DCACHE(1)
    ) dut (
        .clk_i(clk),
        .rst_ni(rst_ni),
        .set_pc_commit_o(set_pc_commit_o),
        .flush_if_o(flush_if_o),
        .flush_unissued_instr_o(flush_unissued_instr_o),
        .flush_id_o(flush_id_o),
        .flush_ex_o(flush_ex_o),
        .flush_bp_o(flush_bp_o),
        .flush_icache_o(flush_icache_o),
        .flush_dcache_o(flush_dcache_o),
        .flush_dcache_ack_i(flush_dcache_ack_i),
        .flush_tlb_o(flush_tlb_o),

        .halt_csr_i(halt_csr_i),
        .halt_o(halt_o),
        .eret_i(eret_i),
        .ex_valid_i(ex_valid_i),
        .set_debug_pc_i(set_debug_pc_i),
        .resolved_branch_i(resolved_branch_i),
        .flush_csr_i(flush_csr_i),
        .fence_i_i(fence_i_i),
        .fence_i(fence_i),
        .sfence_vma_i(sfence_vma_i),
        .flush_commit_i(flush_commit_i)
    );

    initial begin
        // Initialize all signals
        clk = 0;
        rst_ni = 1;
        set_pc_commit_o = 0;
        flush_if_o = 0;
        flush_unissued_instr_o = 0;
        flush_id_o = 0;
        flush_ex_o = 0;
        flush_bp_o = 0;
        flush_icache_o = 0;
        flush_dcache_o = 0;
        flush_dcache_ack_i = 0;
        flush_tlb_o = 0;

        halt_csr_i = 0;
        halt_o = 0;
        eret_i = 0;
        ex_valid_i = 0;
        set_debug_pc_i = 0;
        resolved_branch_i = '0;
        flush_csr_i = 0;
        fence_i_i = 0;
        fence_i = 0;
        sfence_vma_i = 0;
        flush_commit_i = 0;

        #10 rst_ni = 0;

        #1000000 $finish;
    end

    always #5 clk = ~clk;
endmodule
```