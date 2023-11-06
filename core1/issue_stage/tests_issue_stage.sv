# VerifAI TestGuru
# tests for: issue_stage.sv
```
module issue_stage import ariane_pkg::*; #(
    parameter int unsigned NR_ENTRIES = 8,
    parameter int unsigned NR_WB_PORTS = 4,
    parameter int unsigned NR_COMMIT_PORTS = 2
)(
    input  logic                                     clk_i,     // Clock
    input  logic                                     rst_ni,    // Asynchronous reset active low

    output logic                                     sb_full_o,
    input  logic                                     flush_unissued_instr_i,
    input  logic                                     flush_i,
    // from ISSUE
    input  scoreboard_entry_t                        decoded_instr_i,
    input  logic                                     decoded_instr_valid_i,
    input  logic                                     is_ctrl_flow_i,
    output logic                                     decoded_instr_ack_o,
    // to EX
    output [riscv::VLEN-1:0]                         rs1_forwarding_o,  // unregistered version of fu_data_o.operanda
    output [riscv::VLEN-1:0]                         rs2_forwarding_o, // unregistered version of fu_data_o.operandb
    output fu_data_t                                 fu_data_o,
    output logic [riscv::VLEN-1:0]                   pc_o,
    output logic                                     is_compressed_instr_o,
    input  logic                                     flu_ready_i,
    output logic                                     alu_valid_o,
    // ex just resolved our predicted branch, we are ready to accept new requests
    input  logic                                     resolve_branch_i,

    input  logic                                     lsu_ready_i,
    output logic                                     lsu_valid_o,
    // branch prediction
    output logic                                     branch_valid_o,   // use branch prediction unit
    output branchpredict_sbe_t                       branch_predict_o, // Branch predict Out

    output logic                                     mult_valid_o,

    input  logic                                     fpu_ready_i,
    output logic                                     fpu_valid_o,
    output logic [1:0]                               fpu_fmt_o,        // FP fmt field from instr.
    output logic [2:0]                               fpu_rm_o,         // FP rm field from instr.

    output logic                                     csr_valid_o,

    // CVXIF
    //Issue interface
    output logic                                     x_issue_valid_o,
    input  logic                                     x_issue_ready_i,
    output logic [31:0]                              x_off_instr_o,

    // write back port
    input logic [NR_WB_PORTS-1:0][TRANS_ID_BITS-1:0] trans_id_i,
    input bp_resolve_t                               resolved_branch_i,
    input logic [NR_WB_PORTS-1:0][riscv::XLEN-1:0]   wbdata_i,
    input exception_t [NR_WB_PORTS-1:0]              ex_ex_i, // exception from execute stage or CVXIF offloaded instruction
    input logic [NR_WB_PORTS-1:0]                    wt_valid_i,
    input logic                                      x_we_i,

    // commit port
    input  logic [NR_COMMIT_PORTS-1:0][4:0]          waddr_i,
    input  logic [NR_COMMIT_PORTS-1:0][riscv::XLEN-1:0] wdata_i,
    input  logic [NR_COMMIT_PORTS-1:0]               we_gpr_i,
    input  logic [NR_COMMIT_PORTS-1:0]               we_fpr_i,

    output scoreboard_entry_t [NR_COMMIT_PORTS-1:0]  commit_instr_o,
    input  logic              [NR_COMMIT_PORTS-1:0]  commit_ack_i,

    //RVFI
    input [riscv::VLEN-1:0]                          lsu_addr_i,
    input [(riscv::XLEN/8)-1:0]                      lsu_rmask_