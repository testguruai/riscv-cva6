
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: instr_realign.sv
// UVM Test Bench and Test Code for instr_realign.sv Verilog Code
// ==============================================================================
// Transaction Class
class instr_realign_transaction extends uvm_sequence_item;
  bit valid_i;
  bit [31:0] data_i;
  
  // Constructor 
  function new(string name = "instr_realign_transaction");
    super.new(name);
  endfunction

  // Print Function  
  function void do_print (uvm_printer printer);
    printer.print_field("valid", valid_i);
    printer.print_field("data", data_i);
  endfunction
endclass

// Sequencer Class
class instr_realign_sequencer extends uvm_sequencer #(instr_realign_transaction);
endclass

// Driver Class
class instr_realign_driver extends uvm_driver #(instr_realign_transaction);
  virtual instr_realign_agent.vif vif;

  // Driving Task 
  task run_phase(uvm_phase phase);
    forever begin
      instr_realign_transaction tr;
      seq_item_port.get_next_item(tr);
      vif.valid_i <= tr.valid_i;
      vif.data_i <= tr.data_i;
      seq_item_port.item_done();
    end
  endtask
endclass

// Interface
interface instr_realign_intf;
  logic valid_i;
  logic [31:0] data_i;
endinterface

// Agent Class
class instr_realign_agent extends uvm_agent;
  instr_realign_sequencer sequencer;
  instr_realign_driver    driver;
  virtual instr_realign_intf vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer = instr_realign_sequencer::type_id::create("sequencer", this);
    driver    = instr_realign_driver::type_id::create("driver", this);  
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction 
endclass

// Environment Class
class instr_realign_env extends uvm_env;
  instr_realign_agent agent;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = instr_realign_agent::type_id::create("agent", this);
  endfunction
endclass

// Test Class
class instr_realign_test extends uvm_test;
  instr_realign_env env;
  
  function new(string name = "instr_realign_test");
    super.new(name);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = instr_realign_env::type_id::create("env", this);
  endfunction
endclass

// Testbench Top
module tb_top;
  instr_realign_intf vif();
  instr_realign_env  env;

  initial begin
    uvm_config_db #(instr_realign_intf)::set(null, "*.agent.vif", "vif", vif);
    run_test("instr_realign_test");
  end
endmodule
