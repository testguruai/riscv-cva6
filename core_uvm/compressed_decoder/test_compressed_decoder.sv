
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: compressed_decoder.sv
// UVM Test Bench and Test Code for compressed_decoder.sv Verilog Code
// ==============================================================================

class decoder_seq extends uvm_sequence #(logic[31:0]);
  `uvm_object_utils(decoder_seq);
  
  logic[31:0] instr;

  function new(string name="decoder_seq");
    super.new(name);
  endfunction

  task body();
    uvm_do_on(item, p_sequencer.instr_q);
  endtask
endclass

class decoder_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(decoder_scoreboard);

  `uvm_tlm_analysis_fifo_imp_decl(_instr_item);

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void write_instr_item(uvm_transaction t);
    // Code to check the properties of the transaction
  endfunction
endclass

class decoder_driver extends uvm_driver #(logic[31:0]);
  `uvm_component_utils(decoder_driver);

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task reset();
    // Code to reset
  endtask

  virtual task get_and_drive();
    fork
      forever
      begin
        seq_item_port.get_next_item(instr);
        // Code to apply stimulus
      end
    join
  endtask
endclass

class decoder_agent extends uvm_agent;
  `uvm_component_utils(decoder_agent);
  
  decoder_driver m_drvr;
  decoder_seq    m_seq;
  uvm_sequencer #(logic[31:0]) m_sqr;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    m_sqr  = uvm_sequencer #(logic[31:0])::type_id::create("m_sqr", ,get_full_name());
    m_drvr = decoder_driver::type_id::create("m_drvr", ,get_full_name());
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    m_drvr.seq_item_port.connect(m_sqr.seq_item_export);
  endfunction
endclass

class decoder_test extends uvm_test;
  `uvm_component_utils(decoder_test);
  
  decoder_agent     m_agent;
  decoder_scoreboard m_sb;
  
  function new(string name = "decoder_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    m_agent = decoder_agent::type_id::create("m_agent", , get_full_name());
    m_sb = decoder_scoreboard::type_id::create("m_sb", , get_full_name());
  endfunction

  virtual task run_phase (uvm_phase phase);
    phase.raise_objection(this);
    uvm_config_db #(uvm_object_wrapper)::set(this,"m_agent.m_sqr.default_sequence","default_sequence",
                                            decoder_seq::type_id::get());
    phase.drop_objection(this);
  endtask
endclass

