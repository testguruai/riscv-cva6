# VerifAI TestGuru
# tests for: issue_read_operands.sv
Sure, here is the testbench for your code:

```
module issue_read_operands_tb;

    logic clk;
    logic rst_ni;
    logic flush_i;
    logic issue_instr_i;
    logic issue_instr_valid_i;
    logic issue_ack_o;
    logic [REG_ADDR_SIZE-1:0] rs1_o;
    logic [REG_ADDR_SIZE-1:0] rs2_o;
    logic [REG_ADDR_SIZE-1:0] rs3_o;
    logic [riscv::XLEN-1:0] rs1_i;
    logic [riscv::XLEN-1:0] rs2_i;
    logic [riscv::XLEN-1:0] rs3_i;
    logic [2**REG_ADDR_SIZE-1:0] rd_clobber_gpr_i;
    logic [2**REG_ADDR_SIZE-1:0] rd_clobber_fpr_i;
    logic [riscv::XLEN-1:0] fu_data_o;
    logic fu_valid_o;
    logic branch_valid_o;
    logic lsu_valid_o;
    logic mult_valid_o;
    logic fpu_valid_o;
    logic [1:0] fpu_fmt_o;
    logic [2:0] fpu_rm_o;
    logic csr_valid_o;
    logic cvxif_valid_o;
    logic [31:0] cvxif_off_instr_o;
    logic [NR_COMMIT_PORTS-1:0][4:0] waddr_i;
    logic [NR_COMMIT_PORTS-1:0][riscv::XLEN-1:0] wdata_i;
    logic [NR_COMMIT_PORTS-1:0] we_gpr_i;
    logic [NR_COMMIT_PORTS-1:0] we_fpr_i;

    issue_read_operands #(
        .NR_RGPR_PORTS(2)
    ) uut(
        .clk(clk),
        .rst_ni(rst_ni),
        .flush_i(flush_i),
        .issue_instr_i(issue_instr_i),
        .issue_instr_valid_i(issue_instr_valid_i),
        .issue_ack_o(issue_ack_o),
        .rs1_o(rs1_o),
        .rs2_o(rs2_o),
        .rs3_o(rs3_o),
        .rs1_i(rs1_i),
        .rs2_i(rs2_i),
        .rs3_i(rs3_i),
        .rd_clobber_gpr_i(rd_clobber_gpr_i),
        .rd_clobber_fpr_i(rd_clobber_fpr_i),
        .fu_data_o(fu_data_o),
        .fu_valid_o(fu_valid_o),
        .branch_valid_o(branch_valid_o),
        .lsu_valid_o(lsu_valid_o),
        .mult_valid_o(mult_valid_o),
        .fpu_valid_o(fpu_valid_o),
        .fpu_fmt_o(fpu_fmt_o),
        .fpu_rm_o(fpu_rm_o),
        .csr_valid_o(csr_valid_o),
        .cvxif_valid_o(cvxif_valid_o),
        .cvxif_off_instr_o(cvxif_off_instr_o),
        .waddr_i(waddr_i),
        .wdata_i(wdata_i),
        .we_gpr_i(we_gpr_i),
        .we_fpr_i(we_fpr_i)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end