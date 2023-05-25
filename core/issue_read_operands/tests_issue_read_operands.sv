# VerifAI TestGuru
# Explanation for: issue_read_operands.sv
# UVM Test Bench and Test Code for "Issue_Read_Operands" module

```systemverilog
module issue_read_operands_tb;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "uvm-test-utils.sv"
  `include "tb_env.sv"
  `include "ref_model.sv"
  
  typedef struct {
    scoreboard_entry_t issue_instr;
    bool issue_instr_valid;
    fu_t [2**REG_ADDR_SIZE-1:0] rd_clobber_gpr;
    fu_t [2**REG_ADDR_SIZE-1:0] rd_clobber_fpr;
    riscv::xlen_t rs1;
    bool rs1_valid;
    riscv::xlen_t rs2;
    bool rs2_valid;
    rs3_len_t rs3;
    bool rs3_valid;
    logic [NR_COMMIT_PORTS-1:0][4:0] waddr;
    logic [NR_COMMIT_PORTS-1:0][riscv::XLEN-1:0] wdata;
    logic [NR_COMMIT_PORTS-1:0] we_gpr;
    logic [NR_COMMIT_PORTS-1:0] we_fpr;
    riscv::instruction_t orig_instr;
  } i_ro_tb_item;

  class i_ro_test extends uvm_test;
    `uvm_component_utils(i_ro_test)

    i_ro_env env;
    i_ro_ref_model ref_model;
    uvm_sequencer #(i_ro_tb_item) seqr;
    uvm_sequence #(i_ro_tb_item) seq;
    uvm_driver #(i_ro_tb_item) drv;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      env = i_ro_env::type_id::create("env", this);
      ref_model = i_ro_ref_model::type_id::create("ref_model", this);
      seqr = uvm_sequencer #(i_ro_tb_item)::type_id::create("seqr", this);
      seq = uvm_sequence #(i_ro_tb_item)::type_id::create("seq", this);
      drv = uvm_driver #(i_ro_tb_item)::type_id::create("drv", this);

      seq.seq_item = i_ro_tb_item::type_id::create("seq_item");
      seqr.seq_item_port.connect(ref_model.seq_item_export);
      drv.seq_item_port.connect(seqr.seq_item_export);
      env.seq_item_port.connect(seqr.seq_item_export);
      env.ref_model_port.connect(ref_model.ref_model_export);

      seq.starting_phase = phase;
      drv.starting_phase = phase;
      env.starting_phase = phase;

      uvm_config_db #(virtual i_ro_env)::set(null, "*", "env", env);
    endfunction : build_phase

    function void run_phase(uvm_phase phase);
      super.run_phase(phase);
      seq.start(env.seq_item_port);
      phase.raise_objection(this);
      uvm_test_done();
    endfunction : run_phase
  endclass : i_ro_test

module tb_env;
  import uvm_pkg::*;
  import ariane_pkg::*;
  `include "uvm_macros.svh"

  class i_ro_env extends uvm_env;
    `uvm_component_utils(i_ro_env)

    i_ro_seqr seq_item_port;
    i_ro_ref_model ref_model_port;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    endfunction : connect_phase

    function void run_phase(uvm_phase phase);
      super.run_phase(phase);
    endfunction : run_phase
  endclass : i_ro_env

  class i_ro_ref_model extends uvm_component;
    `uvm_component_utils(i_ro_ref_model)

    uvm_blocking_export #(i_ro_tb_item) seq_item_export;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    endfunction : connect_phase

    function void run_phase(uvm_phase phase);
      super.run_phase(phase);
    endfunction : run_phase
  endclass : i_ro_ref_model

  class i_ro_seqr extends uvm_sequencer #(i_ro_tb_item);
    `uvm_component_utils(i_ro_seqr)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    virtual task body();
      seq_item_export.get(req);
      rs1 = req.rs1;
      rs1_valid = req.rs1_valid;
      rs2 = req.rs2;
      rs2_valid = req.rs2_valid;
      rs3 = req.rs3;
      rs3_valid = req.rs3_valid;
      rd_clobber_gpr = req.rd_clobber_gpr;
      rd_clobber_fpr = req.rd_clobber_fpr;
      waddr = req.waddr;
      wdata = req.wdata;
      we_gpr = req.we_gpr;
      we_fpr = req.we_fpr;
      orig_instr = req.orig_instr;
      start_item(req);
      finish_item(req);
    endtask : body
  endclass : i_ro_seqr
