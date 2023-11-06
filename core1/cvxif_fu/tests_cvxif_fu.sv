# VerifAI TestGuru
# tests for: cvxif_fu.sv
```
// Testbench for cvxif_fu

module cvxif_fu_tb;

  // Inputs
  logic clk_i;
  logic rst_ni;
  logic fu_data_i;
  logic x_valid_i;
  logic x_ready_o;
  logic [31:0] x_off_instr_i;

  // Outputs
  logic [TRANS_ID_BITS-1:0] x_trans_id_o;
  exception_t x_exception_o;
  riscv::xlen_t x_result_o;
  logic x_valid_o;
  logic x_we_o;
  logic cvxif_req_o;
  logic cvxif_resp_i;

  // Instantiate the Unit Under Test (UUT)
  cvxif_fu #(
    .X_NUM_RS(X_NUM_RS)
  ) uut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .fu_data_i(fu_data_i),
    .x_valid_i(x_valid_i),
    .x_ready_o(x_ready_o),
    .x_off_instr_i(x_off_instr_i),
    .x_trans_id_o(x_trans_id_o),
    .x_exception_o(x_exception_o),
    .x_result_o(x_result_o),
    .x_valid_o(x_valid_o),
    .x_we_o(x_we_o),
    .cvxif_req_o(cvxif_req_o),
    .cvxif_resp_i(cvxif_resp_i)
  );

  // Test vectors
  // 1. Valid instruction
  initial begin
    clk_i = 0;
    rst_ni = 1;
    #10;
    rst_ni = 0;
    #10;
    fu_data_i = 1;
    x_valid_i = 1;
    x_off_instr_i = 32'h12345678;
    #10;
    assert(x_valid_o == 1);
    assert(x_trans_id_o == 1);
    assert(x_result_o == 32'h12345678);
    assert(x_exception_o.valid == 0);
    assert(x_exception_o.cause == 0);
    assert(x_exception_o.tval == 0);
    assert(x_we_o == 0);
  end

  // 2. Illegal instruction
  initial begin
    clk_i = 0;
    rst_ni = 1;
    #10;
    rst_ni = 0;
    #10;
    fu_data_i = 1;
    x_valid_i = 1;
    x_off_instr_i = 32'hdeadbeef;
    #10;
    assert(x_valid_o == 1);
    assert(x_trans_id_o == 1);
    assert(x_result_o == 0);
    assert(x_exception_o.valid == 1);
    assert(x_exception_o.cause == riscv::ILLEGAL_INSTR);
    assert(x_exception_o.tval == 32'hdeadbeef);
    assert(x_we_o == 0);
  end

endmodule
```