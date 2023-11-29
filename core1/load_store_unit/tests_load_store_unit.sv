// VerifAI TestGuru
// tests for: load_store_unit.sv

module testbench;

    logic clk_i;
    logic rst_ni;
    logic flush_i;
    logic amo_valid_commit_i;

    logic [riscv::XLEN-1:0] fu_data_i;
    logic lsu_ready_o;
    logic lsu_valid_i;

    logic [TRANS_ID_BITS-1:0] load_trans_id_o;
    logic [riscv::XLEN-1:0] load_result_o;
    logic load_valid_o;
    logic [riscv::XLEN-1:0] load_exception_o;

    logic [TRANS_ID_BITS-1:0] store_trans_id_o;
    logic [riscv::XLEN-1:0] store_result_o;
    logic store_valid_o;
    logic [riscv::XLEN-1:0] store_exception_o;

    logic commit_i;
    logic commit_ready_o;
    logic [TRANS_ID_BITS-1:0] commit_tran_id_i;

    logic [riscv::VLEN-1:0] vaddr_i;
    logic [riscv::XLEN/8-1:0] be_i;

    logic [riscv::VLEN-1:0] mmu_vaddr;
    logic [riscv::PLEN-1:0] mmu_paddr;
    logic [riscv::XLEN-1:0] mmu_exception;

    logic [2] dcache_req_ports_i;
    logic [2] dcache_req_ports_o;
    logic dcache_wbuffer_empty_i;
    logic dcache_wbuffer_not_ni_i;

    logic itlb_miss_o;
    logic dtlb_miss_o;
    logic dtlb_hit_o;
    logic [riscv::XLEN-1:0] dtlb_ppn_i;

    logic [15:0] pmpcfg_i;
    logic [15:0][riscv::PLEN-3:0] pmpaddr_i;

    load_store_unit #(
        .ArianeCfg ( ArianeCfg )
    ) i_load_store_unit (
        .clk_i,
        .rst_ni,
        .flush_i,
        .no_st_pending_o,
        .store_buffer_empty_o  ( store_buffer_empty_o   ),

        .valid_i               ( lsu_valid_i           ),
        .lsu_ctrl_i            ( lsu_ctrl             ),
        .pop_st_o              ( pop_st               ),
        .commit_i,
        .commit_ready_o,
        .amo_valid_commit_i,

        .valid_o               ( load_valid_o           ),
        .trans_id_o            ( load_trans_id_o          ),
        .result_o              ( load_result_o            ),
        .ex_o                  ( load_exception_o        ),
        // MMU port
        .translation_req_o     ( ld_translation_req   ),
        .vaddr_o               ( ld_vaddr             ),
        .paddr_i               ( mmu_paddr            ),
        .ex_i                  ( mmu_exception        ),
        .dtlb_hit_i            ( dtlb_hit             ),
        // Load Unit
        .page_offset_i         ( page_offset          ),
        .page_offset_matches_o ( page_offset_matches  ),
        .store_buffer_empty_i  ( store_buffer_empty   ),
        // to memory arbiter
        .req_port_i            ( dcache_req_ports_i[1] ),
        .req_port_o            ( dcache_req_ports_o[1] ),
        .commit_tran_id_i,
        .*
    );

endmodule
