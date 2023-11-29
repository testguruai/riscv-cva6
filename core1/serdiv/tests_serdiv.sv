// VerifAI TestGuru
// tests for: serdiv.sv

module testbench;

  import serdiv_pkg::*; // Import the appropriate package for the serdiv module.

  parameter WIDTH = 64;

  // DUT
  serdiv #(WIDTH) dut(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .id_i(id_i),
    .op_a_i(op_a_i),
    .op_b_i(op_b_i),
    .opcode_i(opcode_i),
    .in_vld_i(in_vld_i),
    .in_rdy_o(in_rdy_o),
    .flush_i(flush_i),
    .out_vld_o(out_vld_o),
    .out_rdy_i(out_rdy_i),
    .id_o(id_o),
    .res_o(res_o)
  );

  // testbench
  bit clk_i; // Replace 'logic' with 'bit' for the clk_i and rst_ni signals.
  bit rst_ni;
  bit id_i;
  bit op_a_i;
  bit op_b_i;
  bit opcode_i;
  bit in_vld_i;
  bit in_rdy_o;
  bit flush_i;
  bit out_vld_o;
  bit out_rdy_i;
  bit id_o;
  bit res_o;

  initial begin
    // initialize
    clk_i = 0;
    rst_ni = 1;
    id_i = 0;
    op_a_i = 0;
    op_b_i = 0;
    opcode_i = 0;
    in_vld_i = 0;
    in_rdy_o = 0;
    flush_i = 0;
    out_vld_o = 0;
    out_rdy_i = 0;
    id_o = 0;
    res_o = 0;

    #10;
    rst_ni = 0;

    #10;
    id_i = 1;
    op_a_i = 5; // Change the values assigned to op_a_i and op_b_i to match the expected results.
    op_b_i = 10;
    opcode_i = 0;
    in_vld_i = 1;

    #10;
    in_vld_i = 0;

    #10;
    out_vld_o = 1;

    #10;
    out_vld_o = 0;

    #10;
    id_i = 2;
    op_a_i = 5; // Change the values assigned to op_a_i and op_b_i to match the expected results.
    op_b_i = 10;
    opcode_i = 1;
    in_vld_i = 1;

    #10;
    in_vld_i = 0;

    #10;
    out_vld_o = 1;

    #10;
    out_vld_o = 0;

    #10;
    id_i = 3;
    op_a_i = 5; // Change the values assigned to op_a_i and op_b_i to match the expected results.
    op_b_i = 10;
    opcode_i = 2;
    in_vld_i = 1;

    #10;
    in_vld_i = 0;

    #10;
    out_vld_o = 1;

    #10;
    out_vld_o = 0;

    #10;
    id_i = 4;
    op_a_i = 5; // Change the values assigned to op_a_i and op_b_i to match the expected results.
    op_b_i = 10;
    opcode_i = 3;
    in_vld_i = 1;

    #10;
    in_vld_i = 0;

    #10;
    out_vld_o = 1;

    #10;
    out_vld_o = 0;

    #10;
    id_i = 5;
    op_a_i = 5; // Change the values assigned to op_a_i and op_b_i to match the expected results.
    op_b_i = 10;
    opcode_i = 4;
    in_vld_i = 1;

    #10;
    in_vld_i = 0;

    #10;
    out_vld_o = 1;

    #10;
    out_vld_o = 0;

    #10;
    id_i = 6; // Add semicolon after each out_vld_o assignment.
    op_a_i = 5; // Change the values assigned to op_a_i, op_b_i, opcode_i, and in_vld_i to match the expected results.
    op_b_i = 10;
    opcode_i = 5;
    in_vld_i = 1;

    #10;
    in_vld_i = 0;

    #10;
    out_vld_o = 1;

    #10;
    out_vld_o = 0;

    #10;
    id_i = 7;
    op_a_i = 5; // Change the values assigned to op_a_i and op_b_i to match the expected results.
    op_b_i = 10;
    opcode_i = 6;
    in_vld_i = 1;

    #10;
    in_vld_i = 0;

    #10;
    out_vld_o = 1;

    #10;
    out_vld_o = 0;

    #10;
    id_i = 8;
    op_a_i = 5; // Change the values assigned to op_a_i and op_b_i to match the expected results.
    op_b_i = 10;
    opcode_i = 7;
    in_vld_i = 1;

    #10;
    in_vld_i = 0;

    #10;
    out_vld_o = 1;

    #10;
    out_vld_o = 0;

    #10;
    $finish; // Remove the dot (.) before the 'finish' statement.
  end
endmodule
