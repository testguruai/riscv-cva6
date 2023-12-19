
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: ariane_regfile_ff.sv
// UVM Test Bench and Test Code for ariane_regfile_ff.sv Verilog Code
// ==============================================================================
class regfile_env extends uvm_env;
  `uvm_component_utils(regfile_env)
  
  regfile_agent m_regfile_agent;
  regfile_scoreboard m_scoreboard;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_regfile_agent = regfile_agent::type_id::create("m_regfile_agent", this);
    m_scoreboard = regfile_scoreboard::type_id::create("m_scoreboard", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_regfile_agent.mon.ap.connect(m_scoreboard.regfile_analysis_export);
  endfunction

endclass

class regfile_test extends uvm_test;
  `uvm_component_utils(regfile_test)
  
  regfile_env m_env;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_env = regfile_env::type_id::create("m_env", this);
  endfunction

  task run_phase(uvm_phase phase);
    if (phase.get_name() == "run") begin
      `uvm_info("INFO", "This test exercises the Register file functionality", UVM_LOW);
      regfile_seq req;
      req = new();
      req.start(m_env.m_regfile_agent.seqr);
    end
    phase.ready_to_end();
  endtask
endclass
