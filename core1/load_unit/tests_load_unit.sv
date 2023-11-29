// VerifAI TestGuru
// tests for: load_unit.sv

module load_unit #(ariane_cfg_t ArianeCfg = ArianeDefaultConfig) (
    input  logic                     clk_i,    // Clock
    input  logic                     rst_ni,   // Asynchronous reset active low
    input  logic                     flush_i,
    // load unit input port
    input  logic                     valid_i,
    input  lsu_ctrl_t                lsu_ctrl_i,
    output logic                     pop_ld_o,
    // load unit output port
    output logic                     valid_o,
    output logic [TRANS_ID_BITS-1:0] trans_id_o,
    output riscv::xlen_t             result_o,
    output exception_t               ex_o,
    // MMU -> Address Translation
    output logic                     translation_req_o,   // request address translation
    output logic [riscv::VLEN-1:0]   vaddr_o,             // virtual address out
    input  logic [riscv::PLEN-1:0]   paddr_i,             // physical address in
    input  exception_t               ex_i,                 // exception which may has happened earlier. for example: mis-aligned exception
    input  logic                     dtlb_hit_i,          // hit on the dtlb, send in the same cycle as the request
    input  logic [riscv::PPNW-1:0]   dtlb_ppn_i,          // ppn on the dtlb, send in the same cycle as the request
    // address checker
    output logic [11:0]              page_offset_o,
    input  logic                     page_offset_matches_i,
    input  logic                     store_buffer_empty_i, // the entire store-buffer is empty
    input  logic [TRANS_ID_BITS-1:0] commit_tran_id_i,
    // D$ interface
    input dcache_req_o_t             req_port_i,
    output dcache_req_i_t            req_port_o,
    input  logic                     dcache_wbuffer_not_ni_i
);

    enum logic [3:0] { IDLE, WAIT_GNT, SEND_TAG, WAIT_PAGE_OFFSET,
                       ABORT_TRANSACTION, ABORT_TRANSACTION_NI, WAIT_TRANSLATION, WAIT_FLUSH,
                       WAIT_WB_EMPTY
                     } state_d, state_q;
    
    // in order to decouple the response interface from the request interface we need a
    // a queue which can hold all outstanding memory requests
    struct packed {
        logic [TRANS_ID_BITS-1:0]         trans_id;
        logic [riscv::XLEN_ALIGN_BYTES-1:0] address_offset;
        fu_op                             operator;
    } load_data_d, load_data_q, in_data;

    // output address
    // we can now output the lower 12 bit as the index to the cache
    assign req_port_o.address_index = lsu_ctrl_i.vaddr[ariane_pkg::DCACHE_INDEX_WIDTH-1:0];
    // translation from last cycle, again: control is handled in the FSM
    assign req_port_o.address_tag   = paddr_i[ariane_pkg::DCACHE_TAG_WIDTH +
                                              ariane_pkg::DCACHE_INDEX_WIDTH-1:0];
    
endmodule
