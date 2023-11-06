# VerifAI TestGuru
# tests for: scoreboard.sv
```
module scoreboard #(
  parameter int unsigned NR_ENTRIES      = 8,
  parameter int unsigned NR_WB_PORTS     = 1,
  parameter int unsigned NR_COMMIT_PORTS = 2
) (
  input  logic                                  clk_i,    // Clock
  input  logic                                  rst_ni,   // Asynchronous reset active low
  output logic                                  sb_full_o,
  input  logic                                  flush_unissued_instr_i, // flush only un-issued instructions
  input  logic                                  flush_i,  // flush whole scoreboard
  input  logic                                  unresolved_branch_i, // we have an unresolved branch
  // list of clobbered registers to issue stage
  output ariane_pkg::fu_t [2**ariane_pkg::REG_ADDR_SIZE-1:0]    rd_clobber_gpr_o,
  output ariane_pkg::fu_t [2**ariane_pkg::REG_ADDR_SIZE-1:0]    rd_clobber_fpr_o,

  // regfile like interface to operand read stage
  input  logic [ariane_pkg::REG_ADDR_SIZE-1:0]                  rs1_i,
  output logic                                                  rs1_valid_o,

  input  logic [ariane_pkg::REG_ADDR_SIZE-1:0]                  rs2_i,
  output logic                                                  rs2_valid_o,

  input  logic [ariane_pkg::REG_ADDR_SIZE-1:0]                  rs3_i,
  output logic                                                  rs3_valid_o,

  // advertise instruction to commit stage, if commit_ack_i is asserted advance the commit pointer
  output ariane_pkg::scoreboard_entry_t                         commit_instr_o,
  output logic                                                  commit_instr_valid_o,
  input  logic                                                  commit_ack_i,

  // write-back port
  input  ariane_pkg::bp_resolve_t                                resolved_branch_i,
  input  logic [NR_WB_PORTS-1:0][ariane_pkg::TRANS_ID_BITS-1:0]  trans_id_i,  // transaction ID at which to write the result back
  input  logic [NR_WB_PORTS-1:0][riscv::XLEN-1:0]                wbdata_i,    // write data in
  input  logic [NR_WB_PORTS-1:0]                                wt_valid_i,  // data in is valid
  input  logic                                                   x_we_i,      // cvxif we for writeback

  // RVFI
  input  [riscv::VLEN-1:0]                                       lsu_addr_i,
  input  [(riscv::XLEN/8)-1:0]                                   lsu_rmask_i,
  input  [(riscv::XLEN/8)-1:0]                                   lsu_wmask_i,
  input  [ariane_pkg::TRANS_ID_BITS-1:0]                         lsu_addr_trans_id_i,
  input  riscv::xlen_t                                            rs1_forwarding_i,
  input  riscv::xlen_t                                            rs2_forwarding_i
);
  localparam int unsigned BITS_ENTRIES = $clog2(NR_ENTRIES);

  // this is the FIFO struct of the issue queue
  typedef struct packed {
    logic                          issued;         // this bit indicates whether we issued this instruction e.g.: if it is valid
    logic                          is_rd_fpr_flag; // redundant meta info, added for speed
    ariane_pkg::scoreboard_entry_t sbe;            // this is the score board entry we will send to ex
  } sb_mem_t;
  sb_mem_t mem_q, mem_n;

  logic                    issue_full, issue_en;
  logic [BITS_ENTRIES:0]   issue_cnt_n,      issue_cnt_q;
  logic [BITS_ENTRIES-1:0] issue_pointer_n,  issue_pointer_q;
 