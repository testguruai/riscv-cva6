# VerifAI TestGuru
# Explanation for: scoreboard.sv
# UVM Test Bench and UVM Test code for Scoreboard

## Introduction
The Scoreboard is a hardware unit that keeps track of all decoded, issued and committed instructions. In this markdown, we will create a UVM Test Bench and UVM Test code for the Scoreboard module.

## UVM Test Bench
The UVM Test Bench will consist of the following components:
1. Driver
2. Scoreboard Agent
3. Monitor
4. Environment

### Driver
The Driver is responsible for driving transactions into the DUT, in this case, Scoreboard.

```SystemVerilog
class scoreboard_driver extends uvm_driver #(scoreboard_transaction);
  `uvm_component_utils(scoreboard_driver)

  scoreboard scoreboard_dut;
  scoreboard_transaction sb_trans;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    scoreboard_dut = scoreboard::type_id::create("scoreboard_dut", this);
    scoreboard_dut.reset();
    
    forever begin
      // Generate random transaction
      sb_trans = scoreboard_transaction::type_id::create("sb_trans");
      sb_trans.op = randomize(ariane_pkg::op_type_e::ADD, ariane_pkg::op_type_e::SUB);
      sb_trans.rd = randomize(ariane_pkg::reg::x0, ariane_pkg::reg::x31);
      sb_trans.rs1 = randomize(ariane_pkg::reg::x0, ariane_pkg::reg::x31);
      sb_trans.rs2 = randomize(ariane_pkg::reg::x0, ariane_pkg::reg::x31);
      sb_trans.rs3 = randomize(ariane_pkg::rs3_len_t::H, ariane_pkg::rs3_len_t::B);
      sb_trans.fu = randomize(ariane_pkg::fu_t::NONE, ariane_pkg::fu_t::LD);
      
      // Send transaction to the DUT
      `uvm_do_with(sb_trans, { scoreboard_dut.scoreboard_if.write_sb_transaction(sb_trans); } )
    end
  endtask
endclass
```

### Scoreboard Agent
The Scoreboard Agent is responsible for generating transactions and comparing the output with the expected result.

```SystemVerilog
class scoreboard_agent extends uvm_agent;
  `uvm_component_utils(scoreboard_agent)

  scoreboard_driver sb_driver;
  scoreboard_scoreboard sb_scoreboard;
  scoreboard_monitor sb_monitor;
  scoreboard_sequencer sb_sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_sequencer = scoreboard_sequencer::type_id::create("sb_sequencer", this);
    sb_driver = scoreboard_driver::type_id::create("sb_driver", this);
    sb_scoreboard = scoreboard_scoreboard::type_id::create("sb_scoreboard", this);
    sb_monitor = scoreboard_monitor::type_id::create("sb_monitor", this);

    sb_sequencer.sequencer_trans_buf.set_automatic_phase_objection(1);
    sb_driver.scoreboard_dut = sb_scoreboard.get_top_scores_ScoreboardInterface();
    sb_monitor.scoreboard_dut = sb_scoreboard.get_top_scores_ScoreboardInterface();
    sb_monitor.sequencer_trans_buf = sb_sequencer.sequencer_trans_buf;

    scoreboard_sequencer_config sb_config;
    sb_sequencer.get_config(sb_config);
    sb_config.req_rsp_portals = {sb_scoreboard.rsp_portal};
    sb_sequencer.set_config(sb_config);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_driver.seq_item_port.connect(sb_sequencer.seq_item_export);
  endfunction
endclass
```

### Monitor
The Monitor is responsible for monitoring the DUT output and generating transactions to the Scoreboard.

```SystemVerilog
class scoreboard_monitor extends uvm_monitor;
  `uvm_component_utils(scoreboard_monitor)

  uvm_blocking_put_port#(scoreboard_transaction) put_port;
  scoreboard_scoreboard scoreboard_dut;
  uvm_tlm_analysis_fifo#(scoreboard_transaction) sequencer_trans_buf;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      // Wait for the scoreboard output
      wait (scoreboard_dut.scoreboard_if.sb_output_port.size() != 0);

      // Get the output transaction
      scoreboard_transaction sb_trans;
      scoreboard_dut.scoreboard_if.sb_output_port.get(sb_trans);

      // Send transaction to the Sequencer
      sequencer_trans_buf.put(sb_trans);
    end
  endtask
endclass
```

### Environment
The Environment is responsible for connecting all the components of the test bench and starting the test.

```SystemVerilog
class scoreboard_env extends uvm_env;
  `uvm_component_utils(scoreboard_env)

  scoreboard_agent sb_agent;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_agent = scoreboard_agent::type_id::create("sb_agent", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    phase.drop_objection(this);
  endtask
endclass
```

## UVM Test Code
The UVM Test Code consists of the scoreboard transaction class and the test itself.

### Scoreboard Transaction Class
The scoreboard transaction class defines the data fields for a scoreboard transaction.

```SystemVerilog
class scoreboard_transaction extends uvm_sequence_item;
  `uvm_object_utils(scoreboard_transaction)

  ariane_pkg::op_type_e op;
  ariane_pkg::reg rd;
  ariane_pkg::reg rs1;
  ariane_pkg::reg rs2;
  ariane_pkg::rs3_len_t rs3;
  ariane_pkg::fu_t fu;
  
  function new(string name = "");
    super.new(name);
  endfunction

  function void do_print(uvm_printer printer);
    super.do_print(printer);
    `uvm_info(get_name(), $"op = {op}", UVM_MEDIUM)
    `uvm_info(get_name(), $"rd = {rd}", UVM_MEDIUM)
    `uvm_info(get_name(), $"rs1 = {rs1}", UVM_MEDIUM)
    `uvm_info(get_name(), $"rs2 = {rs2}", UVM_MEDIUM)
    `uvm_info(get_name(), $"rs3 = {rs3```SystemVerilog
class scoreboard_tb extends uvm_tb;
  scoreboard uut;
  virtual function void build_phase(uvm_phase phase);
    uvm_config_db#(virtual scoreboard)::set(null, "*", "uut", uut);
  endfunction
  virtual task run_phase(uvm_phase phase);
    fork
      run_test() with dut=uut;
    join_none
  endtask
endclass

class scoreboard_test extends uvm_test;
  virtual function void build_phase(uvm_phase phase);
    ariane_config cfg;
    if(!uvm_config_db#(ariane_config)::get(this,"", "cfg", cfg)) begin
      `uvm_fatal("NO_CFG","Error: no configuration object found")
    end
    scoreboard_env env;
    scoreboard_checker checker;
    scoreboard_agent m_agent;
    uvm_config_db#(scoreboard_env)::set(this, "*", "env", env);
    uvm_config_db#(scoreboard_checker)::set(this, "*", "checker", checker);
    uvm_config_db#(scoreboard_agent)::set(this, "*", "m_agent", m_agent);
  endfunction

  virtual task run_phase(uvm_phase phase);
      env = scoreboard_env::type_id::create("env", this);
      m_agent = scoreboard_agent::type_id::create("m_agent", this);
      m_agent.p_sequencer  = env.seqr;
      checker = scoreboard_checker::type_id::create("checker", this);
      env.connect(m_agent, checker);
      env.run_test();
      #1 // give a chance for the scoreboard_env's run task to complete
  endtask
endclass
```