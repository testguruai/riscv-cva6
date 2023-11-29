// VerifAI TestGuru
// tests for: issue_read_operands.sv

module issue_read_operands import ariane_pkg::*; #(
    parameter int unsigned NR_COMMIT_PORTS = 2
)(
  input  logic                                   clk_i,    // Clock
  input  logic                                   rst_ni,   // Asynchronous reset active low
  // flush
  input  logic                                   flush_i,
  // coming from rename
  input  scoreboard_entry_t                      issue_instr_i,
  input  logic                                   issue_instr_valid_i,
  output logic                                   issue_ack_o,
  // lookup rd in scoreboard
  output logic [REG_ADDR_SIZE-1:0]               rs1_o,
  input  riscv::xlen_t                           rs1_i,
  input  logic                                   rs1_valid_i,
  output logic [REG_ADDR_SIZE-1:0]               rs2_o,
  input  riscv::xlen_t                           rs2_i,
  input  logic                                   rs2_valid_i,
  output logic [REG_ADDR_SIZE-1:0]               rs3_o,
  input  rs3_len_t                               rs3_i,
  input  logic                                   rs3_valid_i,
  // get clobber input
  input  fu_t [2**REG_ADDR_SIZE-1:0]             rd_clobber_gpr_i,
  input  fu_t [2**REG_ADDR_SIZE-1:0]             rd_clobber_fpr_i,
  // To FU, just single issue for now
  output fu_data_t                               fu_data_o,
  output riscv::xlen_t                           rs1_forwarding_o,  // unregistered version of fu_data_o.operanda
  output riscv::xlen_t                           rs2_forwarding_o,  // unregistered version of fu_data_o.operandb
  output logic [riscv::VLEN-1:0]                 pc_o,
  output logic                                   is_compressed_instr_o,
  // ALU 1
  input  logic                                   flu_ready_i,      // Fixed latency unit ready to accept a new request
  output logic                                   alu_valid_o,      // Output is valid
  // Branches and Jumps
  output logic                                   branch_valid_o,   // this is a valid branch instruction
  output branchpredict_sbe_t                     branch_predict_o,
  // LSU
  input  logic                                   lsu_ready_i,      // FU is ready
  output logic                                   lsu_valid_o,      // Output is valid
  // MULT
  output logic                                   mult_valid_o,     // Output is valid
  // FPU
  input  logic                                   fpu_ready_i,      // FU is ready
  output logic                                   fpu_valid_o,      // Output is valid
  output logic [1:0]                             fpu_fmt_o,        // FP fmt field from instruction
  output logic [2:0]                             fpu_rm_o,         // FP rm field from instruction
  // CSR
  output logic                                   csr_valid_o,      // Output is valid
  // CVXIF
  output logic                                   cvxif_valid_o,
  output logic [31:0]                            cvxif_off_instr_o,
  // commit port
  input  logic [NR_COMMIT_PORTS-1:0][4:0]        waddr_i,
  input  logic [NR_COMMIT_PORTS-1:0][riscv::XLEN-1:0] wdata_i,
  input  logic [NR_COMMIT_PORTS-1:0]             we_gpr_i,
  input  logic [NR_COMMIT_PORTS-1:0]             we_fpr_i, // Added a missing comma
  // committing instruction instruction
  // from scoreboard
  // input  scoreboard_entry     commit_instr_i,
  // output logic                commit_ack_o
);
  logic stall;
