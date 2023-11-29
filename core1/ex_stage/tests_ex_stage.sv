// VerifAI TestGuru
// tests for: ex_stage.sv

module ex_stage import ariane_pkg::*; #(
    parameter int unsigned ASID_WIDTH = 1,
    parameter ariane_pkg::ariane_cfg_t ArianeCfg = ariane_pkg::ArianeDefaultConfig
) (
    input  logic                                   clk_i,                // Clock
    input  logic                                   rst_ni,               // Asynchronous reset active low
    input  logic                                   flush_i,
    input  logic                                   debug_mode_i,

    input  logic [riscv::VLEN-1:0]                 rs1_forwarding_i,
    input  logic [riscv::VLEN-1:0]                 rs2_forwarding_i,
    input  fu_data_t                               fu_data_i,
    input  logic [riscv::VLEN-1:0]                 pc_i,                  // PC of current instruction
    input  logic                                   is_compressed_instr_i, // we need to know if this was a compressed instruction
                                                                        // in order to calculate the next PC on a mis-predict
    // Fixed latency unit(s)
    output riscv::xlen_t                           flu_result_o,
    output logic [TRANS_ID_BITS-1:0]               flu_trans_id_o,
    output exception_t                             flu_exception_o,
    output logic                                   flu_ready_o,           // FLU is ready
    output logic                                   flu_valid_o,           // FLU result is valid
    // Branches and Jumps
    // ALU 1
    input  logic                                   alu_valid_i,           // Output is valid
    // Branch Unit
    input  logic                                   branch_valid_i,        // we are using the branch unit
    input  branchpredict_sbe_t                     branch_predict_i,
    output bp_resolve_t                            resolved_branch_o,     // the branch engine uses the write back from the ALU
    output logic                                   resolve_branch_o,      // to ID signaling that we resolved the branch
    // CSR
    input  logic                                   csr_valid_i,
    output logic [11:0]                            csr_addr_o,
    input  logic                                   csr_commit_i,
    // MULT
    input  logic                                   mult_valid_i,          // Output is valid
    // LSU
    output logic                                   lsu_ready_o,           // FU is ready
    input  logic                                   lsu_valid_i,           // Input is valid

    output logic                                   load_valid_o,
    output riscv::xlen_t                           load_result_o,
    output logic [TRANS_ID_BITS-1:0]               load_trans_id_o,
    output exception_t                             load_exception_o,
    output logic                                   store_valid_o,
    output riscv::xlen_t                           store_result_o,
    output logic [TRANS_ID_BITS-1:0]               store_trans_id_o,
    output exception_t                             store_exception_o,

    input  logic                                   lsu_commit_i,
    output logic                                   lsu_commit_ready_o,    // commit queue is ready to accept another commit request
    input  logic [TRANS_ID_BITS-1:0]               commit_tran_id_i,
    output logic                                   no_st_pending_o,
    input  logic                                   amo_valid_commit_i,
    output amo_req_t                               amo_req_o,             // request to cache subsytem
    input  amo_resp_t                              amo_resp_i,            // response from cache subsystem
    // Performance counters
    output logic                                   itlb_miss_o,
    output logic                                   dtlb_miss_o,
    // PMPs
    input  riscv::pmpcfg_t [15:0]                  pmpcfg_i,
    input  logic[15:0][riscv::PLEN-3:0]            pmpaddr_i,
    ...
)
