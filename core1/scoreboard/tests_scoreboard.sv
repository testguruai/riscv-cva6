// VerifAI TestGuru
// tests for: scoreboard.sv
Incomplete test case.

Please add a test case that exercises the scoreboard module.

Here is a possible test case:


module test;
  scoreboard (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .sb_full_o(sb_full_o),
    .flush_unissued_instr_i(flush_unissued_instr_i),
    .flush_i(flush_i),
    .unresolved_branch_i(unresolved_branch_i),
    .rd_clobber_gpr_o(rd_clobber_gpr_o),
    .rd_clobber_fpr_o(rd_clobber_fpr_o),

    .rs1_i(rs1_i),
    .rs1_valid_o(rs1_valid_o),

    .rs2_i(rs2_i),
    .rs2_valid_o(rs2_valid_o),

    .decoded_instr_i(decoded_instr_i),
    .decoded_instr_valid_i(decoded_instr_valid_i),

    .commit_ack_i(commit_ack_i)
  );

  input clk_i;
  input rst_ni;
  output sb_full_o;
  input flush_unissued_instr_i;
  input flush_i;
  input unresolved_branch_i;
  output [2**ARIANE_REG_ADDR_SIZE-1:0] rd_clobber_gpr_o;
  output [2**ARIANE_REG_ADDR_SIZE-1:0] rd_clobber_fpr_o;

  input [ARIANE_REG_ADDR_SIZE-1:0] rs1_i;
  output rs1_valid_o;

  input [ARIANE_REG_ADDR_SIZE-1:0] rs2_i;
  output rs2_valid_o;

  input [ARIANE_REG_ADDR_SIZE-1:0] decoded_instr_i;
  input decoded_instr_valid_i;

  input [1:0] commit_ack_i;

  wire [ARIANE_REG_ADDR_SIZE-1:0] rs1_i;
  assign rs1_valid_o = 1;

  wire [ARIANE_REG_ADDR_SIZE-1:0] rs2_i;
  assign rs2_valid_o = 1;

endmodule
