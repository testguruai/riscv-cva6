
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: re_name.sv
// UVM Test Bench and Test Code for re_name.sv Verilog Code
// ==============================================================================
// VerifAI TestGuru
// test for: re_name.sv

// Register Environment
class re_name_env extends uvm_env;

  // Instances
  re_name_agent re_name_agent0;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    re_name_agent0 = re_name_agent::type_id::create("re_name_agent0", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    // Agent connects to DUT
  endfunction : connect_phase

endclass : re_name_env

// Register Agent
class re_name_agent extends uvm_agent;

  // Instances
  re_name_driver re_name_driver0;
  re_name_sequencer re_name_sequencer0;

  // Constructor
  function new(string name = "re_name_agent");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    re_name_driver0 = re_name_driver::type_id::create("re_name_driver0", this);
    re_name_sequencer0 = re_name_sequencer::type_id::create("re_name_sequencer0", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    re_name_driver0.seq_item_port.connect(re_name_sequencer0.seq_item_export);
  endfunction : connect_phase

endclass : re_name_agent

// Register Driver
class re_name_driver extends uvm_driver #(re_name.transaction);

  uvm_analysis_port #(re_name_pkg) re_name_ap;
  virtual re_name_if vif;

  virtual function void build_phase(uvm_phase phase);
    // .. build code ..
  endfunction : build_phase

  virtual task drive();
    // .. drive code ..
  endtask : drive

endclass : re_name_driver

// Register Sequencer
class re_name_sequencer extends uvm_sequencer #(re_name.transaction);

  // sequence generation code

endclass : re_name_sequencer

// Register Sequence
class re_name_sequence extends uvm_sequence #(re_name.transaction);

  // sequence items generation code

endclass : re_name_sequence

// Register Transaction
class re_name_transaction extends uvm_sequence_item;

  // transaction data fields

endclass : re_name_transaction

// Register Test
class re_name_test extends uvm_test;

  // Instances
  re_name_env re_name_env0;

  // Constructor
  function new(string name = "re_name_test");
    super.new(name);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    re_name_env0 = re_name_env::type_id::create("re_name_env0", this);
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    // run code..
  endtask : run_phase

endclass : re_name_test
