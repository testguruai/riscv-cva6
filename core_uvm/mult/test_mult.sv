
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: mult.sv
// UVM Test Bench and Test Code for mult.sv Verilog Code
// ==============================================================================
class mult_valid_in_sequence extends uvm_sequence #(mult_valid_in_transaction);
  `uvm_object_utils(mult_valid_in_sequence)
  
  function new(string name = "mult_valid_in_sequence");
    super.new(name);
  endfunction : new

  task body();
    mult_valid_in_transaction trans;
    
    `uvm_do_with(trans, {trans.data == randomize();})
  endtask : body
endclass : mult_valid_in_sequence

class mult_valid_in_driver extends uvm_driver #(mult_valid_in_transaction);
  `uvm_component_utils(mult_valid_in_driver)
  
  virtual mult_valid_in_agent vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      vif.transport(req);
      seq_item_port.item_done();
    end
  endtask : run_phase
endclass : mult_valid_in_driver

class mult_valid_in_agent extends uvm_agent;  
  `uvm_component_utils(mult_valid_in_agent)

  mult_valid_in_driver mdrv;  
  uvm_sequencer #(mult_valid_in_transaction) seqr;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    mdrv = mult_valid_in_driver::type_id::create("mdrv", this);
    seqr = uvm_sequencer#(mult_valid_in_transaction)::type_id::create("seqr", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    mdrv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass

class mult_env extends uvm_env;
  `uvm_component_utils(mult_env)

  mult_valid_in_agent mvalid_agent;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    mvalid_agent = mult_valid_in_agent::type_id::create("mvalid_agent", this);
  endfunction
endclass

class mult_test extends uvm_test;
  `uvm_component_utils(mult_test)

  mult_env m_env;  

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);  
    m_env = mult_env::type_id::create("m_env", this);
  endfunction
  
  function void run_phase(uvm_phase phase);
    mult_valid_in_sequence seq = mult_valid_in_sequence::type_id::create("seq");
    fork 
      seq.start(p_env.mvalid_agent.sequencer);
    join 
  endfunction
endclass

// Remove `endif, there is no corresponding `ifdef to match 
// `endif
