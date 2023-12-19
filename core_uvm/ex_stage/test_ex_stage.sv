
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: ex_stage.sv
// UVM Test Bench and Test Code for ex_stage.sv Verilog Code
// ==============================================================================
`timescale 1ns / 1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

class ex_stage_transaction extends uvm_sequence_item;
  logic flush_i;
  logic debug_mode_i;

  `uvm_object_utils(ex_stage_transaction)

  function new (string name="ex_stage_transaction");
    super.new(name);
  endfunction : new
endclass : ex_stage_transaction

class ex_stage_agent extends uvm_agent;
  `uvm_component_utils(ex_stage_agent)

  virtual task run_phase(uvm_phase phase);
  endtask
endclass : ex_stage_agent

class ex_stage_env extends uvm_env;
  ex_stage_agent ex_stage_agent0;
  `uvm_component_utils(ex_stage_env)

  function new(string name="ex_stage_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    ex_stage_agent0 = ex_stage_agent::type_id::create("ex_stage_agent0", this);
  endfunction : build_phase
endclass : ex_stage_env

class ex_stage_test extends uvm_test;
  ex_stage_env ex_stage_env0;
  `uvm_component_utils(ex_stage_test)

  function new(string name="ex_stage_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    ex_stage_env0 = ex_stage_env::type_id::create("ex_stage_env0", this);
  endfunction : build_phase
endclass : ex_stage_test

module testbench;
  import ariane_pkg::*;
  reg clk_i;
  reg rst_ni;

  initial begin
    uvm_config_db#(uvm_bitstream_t)::set(null, "uvm_test_top", "recording_detail", UVM_HIGH);
    run_test("ex_stage_test");
  end
endmodule
