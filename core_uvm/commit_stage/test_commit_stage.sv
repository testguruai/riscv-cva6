
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: commit_stage.sv
// UVM Test Bench and Test Code for commit_stage.sv Verilog Code
// ==============================================================================
// Driver
class commit_stage_driver extends uvm_driver #(commit_stage_request, commit_stage_response);
  uvm_analysis_port #(commit_stage_request) request_port;
  uvm_analysis_port #(commit_stage_response) analysis_port;
  
  virtual task run_phase(uvm_phase phase);
    // code for driver goes here
  endtask
  
endclass 

// Monitor

class commit_stage_monitor extends uvm_monitor;
  uvm_analysis_port #(commit_stage_request) request_ap;
  uvm_analysis_port #(commit_stage_response) response_ap;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // code for monitor goes here
  endfunction
  
endclass
class commit_stage_agent extends uvm_agent;
  commit_stage_sequencer sequencer;
  commit_stage_driver driver;
  commit_stage_monitor monitor;
  
  uvm_analysis_port #(commit_stage_request) request_ap;
  uvm_analysis_port #(commit_stage_response) response_ap;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = commit_stage_driver::type_id::create("driver", this);
    sequencer = commit_stage_sequencer::type_id::create("sequencer", this);
    monitor = commit_stage_monitor::type_id::create("monitor", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

  function void run_phase(uvm_phase phase);
    // start sequences here
  endfunction
  
endclass
