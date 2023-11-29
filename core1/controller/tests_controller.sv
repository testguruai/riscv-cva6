// VerifAI TestGuru
// tests for: controller.sv

module controller_tb;

    input logic clk;
    input logic rst_ni;
    output logic set_pc_commit_o;
    output logic flush_if_o;
    output logic flush_unissued_instr_o;
    output logic flush_id_o;
    output logic flush_ex_o;
    output logic flush_bp_o;
    output logic flush_icache_o;
    output logic flush_dcache_o;
    input logic flush_dcache_ack_i;
    output logic flush_tlb_o;
    input logic halt_csr_i;
    output logic halt_o;
    input logic eret_i;
    input logic ex_valid_i;
    input logic set_debug_pc_i;
    input bp_resolve_t resolved_branch_i;
    input logic fence_i_i;
    output logic fence_i;
    input logic sfence_vma_i;
    output logic flush_commit_i;

    controller #(
        .WT_DCACHE(1)
    ) dut(
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
        .fence_i_i(fence_i_i),
        .fence_i(fence_i),
        .sfence_vma_i(sfence_vma_i),
        .flush_commit_i(flush_commit_i)
    );

    initial begin
        // set clock and reset
        clk = 0;
        rst_ni = 1;
        #10;
        rst_ni = 0;

        // test fence
        #10;
        fence_i_i = 1;
        #10;
        fence_i_i = 0;

        // test sfence.vma
        #10;
        sfence_vma_i = 1;
        #10;
        sfence_vma_i = 0;

        // test flush commit
        #10;
        flush_commit_i = 1;
        #10;
        flush_commit_i = 0;

        // test halt
        #10;
        halt_csr_i = 1;
        #10;
        halt_csr_i = 0;

        // test exception
        #10;
        ex_valid_i = 1;
        #10;
        ex_valid_i = 0;

        // test set debug pc
        #10;
        set_debug_pc_i = 1;
        #10;
        set_debug_pc_i = 0;

        // test resolved branch
        #10;
        resolved_branch_i.is_mispredict = 1;
        #10;
        resolved_branch_i.is_mispredict = 0;

        $stop;
    end

    always #10 clk = ~clk;
endmodule