endmodule
```

## Test Cases

```systemverilog
class issue_read_operands_tc extends i_ro_test;
  `uvm_component_utils(issue_read_operands_tc)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual task run_phase(uvm_phase phase);
    i_ro_tb_item item;

    // TEST CASE 1
    `uvm_info("TC1", "Test Case 1: POLLING SCOREBOARD", UVM_MEDIUM)
    item = new();
    item.issue_instr.op = LUI;
    item.issue_instr.rs1 = 0;
    item.issue_instr.rs2 = 0;
    item.issue_instr.result = {31'b0, 20'hA};
    item.orig_instr = {31'b0, 7'b0110111, 5'b0, 5'b0, 5'b0, 7'b0, 12'b0, 1'b0};
    item.issue_instr_valid = 1'b1;
    item.rs1_valid = 1'b1;
    item.rs1 = 0;
    item.rs2_valid = 1'b1;
    item.rs2 = 0;
    item.rs3_valid = 1'b0;
    item.rd_clobber_gpr = fu_t'(0);
    item.rd_clobber_fpr = fu_t'(0);
    item.waddr = '{'h0, 'h1};
    item.wdata = '{32'h00000000,32'h00000A00};
    item.we_gpr = '{1'b0, 1'b0};
    item.we_fpr = '{1'b0, 1## UVM Test Bench and Test Code

### UVM Test Bench

```systemverilog
`timescale 1ns / 1ps

module top_tb;

   // System Clock
   logic clk = 0;
   // Reset Signal (Active Low)
   logic rst_n = 1;

   always #5 clk = ~clk;

   initial begin
       // Initialize Inputs
       rst_n = 0;
       #15;
       rst_n = 1;

       // Start Test
       run_test();
   end

   import uvm_pkg::*;
   import rv_uvm.*;

    // Instantiate DUT
   rv_item_converter converter;
   rv_scoreboard scoreboard;
    
   rv_if_bus_agent dut_agent(.driver(converter), .monitor(scoreboard));

   virtual function void run_test();
      rv_test test;

      test = rv_test::type_id::create("rv_test");
      test.start(dut_agent);
   endfunction: run_test

endmodule: top_tb
```

### UVM Test Code

```systemverilog
class rv_test extends rv_uvm_base_test;

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Create UVC
      dut_agent = rv_if_bus_agent::type_id::create("dut_agent", , get_full_name);
      // Add UVC to Root
      uvm_top.add(dut_agent);

      // Create Test Sequence
      test_seqr = rv_base_test_seqr::type_id::create("test_seqr");
      // Add Test Sequence
      uvm_top.set_sequencer(get_full_name() + ".dut_agent.bus_sequencer", test_seqr);
   endfunction: build_phase

endclass: rv_test
```## UVM Test Bench and Test Code for Verilog Code

### UVM Test Bench

```
`include "uvm_macros.svh"

package testbench_pkg;
  import uvm_pkg::*;

  // Define testbench components
  class regfile_tb extends uvm_test;
    `uvm_component_utils(regfile_tb)

    rand int unsigned NR_RGPR_PORTS;
    rand int unsigned NR_COMMIT_PORTS;
    rand bit FP_PRESENT;
    rand bit CVXIF_PRESENT;

    virtual regfile_vif vif;
    virtual regfile_driver drv;
    virtual regfile_monitor mon;
    virtual regfile_agent agent;
    virtual regfile_sequence seq;

    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Create the virtual interface
      vif = regfile_vif::type_id::create("vif", this);

      // Create the regfile agent
      agent = regfile_agent::type_id::create("agent", this);
      agent.vif = vif;

      // Create the regfile driver
      drv = regfile_driver::type_id::create("drv", this);
      drv.vif = vif;

      // Create the regfile monitor
      mon = regfile_monitor::type_id::create("mon", this);
      mon.vif = vif;

      // Create the sequence
      seq = regfile_sequence::type_id::create("seq", this);

      // Set the sequence configuration based on the randomized constraints
      seq.NR_RGPR_PORTS = this.NR_RGPR_PORTS;
      seq.NR_COMMIT_PORTS = this.NR_COMMIT_PORTS;
      seq.FP_PRESENT = this.FP_PRESENT;
      seq.CVXIF_PRESENT = this.CVXIF_PRESENT;

      // Connect the scoreboard
      agent.sb.scoreboard = mon.sb;
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      // Connect and start the regfile sequence
      seq.connect();
      seq.start(agent.seqr);
    endfunction
  endclass : regfile_tb
