# VerifAI TestGuru
# tests for: serdiv.sv
```
// Testbench for serdiv

module tb_serdiv;

  // parameters
  parameter WIDTH = 64;

  // inputs
  logic clk_i;
  logic rst_ni;
  logic [TRANS_ID_BITS-1:0] id_i;
  logic [WIDTH-1:0] op_a_i;
  logic [WIDTH-1:0] op_b_i;
  logic [1:0] opcode_i; // 0: udiv, 2: urem, 1: div, 3: rem
  logic in_vld_i;
  logic flush_i;

  // outputs
  logic out_vld_o;
  logic out_rdy_i;
  logic [TRANS_ID_BITS-1:0] id_o;
  logic [WIDTH-1:0] res_o;

  // instantiate DUT
  serdiv #(
    .WIDTH(WIDTH)
  ) dut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .id_i(id_i),
    .op_a_i(op_a_i),
    .op_b_i(op_b_i),
    .opcode_i(opcode_i),
    .in_vld_i(in_vld_i),
    .out_vld_o(out_vld_o),
    .out_rdy_i(out_rdy_i),
    .id_o(id_o),
    .res_o(res_o)
  );

  // testbench
  initial begin
    // reset
    clk_i = 0;
    rst_ni = 1;
    #10;
    rst_ni = 0;

    // generate test vectors
    // div
    id_i = 1;
    op_a_i = 10;
    op_b_i = 2;
    opcode_i = 1;
    in_vld_i = 1;
    #10;
    in_vld_i = 0;
    #10;
    expect(out_vld_o, 1);
    expect(out_rdy_i, 1);
    expect(id_o, 1);
    expect(res_o, 5);

    // rem
    id_i = 2;
    op_a_i = 10;
    op_b_i = 2;
    opcode_i = 3;
    in_vld_i = 1;
    #10;
    in_vld_i = 0;
    #10;
    expect(out_vld_o, 1);
    expect(out_rdy_i, 1);
    expect(id_o, 2);
    expect(res_o, 0);

    // flush
    flush_i = 1;
    #10;
    flush_i = 0;

    // div
    id_i = 3;
    op_a_i = 10;
    op_b_i = 2;
    opcode_i = 1;
    in_vld_i = 1;
    #10;
    in_vld_i = 0;
    #10;
    expect(out_vld_o, 1);
    expect(out_rdy_i, 1);
    expect(id_o, 3);
    expect(res_o, 5);

    // urem
    id_i = 4;
    op_a_i = 10;
    op_b_i = 2;
    opcode_i = 2;
    in_vld_i = 1;
    #10;
    in_vld_i = 0;
    #10;
    expect(out_v