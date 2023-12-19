
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: amo_buffer.sv
// UVM Test Bench and Test Code for amo_buffer.sv Verilog Code
// ==============================================================================
// Be sure to include UVM package
import uvm_pkg::*;

// Define the AMO model
class amo_model extends uvm_sequence_item;
  `uvm_object_utils(amo_model)

  // The properties will mimic the input and output signals of your `amo_buffer` module
  bit valid;
  ariane_pkg::amo_t amo_op;
  logic [riscv::PLEN-1:0] paddr;
  // Add all other parameters as needed...

  function void display(string name);
    // Add your display function definition
  endfunction

  function new(string name = "");
    super.new(name);
  endfunction
endclass

// Define the Driver
class amo_driver extends uvm_driver #(amo_model);
  `uvm_component_utils(amo_driver)
  virtual amo_buffer vif;
  function new(string name, uvm_component parent = null);
    super.new(name,parent);
  endfunction
  task drive();
    // Add your code to drive the inputs to the `amo_buffer` module
  endtask
endclass

// Define the Monitor
class amo_monitor extends uvm_monitor #(amo_model);
  `uvm_component_utils(amo_monitor)
  virtual amo_buffer vif;
  function new(string name, uvm_component parent = null);
    super.new(name,parent);
  endfunction
  task monitor();
    // Add your code to monitor the output of the `amo_buffer` module
  endtask
endclass

// Define the Environment
class amo_env extends uvm_env;
  `uvm_component_utils(amo_env)
  amo_driver amo_d;
  amo_monitor amo_m;
  function new(string name, uvm_component parent = null);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    // Create driver and monitor objects here
  endfunction
endclass

// Define the Test
class amo_test extends uvm_test;
  `uvm_component_utils(amo_test)
  amo_env env;
  function new(string name, uvm_component parent = null);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    // Create environment object here
  endfunction
  task run_phase(uvm_phase phase);
    // Define your test procedure and sequences here
  endtask
endclass
