// VerifAI TestGuru
// tests for: mult.sv
systemverilog
module test_mult;

  typedef struct packed {
    riscv::xlen_t operator;
    riscv::xlen_t operand_a;
    riscv::xlen_t operand_b;
    riscv::xlen_t trans_id;
  } fu_data_t;

  logic clk_i = 0;
  logic rst_ni = 0;
  logic flush_i = 0;
  fu_data_t fu_data_i;
  logic mult_valid_i;
  reg [riscv::TRANS_ID_BITS-1:0] mult_trans_id_o = 0;

  riscv::xlen_t result_o;
  logic mult_valid_o = 0;
  logic mult_ready_o = 0;

  mult mult_inst (
    .clk_i (clk_i),
    .rst_ni (rst_ni),
    .flush_i (flush_i),
    .fu_data_i (fu_data_i),
    .mult_valid_i (mult_valid_i),
    .result_o (result_o),
    .mult_valid_o (mult_valid_o),
    .mult_ready_o (mult_ready_o),
    .mult_trans_id_o (mult_trans_id_o)
  );

  initial begin
    #10;
    // Test multiplication
    fu_data_i.operator <= MUL;
    fu_data_i.operand_a <= 5;
    fu_data_i.operand_b <= 3;
    fu_data_i.trans_id <= 1;
    mult_valid_i = 1;
    @(posedge clk_i);
    mult_valid_i = 0;
    @(posedge clk_i);
    $display("Multiplication Result: %0d", result_o);
    $display("Multiplication Valid: %0d", mult_valid_o);
    $display("Multiplication Ready: %0d", mult_ready_o);
    $display("Multiplication Trans ID: %0d", mult_trans_id_o);

    // Test division
    fu_data_i.operator <= DIV;
    fu_data_i.operand_a <= 10;
    fu_data_i.operand_b <= 2;
    fu_data_i.trans_id <= 2;
    mult_valid_i = 1;
    @(posedge clk_i);
    mult_valid_i = 0;
    @(posedge clk_i);
    $display("Division Result: %0d", result_o);
    $display("Division Valid: %0d", mult_valid_o);
    $display("Division Ready: %0d", mult_ready_o);
    $display("Division Trans ID: %0d", mult_trans_id_o);
  end

endmodule
