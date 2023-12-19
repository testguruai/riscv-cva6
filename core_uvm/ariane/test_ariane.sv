
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: ariane.sv
// UVM Test Bench and Test Code for ariane.sv Verilog Code
// ==============================================================================
`timescale 1ns / 1ps
`include "uvm_macros.svh"

// package
package tb_pkg;

  import uvm_pkg::*;
  `include "ariane_pkg.sv"

endpackage

// agent
class ariane_agent extends uvm_agent;

  `uvm_component_utils(ariane_agent)

  ariane_driver drv;
  ariane_sequencer seqr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction 

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = ariane_driver::type_id::create("drv", this);
    seqr = ariane_sequencer::type_id::create("seqr", this);
  endfunction 

endclass 

// driver
class ariane_driver extends uvm_driver #(ArianeItem);

  `uvm_component_utils(ariane_driver)

  uvm_analysis_port #(ArianeItem) item_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_port = new("item_port", this);
  endfunction 

  virtual task run_phase(uvm_phase phase);
    ArianeItem req;
    forever begin
      seq_item_port.get_next_item(req);
      // driving logic to be added here
      seq_item_port.item_done(req);
    end
  endtask 

endclass 

// item
class ArianeItem extends uvm_sequence_item;

  `uvm_object_utils(ArianeItem)

  // item properties to be added here

  function new(string name = "");
    super.new(name);
  endfunction 

endclass 

// test
class ariane_test extends uvm_test;

  `uvm_component_utils(ariane_test)

  ariane_agent agt;

  function new(string name = "ariane_test");
    super.new(name);
  endfunction 

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = ariane_agent::type_id::create("agt", this);
  endfunction 

endclass

// initial block to run the test
initial begin
    run_test("ariane_test");
end
