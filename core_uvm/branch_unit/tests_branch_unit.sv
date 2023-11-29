// VerifAI TestGuru
// tests for: branch_unit.sv
`ifdef UVM_INCLUDE
`include "uvm_macros.svh"
`endif

module branch_unit_tb;

  // Define signals for connecting to the DUT
  logic clk_i;
  logic rst_ni;
  logic debug_mode_i;
  logic [riscv::VLEN-1:0] pc_i;
  logic is_compressed_instr_i;
  logic fu_valid_i;
  logic branch_valid_i;
  logic branch_comp_res_i;
  logic [riscv::VLEN-1:0] branch_result_o;
  ariane_pkg::branchpredict_sbe_t branch_predict_i;
  ariane_pkg::bp_resolve_t resolved_branch_o;
  logic resolve_branch_o;
  ariane_pkg::exception_t branch_exception_o;

  // Instantiate the DUT
  branch_unit dut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .debug_mode_i(debug_mode_i),
    .fu_data_i(fu_data_i),
    .pc_i(pc_i),
    .is_compressed_instr_i(is_compressed_instr_i),
    .fu_valid_i(fu_valid_i),
    .branch_valid_i(branch_valid_i),
    .branch_comp_res_i(branch_comp_res_i),
    .branch_result_o(branch_result_o),
    .branch_predict_i(branch_predict_i),
    .resolved_branch_o(resolved_branch_o),
    .resolve_branch_o(resolve_branch_o),
    .branch_exception_o(branch_exception_o)
  );

  // Define input and output variables
  logic [riscv::VLEN-1:0] target_address;
  logic [riscv::VLEN-1:0] next_pc;
  ariane_pkg::fu_data_t fu_data_i;

  // Define and initialize test variables
  logic test_passed;
  int num_tests = 2;
  int current_test = 1;

  // Default values for input signals
  assign clk_i = 0;
  assign rst_ni = 0;
  assign debug_mode_i = 0;
  assign fu_data_i = '0;
  assign pc_i = '0;
  assign is_compressed_instr_i = 0;
  assign fu_valid_i = 0;
  assign branch_valid_i = 0;
  assign branch_comp_res_i = 0;
  assign branch_predict_i = '0;
  assign resolved_branch_o = '0;
  assign resolve_branch_o = 0;
  assign branch_exception_o = '0;

  // Stimulus
  always begin
    #5;
    clk_i = ~clk_i;
  end

  initial begin
    #10;
    rst_ni = 1;
    @(posedge clk_i);
    rst_ni = 0;
    @(posedge clk_i);
    rst_ni = 1;
    @(posedge clk_i);

    // Test 1: Check default values
    if (target_address === 0 && next_pc === 0 && branch_result_o === 0 &&
      resolved_branch_o.target_address === 0 && resolved_branch_o.is_taken === 0 &&
      resolved_branch_o.valid === 0 && resolved_branch_o.is_mispredict === 0 &&
      resolved_branch_o.cf_type === 0 && resolved_branch_o.pc === 0 &&
      branch_exception_o.cause === 0 && branch_exception_o.valid === 0 &&
      branch_exception_o.tval === 0 && resolve_branch_o === 0) begin
      $display("Test 1 passed");
    end else begin
      $display("Test 1 failed");
      test_passed = 0;
    end

    // Test 2: Set inputs and verify outputs
    fu_data_i.operator = ariane_pkg::JALR;
    fu_data_i.operand_a = '0;
    pc_i = 8'hFF;
    is_compressed_instr_i = 1;
    fu_valid_i = 1;
    branch_valid_i = 1;
    branch_comp_res_i = 1;
    branch_predict_i.cf = ariane_pkg::Branch;
    branch_predict_i.predict_address = 8'hFF;
    target_address = 0;
    next_pc = 0;
    resolved_branch_o.target_address = 0;
    resolved_branch_o.is_taken = 0;
    resolved_branch_o.valid = 0;
    resolved_branch_o.is_mispredict = 0;
    resolved_branch_o.cf_type = 0;
    resolved_branch_o.pc = 0;
    branch_result_o = 0;
    resolve_branch_o = 0;
    @(posedge clk_i);
    if (target_address === 0 && next_pc === 0 && branch_result_o === 8'hFF &&
      resolved_branch_o.target_address === 8'hFF && resolved_branch_o.is_taken === 1 &&
      resolved_branch_o.valid === 1 && resolved_branch_o.is_mispredict === 0 &&
      resolved_branch_o.cf_type === ariane_pkg::Branch && resolved_branch_o.pc === 8'hFF &&
      branch_exception_o.cause === 0 && branch_exception_o.valid === 0 && branch_exception_o.tval === 0 &&
      resolve_branch_o === 1) begin
      $display("Test 2 passed");
    end else begin
      $display("Test 2 failed");
      test_passed = 0;
    end

    if (test_passed) begin
      $display("All tests passed");
    end else begin
      $display("Some tests failed");
    end

    #5;
    $finish;
  end

endmodule
