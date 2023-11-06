# VerifAI TestGuru
# tests for: load_unit.sv
```
module load_unit import ariane_pkg::*; #(
    parameter ariane_pkg::ariane_cfg_t ArianeCfg = ariane_pkg::ArianeDefaultConfig
) (
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
    input  dcache_req_o_t             req_port_i,
    output dcache_req_i_t             req_port_o,
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

    // page offset is defined as the lower 12 bits, feed through for address checker
    assign page_offset_o = lsu_ctrl_i.vaddr[11:0];
    // feed-through the virtual address for VA translation
    assign vaddr_o = lsu_ctrl_i.vaddr;
    // this is a read-only interface so set the write enable to 0
    assign req_port_o.data_we = 1'b0;
    // tag control
    assign req_port_o.kill_req  = 1'b0;
    assign req_port_o.tag_valid = 1'b0;
    assign req_port_o.data_be   = lsu_ctrl_i.be;
    assign req_port_o.data_size = extract_transfer_size(lsu_ctrl_i.operator);
    pop_ld_o             = 1'b0;

    logic paddr_ni;
    logic not_commit_time;
    logic inflight_stores;
    logic stall_ni;
    assign paddr_ni = is_inside_nonidempotent_regions(ArianeCfg, {dtlb_ppn_i,12'd0});
    assign not_