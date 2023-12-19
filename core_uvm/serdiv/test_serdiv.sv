
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: serdiv.sv
// UVM Test Bench and Test Code for serdiv.sv Verilog Code
// ==============================================================================
// VerifAI TestGuru
// test for: serdiv.sv
import ariane_pkg::*;

//Create the Interface for serdiv module
interface tb_serdiv_if #(parameter WIDTH = 64);
  logic  clk_i;
  logic  rst_ni;
  logic [WIDTH-1:0]  id_i;
  logic [WIDTH-1:0]  op_a_i;
  logic [WIDTH-1:0]  op_b_i;
  logic [1:0]        opcode_i; 
  logic  in_vld_i;
  logic  in_rdy_o;
  logic  flush_i;
  logic  out_vld_o;
  logic  out_rdy_i;
  logic [WIDTH-1:0]  id_o;
  logic [WIDTH-1:0]  res_o;
  
  task automatic set_reset(logic val);
    rst_ni = val;
  endtask

  task automatic set_flush(logic val);
    flush_i = val;
  endtask

  task automatic set_op_a_i(logic [WIDTH-1:0] val);
    op_a_i = val;
  endtask

  task automatic set_op_b_i(logic [WIDTH-1:0] val);
    op_b_i = val;
  endtask

  task automatic set_opcode_i(logic [1:0] val);
    opcode_i = val;
  endtask

  task automatic set_out_rdy_i(logic val);
    out_rdy_i = val;
  endtask

  task automatic set_in_vld_i(logic val);
    in_vld_i = val;
  endtask
endinterface 

//DUT serdiv instantiation connecting with tb_serdiv_if
module tb_serdiv #(parameter CLK_PERIOD = 2, NB_CYCLES = 100);
  timeunit 1ns;
	timeprecision 1ns;

	tb_serdiv_if #(64) tb_if();
	initial tb_if.clk_i = 0;

	serdiv dut (
		.clk_i(tb_if.clk_i),
		.rst_ni(tb_if.rst_ni),
		.id_i(tb_if.id_i),
		.op_a_i(tb_if.op_a_i),
		.op_b_i(tb_if.op_b_i),
		.opcode_i(tb_if.opcode_i), 
		.in_vld_i(tb_if.in_vld_i),
		.in_rdy_o(tb_if.in_rdy_o),
		.flush_i(tb_if.flush_i),
		.out_vld_o(tb_if.out_vld_o),
		.out_rdy_i(tb_if.out_rdy_i),
		.id_o(tb_if.id_o),
		.res_o(tb_if.res_o)
	);

  // Rest of your code
endmodule
