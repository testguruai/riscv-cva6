
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: alu.sv
// UVM Test Bench and Test Code for alu.sv Verilog Code
// ==============================================================================
// VerifAI TestGuru
// test for: alu.sv
package alu_pkg;
  import riscv::*;
  import riscv_pkg::*;

  typedef enum bit [2:0] {
    EQ,  NE,
    SUB, SUBW,
    ANDN, ORN, XNOR
  } signal_enum_t;

  typedef struct packed {
    xlen_t operand_a;
    xlen_t operand_b;
    signal_enum_t operator;
  } fu_data_t;
endpackage : alu_pkg;

// Imports
import alu_pkg::fu_data_t;

// Stimulus generator
class alu_stimulus extends uvm_sequence_item;
  rand fu_data_t fu_data;

  constraint input_data_c {
    fu_data.operand_a inside {[0:100]};
    fu_data.operand_b inside {[0:100]};
    fu_data.operator  inside {EQ, NE, SUB};
  }

  `uvm_object_utils(alu_stimulus)

  function new(string name = "alu_stimulus");
    super.new(name);
  endfunction
endclass

// ALU driver
class alu_driver extends uvm_driver #(fu_data_t);
  riscv::xlen_t result;
  logic                  alu_branch_result;
  uvm_analysis_port #(riscv::xlen_t) result_ap;

  virtual task run_phase(uvm_phase phase);
    fu_data_t alu_data;

    forever begin
      seq_item_port.get_next_item(alu_data);
      @(posedge vif.clk_i);
      vif.fu_data_a = alu_data;
      result_ap.write(result);
      seq_item_port.item_done();
    end
  endtask
endclass

// ALU monitor
class alu_monitor extends uvm_monitor;
  uvm_analysis_port #(fu_data_t) item_collected_port;

  virtual task run_phase(uvm_phase phase);
    fu_data_t alu_data;

    forever begin
      @(negedge vif.clk_i);
      alu_data = vif.fu_data_i;
      item_collected_port.write(alu_data);
    end
  endtask
endclass

// ALU agent
class alu_agent;
  alu_driver  drv;
  alu_sequencer seqr;
  alu_monitor mon;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    phase.drop_objection(this);
  endtask
endclass

// ALU environment
class alu_env extends uvm_env;
  alu_agent alu;
  env_config cfg;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    alu = alu_agent::type_id::create("alu", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    uvm_config_db #(env_config)::get(this, "", "cfg", cfg);
    cfg.vif.xlen_o.connect(alu.drv.result_ap);
  endfunction
endclass

// Test case
class alu_test extends uvm_test;
  alu_env env;
  uvm_config_db #(virtual alu_if) alu_cfg;

  function new(string name = "alu_test");
    super.new(name);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env::type_id::create("env", this);
    if (!uvm_config_db #(virtual alu_if)::get(this, "", "alu_if", alu_cfg)) begin
      `uvm_fatal(get_type_name(), "Did not get alu_if instance from the config_db");
    end
    raise_objection(phase);
  endfunction

  task main_phase(uvm_phase phase);
    phase.drop_objection(this);
  endtask
endclass
