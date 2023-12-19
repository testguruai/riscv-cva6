
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: lsu_bypass.sv
// UVM Test Bench and Test Code for lsu_bypass.sv Verilog Code
// ==============================================================================
// Begin the class definition
class test_bench_top extends uvm_env;
  
  // Instances of driver, agent, sequencer, etc.
  my_driver m_drv;
  my_agent m_agt;
  my_sequencer m_seq;
  // ...
endclass
  
// Begin the class definition: driver
class my_driver extends uvm_driver;
  // ...
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req); 
      // Here perform the driving of signals using the information in the req
      seq_item_port.item_done(); 
    end
  endtask  
endclass

// Begin the class definition: agent
class my_agent extends uvm_agent;
  // ...
endclass
  
// Begin the class definition: sequencer
class my_sequencer extends uvm_sequencer;
  // ...
endclass
  
// Begin the class definition: test
class my_test extends uvm_test;
  // ...
  task main_phase(uvm_phase phase);
    // Here you start sequences and other stimuli
  endtask
endclass
 
// Begin the class definition
class my_component extends uvm_component;
  // ...
endclass
  
// Begin the class definition : sequence
class my_sequence extends uvm_sequence;
  // ...
  task body();
    // Here you define the sequence of events
  endtask
endclass
