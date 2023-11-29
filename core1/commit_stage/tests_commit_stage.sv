// VerifAI TestGuru
 // tests for: commit_stage.sv

module commit_stage import ariane_pkg::*; #(
    parameter int unsigned NR_COMMIT_PORTS = 2
)(
    input  logic                                    clk_i,
    input  logic                                    rst_ni,
    input  logic                                    halt_i,             // request to halt the core
    input  logic                                    flush_dcache_i,     // request to flush dcache -> also flush the pipeline
    output exception_t                              exception_o,        // take exception to controller
    output logic                                    dirty_fp_state_o,   // mark the F state as dirty
    input  logic                                    single_step_i,      // we are in single step debug mode
    // from scoreboard
    input  scoreboard_entry_t [NR_COMMIT_PORTS-1:0] commit_instr_i,     // the instruction we want to commit
    output logic [NR_COMMIT_PORTS-1:0]              commit_ack_o,       // acknowledge that we are indeed committing
    // to register file
    output  logic [NR_COMMIT_PORTS-1:0][4:0]        waddr_o,            // register file write address
    output  logic [NR_COMMIT_PORTS-1:0][riscv::XLEN-1:0] wdata_o,       // register file write data
    output  logic [NR_COMMIT_PORTS-1:0]             we_gpr_o,           // register file write enable
    output  logic [NR_COMMIT_PORTS-1:0]             we_fpr_o,           // floating point register enable
    // Atomic memory operations
    input  amo_resp_t                               amo_resp_i,         // result of AMO operation
    // to CSR file and PC Gen (because on certain CSR instructions we'll need to flush the whole pipeline)
    output logic [riscv::VLEN-1:0]                  pc_o,
    // to/from CSR file
    output fu_op                                    csr_op_o,           // decoded CSR operation
    output riscv::xlen_t                            csr_wdata_o,        // data to write to CSR
    input  riscv::xlen_t                            csr_rdata_i,        // data to read from CSR
    input  exception_t                              csr_exception_i,    // exception or interrupt occurred in CSR stage (the same as commit)
    output logic                                    csr_write_fflags_o, // write the fflags CSR
    // commit signals to ex
    output logic                                    commit_lsu_o,       // commit the pending store
    input  logic                                    commit_lsu_ready_i, // commit buffer of LSU is ready
    output logic [TRANS_ID_BITS-1:0]                commit_tran_id_o,   // transaction id of first commit port
    output logic                                    amo_valid_commit_o, // valid AMO in commit stage
    input  logic                                    no_st_pending_i,    // there is no store pending
    output logic                                    commit_csr_o,       // commit the pending CSR instruction
    output logic                                    fence_i_o,          // flush I$ and pipeline
    output logic                                    fence_o,            // flush D$ and pipeline
    output logic                                    flush_commit_o,     // request a pipeline flush
    output logic                                    sfence_vma_o        // flush TLBs and pipeline
);

// ila_0 i_ila_commit (
//     .clk(clk_i), // input wire clk
//     .probe0(commit_instr_i[0].pc), // input wire [63:0]  probe0
//     .probe1(commit_instr_i[1].pc), // input wire [63:0]  probe1
//     .probe2(commit_instr_i[0].valid), // input wire [0:0]  probe2
//     .probe3(commit_instr_i[1].valid), // input wire [0:0]  probe3
//     .probe4(commit_ack_o[0]), // input wire [0:0]  probe4
//     .probe5(commit_ack_o[0]), // input wire [0:0]  probe5
//     .probe6(1'b0),