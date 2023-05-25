# VerifAI TestGuru
# Explanation for: ex_stage.sv
# UVM Test Bench and Test Code

## Introduction

This verilog code describes the instantiation of all the functional units located in the execute stage of the processor. This code contains multiple modules and signals that need to be tested. In order to achieve that, we will implement a UVM test bench and test the various features of this module.

## UVM Test Bench

The UVM test bench consists of various components such as driver, monitor, scoreboard, agents, and test. The following are the important components of the test bench.

### Driver

The driver is responsible for driving the input signals of the UUT. In this case, the input signals of the UUT are `clk_i`, `rst_ni`, `flush_i`, `debug_mode_i`, `rs1_forwarding_i`, `rs2_forwarding_i`, `fu_data_i`, `pc_i`, `is_compressed_instr_i`, `alu_valid_i`, `branch_valid_i`, `branch_predict_i`, `csr_valid_i`, `mult_valid_i`, `lsu_valid_i`, `lsu_commit_i`, `amo_valid_commit_i`, `fpu_valid_i`, `fpu_fmt_i`, `fpu_rm_i`, `fpu_frm_i`, `fpu_prec_i`, `x_valid_i`, `x_off_instr_i`, `cvxif_req_o`, `enable_translation_i`, `en_ld_st_translation_i`, `flush_tlb_i`, `priv_lvl_i`, `ld_st_priv_lvl_i`, `sum_i`, `mxr_i`, `satp_ppn_i`, `asid_i`, `icache_areq_i`, `dcache_req_ports_i`, `dcache_wbuffer_empty_i`, `dcache_wbuffer_not_ni_i`, `amo_resp_i`, `pmpcfg_i`, and `pmpaddr_i`. The following is an example code of the driver for `clk_i` signal.

```SystemVerilog
class ex_stage_driver extends uvm_driver #(ex_stage_cp_if);

  // We define a reference to our DUT interface here so we can make use of it
  // via the ex_stage_cp_if port used in our UVM register model,
  // which consists of all the signals of a single port of the DUT,
  // the signals used for interfacing from another module.
  `uvm_component_param_utils(ex_stage_cb_if)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //--------------------------------------------------------------------
  // The main task of the driver is to generate stimulus for the DUT.
  //
  virtual task run_phase(uvm_phase phase);
    forever begin
      // Generate a clock cycle
      ex_cp.clk_i <= 1'b1;
      @(posedge ex_cp.clk_i);
      ex_cp.clk_i <= 1'b0;
      @(negedge ex_cp.clk_i);

      ...
    end
  endtask: run_phase

endclass: ex_stage_driver

```

### Monitor

The monitor is responsible for monitoring the output signals of the UUT and converts them into transactions that can be checked by the scoreboard. In this case, the output signals of the UUT are `flu_result_o`, `flu_trans_id_o`, `flu_exception_o`, `flu_ready_o`, `flu_valid_o`, `resolved_branch_o`, `load_valid_o`, `load_result_o`, `load_trans_id_o`, `load_exception_o`, `store_valid_o`, `store_result_o`, `store_trans_id_o`, `store_exception_o`, `lsu_ready_o`, `fpu_ready_o`, `fpu_trans_id_o`, `fpu_result_o`, `fpu_valid_o`, `fpu_exception_o`, `x_ready_o`, `x_trans_id_o`, `x_exception_o`, `x_result_o`, `x_valid_o`, `x_we_o`, `cvxif_req_o`, `icache_areq_o`, `dcache_req_ports_o`,  and `amo_req_o`. The following is an example code of the monitor for `flu_result_o` signal.

```SystemVerilog
class ex_stage_monitor extends uvm_monitor;

  `uvm_component_param_utils(ex_stage_cb_if)

  // Declare the monitored signal
  bit [riscv::XLEN-1:0] flu_result_m;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge ex_cp.clk_i);
      if (!reset) disable_monitor();
      else if (ex_cp.flu_valid_o) begin
        // Sample the signals
        flu_result_m = ex_cp.flu_result_o;
        
        // Create the transaction based on the sampled signals
        ex_stage_monitor_item monitor_item;
        monitor_item.flu_result = flu_result_m;
        
        // Send the transaction to the scoreboard
        scoreboard_item_port.write(monitor_item);
      end
    end
  endtask: run_phase

endclass
```

### Scoreboard

The scoreboard is responsible for comparing the expected output of the UUT with the actual output. In this case, the scoreboard will compare the expected output with the actual output for the signals `flu_result_o`, `flu_trans_id_o`, `flu_exception_o`, `flu_ready_o`, `flu_valid_o`, `resolved_branch_o`, `load_valid_o`, `load_result_o`, `load_trans_id_o`, `load_exception_o`, `store_valid_o`, `store_result_o`, `store_trans_id_o`, `store_exception_o`, `lsu_ready_o`, `fpu_ready_o`, `fpu_trans_id_o`, `fpu_result_o`, `fpu_valid_o`, `fpu_exception_o`, `x_ready_o`, `x_trans_id_o`, `x_exception_o`, `x_result_o`, `x_valid_o`, `x_we_o`, `cvxif_req_o`, `icache_areq_o`, `dcache_req_ports_o`, and `amo_req_o`. The following is an example code of the scoreboard to compare `flu_result_o` signal.