endpackage : testbench_pkg
```

### UVM Test Code

```
`include "uvm_macros.svh"
package regfile_test_pkg;
  import uvm_pkg::*;
  import uvm_reg::*;
  import uvm_testbench::*;

  `include "test_const.sv"

  // Define the regfile sequence
  class regfile_sequence extends uvm_sequence;
    `uvm_object_utils(regfile_sequence)

    rand int unsigned NR_RGPR_PORTS;
    rand int unsigned NR_COMMIT_PORTS;
    rand bit FP_PRESENT;
    rand bit CVXIF_PRESENT;

    virtual regfile_sequencer seqr;

    // Define the sequence constructor and initialization function
    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
    endfunction : new

    virtual function void start(uvm_sequencer_base sequencer, uvm_sequence_base parent_sequence = null);
      seqr = sequencer;

      // Configure the regfile
      seqr.regfile.rdata.randomize;
      seqr.regfile.raddr_pack.randomize;
      seqr.regfile.waddr_pack.randomize;
      seqr.regfile.wdata_pack.randomize;
      seqr.regfile.we_pack.randomize;

      if(FP_PRESENT == 1) begin
        seqr.regfile.fprdata.randomize;
        seqr.regfile.fp_raddr_pack.randomize;
        seqr.regfile.fp_wdata_pack.randomize;
        seqr.regfile.we_fpr_i.randomize;
      end

      // Send write transactions to the regfile
      for (int i = 0; i < NR_COMMIT_PORTS; i++) begin
        uvm_reg_data_t wdata;
        if (FP_PRESENT == 1)
          wdata = {FLEN{1'b0}};
        else
          wdata = $random;

        uvm_status_e status;
        if (i == 0)  // First transaction is always for the Operand A register
          status = seqr.regfile.write_register(0, wdata, seqr.trans, seqr.agent, 1);
        else if (i == 1) // Second transaction is always for the Operand B register
          status = seqr.regfile.write_register(1, wdata, seqr.trans, seqr.agent, 1);
        else
          status = seqr.regfile.write_register(2+i, wdata, seqr.trans, seqr.agent, 1);

        if (status != UVM_IS_OK)
          `uvm_error("regfile_sequence", $sformatf("Failed to write to regfile at index: %0d", i));
      end

      // Send read transactions to the regfile
      for (int i = 0; i < NR_RGPR_PORTS; i++) begin
        uvm_reg_data_t rdata;
        uvm_status_e status = seqr.regfile.read_register(i, rdata, seqr.trans, seqr.agent, 1);

        if (status != UVM_IS_OK)
          `uvm_error("regfile_sequence", $sformatf("Failed to read from regfile at index: %0d", i));
      end
    endfunction
  endclass : regfile_sequence

  // Define the regfile driver
  class regfile_driver extends uvm_driver;
    `uvm_component_utils(regfile_driver)

    virtual regfile_vif vif;

    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
    endfunction : new

    virtual function void run_phase(uvm_phase phase);
      while (1) begin
        // Drive random data on regfile we signals
        vif.we_gpr_i = $urandom;

        if (vif.FP_PRESENT == 1)
          vif.we_fpr_i = $urandom;

        `uvm_info(this.get_type_name(), $sformatf("Driving regfile WE signals with we_gpr_i=%0h, we_fpr_i=%0h", vif.we_gpr_i, vif.we_fpr_i), UVM_MEDIUM)

        #1;
      end
    endfunction
  endclass : regfile_driver

  // Define the regfile monitor
  class regfile_monitor extends uvm_monitor;
    `uvm_component_utils(regfile_monitor)

    regfile_scoreboard sb;
    virtual regfile_vif vif;

    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Connect an instance of the scoreboard for checking regfile transactions
      sb = regfile_scoreboard::type_id::create("sb", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
      uvm_reg_data_t rdata;
      uvm_status_e status;

      // Monitor the regfile's write enable signal
      forever @(vif.we_gpr_i or vif.we_fpr_i) begin
        if (vif.we_gpr_i == 1) begin
          // Monitor GPR writes
          for (int i = 0; i < NR_COMMIT_PORTS; i++) begin
            if (vif.we_pack[i] == 1) begin
              status = sb.compare_gpr_write(i, vif.waddr_pack[i], vif.wdata_pack[i], vif.rdata[i]);

              if (status != UVM_IS_OK) begin
                `uvm_error("regfile_monitor", $sformatf("Detected a failure while monitoring GPR write to index %0d", i))
              end
            end
          end
        end else if (vif.we_fpr_i == 1) begin
          // Monitor FPR writes
          for (int i = 0; i < 3; i++) begin
            if (vif.we_fpr_i[i] == 1) begin
              status = sb.compare_fpr_write(i, vif.fp_wdata_pack[i], vif.fp_raddr_pack[i], vif.fprdata[i]);

              if (status != UVM_IS_OK) begin
                `uvm_error("regfile_monitor", $sformatf("Detected a failure while monitoring FPR write to index %0d", i))
              end
            end
          end
        end
      end

      // Monitor the regfile's read signals
      repeat (NR_RGPR_PORTS) begin
        @(vif.raddr_pack or vif.rdata)
        for (int i = 0; i < NR_RGPR_PORTS; i++) begin
          status = sb.compare_gpr_read(i, vif.raddr_pack[i], vif.rdata[i]);

          if (status != UVM_IS_OK) begin
            `uvm_error("regfile_monitor", $sformatf("Detected a failure while monitoring GPR read to index %0d", i))
          end
        end
      end
    endtask
  endclass : regfile_monitor

  // Define the regfile agent
  class regfile_agent extends uvm_agent;
    `uvm_component_utils(regfile_agent)
    regfile_sequencer sequencer;
    regfile_monitor monitor;
    regfile_driver driver;

    function new(string name = "", uvm_component parent = null);
      super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Create and connect the sequencer
      sequencer = regfile_sequencer::type_id::create("sequencer", this);
      sequencer.randomize();

      // Create and connect the driver
      driver = regfile_driver::type_id::create("driver", this);
      driver.vif = vif;

      // Create and connect the monitor
      monitor = regfile_monitor::type_id::create("monitor", this);
      monitor.vif = vif;
    endfunction
  endclass : regfile_agent

endpackage : regfile_test_pkg
```