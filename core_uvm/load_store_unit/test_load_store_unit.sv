
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: load_store_unit.sv
// UVM Test Bench and Test Code for load_store_unit.sv Verilog Code
// ==============================================================================
// UVM Test
class load_store_test extends uvm_test;
  `uvm_component_utils(load_store_test)

  load_store_env load_store_env0;

  function new(string name = "load_store_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    load_store_env0 = load_store_env::type_id::create("load_store_env0", this);
  endfunction

  function void run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #100; // Wait for 100 time units to ensure functionality of DUT
    phase.drop_objection(this);
  endfunction

endclass : load_store_test

// UVM Environment and UVM Agent

class load_store_env extends uvm_env;
  `uvm_component_utils(load_store_env)

  load_store_agent load_store_agent0;

  function new(string name = "load_store_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    load_store_agent0 = load_store_agent::type_id::create("load_store_agent0", this);
  endfunction

endclass : load_store_env

class load_store_agent extends uvm_agent;
  `uvm_component_utils(load_store_agent)

  load_store_sequencer load_store_sequencer0;
  load_store_driver load_store_driver0;

  function new(string name = "load_store_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    load_store_sequencer0 = load_store_sequencer::type_id::create("load_store_sequencer0", this);
    load_store_driver0 = load_store_driver::type_id::create("load_store_driver0", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    load_store_driver0.seq_item_port.connect(load_store_sequencer0.seq_item_export);
  endfunction

endclass : load_store_agent

// UVM Sequencer, UVM Driver, and UVM Monitor

class load_store_sequencer extends uvm_sequencer #(load_store_transaction);
  `uvm_component_utils(load_store_sequencer)

  function new(string name = "load_store_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass : load_store_sequencer

class load_store_driver extends uvm_driver #(load_store_transaction);
  `uvm_component_utils(load_store_driver)

  uvm_analysis_port #(load_store_transaction) ap;

  function new(string name = "load_store_driver", uvm_component parent=null);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  task run_phase(uvm_phase phase);
    load_store_transaction load_store_transaction0;

    forever begin
      seq_item_port.get_next_item(load_store_transaction0);
      #100; // Time for driver to act on DUT based on sequencer transaction
      ap.write(load_store_transaction0); // Write to monitor's analysis port
      seq_item_port.item_done();
    end
  endtask

endclass : load_store_driver

class load_store_monitor extends uvm_monitor;
  `uvm_component_utils(load_store_monitor)

  uvm_analysis_imp #(load_store_transaction, load_store_monitor) imp;

  function new(string name = "load_store_monitor", uvm_component parent=null);
    super.new(name, parent);
    imp = new("imp", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    load_store_transaction load_store_transaction0 = load_store_transaction::type_id::create("load_store_transaction0");

    forever begin
      #(100); // Wait until DUT has changed state
      // Check state of DUT and adjust transaction as necessary
      imp.write(load_store_transaction0); // Write to collector's analysis port
    end
  endtask

endclass : load_store_monitor