```SystemVerilog
class ex_stage_scoreboard extends uvm_scoreboard;

  `uvm_component_param_utils(ex_stage_cb_if)

  // Declare the expected values
  riscv::xlen_t flu_result_e;
  
  // Callback to retrieve expected values based on input
  virtual function void get_expected
    (input ex_stage_monitor_item monitor_item,
     output ex_stage_expected_item exp_item);
     exp_item.flu_result = flu_result_e;
  endfunction
  
  // Callback to compare actual and expected values
  virtual function void compare_results
    (input ex_stage_monitor_item monitor_item,
     input ex_stage_expected_item exp_item);
     expect_equal(monitor_item.flu_result, exp_item.flu_result,
                  $sformatf("flu_result: Monitor=%0h, Expected=%0h",
                            monitor_item.flu_result, exp_item.flu_result));
  endfunction

endclass: ex_stage_scoreboard
```

### Test

The test is responsible## UVM Test Bench and UVM Test Code for the Given Verilog Code

We can write a UVM test bench and test code for the given verilog code to test the functionality of the different units.

### UVM Test Bench

```systemverilog
`include "uvm_macros.svh"

package test_pkg;

import uvm_pkg::*;
import pkg_flu::*;
import pkg_multiplication::*;
import pkg_fpu::*;
import pkg_lsu::*;

class test_bench extends uvm_test;

    fluent_agent flu_agent;
    lsu_agent lsu_agent;
    fpu_agent fpu_agent;
    multiplication_agent mul_agent;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        flu_agent = fluent_agent::type_id::create("flu_agent", this);
        lsu_agent = lsu_agent::type_id::create("lsu_agent", this);
        fpu_agent = fpu_agent::type_id::create("fpu_agent", this);
        mul_agent = multiplication_agent::type_id::create("mul_agent", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_type_name(), "Running test phase", UVM_MEDIUM)
        fork : sim
            flu_agent.run_test();
            lsu_agent.run_test();
            fpu_agent.run_test();
            mul_agent.run_test();
        join : sim
    endtask
endclass

endpackage
```

### UVM Test Code

We can write individual `uvm_test` classes for testing the functionality of the fluent, multiplication, fpu and lsu units.

#### Fluent Unit Test

```systemverilog
class fluent_test extends uvm_test;

  fluent_agent flu_agent;
  fluent_sequencer seq;
  fluent_driver driver;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    flu_agent = fluent_agent::type_id::create("flu_agent", this);
    seq = fluent_sequencer::type_id::create("seq", this);
    driver = fluent_driver::type_id::create("driver", this);

    seq.agent = flu_agent;
    driver.seq_item_port.connect(seq.seq_item_export);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork : sim
      driver.drive();
      @(driver.done);
      flu_agent.check();
    join_none
  endtask

endclass
```

#### Multiplication Unit Test

```systemverilog
class multiplication_test extends uvm_test;

  multiplication_agent mul_agent;
  multiplication_sequencer seq;
  multiplication_driver driver;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mul_agent = multiplication_agent::type_id::create("mul_agent", this);
    seq = multiplication_sequencer::type_id::create("seq", this);
    driver = multiplication_driver::type_id::create("driver", this);

    seq.agent = mul_agent;
    driver.seq_item_port.connect(seq.seq_item_export);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork : sim
      driver.drive();
      @(driver.done);
      mul_agent.check();
    join_none
  endtask

endclass
```

#### FPU Unit Test

```systemverilog
class fpu_test extends uvm_test;

  fpu_agent fpu_agent;
  fpu_sequencer seq;
  fpu_driver driver;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    fpu_agent = fpu_agent::type_id::create("fpu_agent", this);
    seq = fpu_sequencer::type_id::create("seq", this);
    driver = fpu_driver::type_id::create("driver", this);

    seq.agent = fpu_agent;
    driver.seq_item_port.connect(seq.seq_item_export);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork : sim
      driver.drive();
      @(driver.done);
      fpu_agent.check();
    join_none
  endtask

endclass
```

#### LSU Unit Test

```systemverilog
class lsu_test extends uvm_test;

  lsu_agent lsu_agent;
  lsu_sequencer seq;
  lsu_driver driver;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    lsu_agent = lsu_agent::type_id::create("lsu_agent", this);
    seq = lsu_sequencer::type_id::create("seq", this);
    driver = lsu_driver::type_id::create("driver", this);

    seq.agent = lsu_agent;
    driver.seq_item_port.connect(seq.seq_item_export);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork : sim
      driver.drive();
      @(driver.done);
      lsu_agent.check();
    join_none
  endtask

endclass
```