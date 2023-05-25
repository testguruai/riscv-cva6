# VerifAI TestGuru
# Explanation for: serdiv.sv
## UVM Test Bench

The UVM Test Bench will be used to instantiate and connect the DUT to the verification environment, adding stimulus and checking for expected responses. In this case, we will generate random inputs and compare the DUT output to the expected output obtained from software calculations.

## UVM Test Code

```
class serdiv_tb extends uvm_test;

  // Declare DUT and other components as class members.
  serdiv dut;
  rand bit clk_i, rst_ni, in_vld_i, flush_i, out_rdy_i;
  rand logic [TRANS_ID_BITS-1:0] id_i;
  rand logic [WIDTH-1:0] op_a_i, op_b_i, res_o;
  rand logic [1:0] opcode_i;

  // Declaring the constraints for inputs.
  constraint rst_seq_c {rst_ni == 1'b0;}; 
  constraint vld_rdy_c {in_vld_i == ~dut.in_rdy_o;};
  constraint out_rdy_c {out_rdy_i == ~dut.out_vld_o;};
  constraint opcode_c {opcode_i inside {[2'b00:2'b11]} ;};
  constraint id_c {id_i inside {[TRANS_ID_BITS-1:0]}}; 
  constraint op_a_c {op_a_i inside {[$signed({32'hFFFF_FFFF, 32'hFFFF_FFFF})-1: $signed({32'h0000_0000, 32'h0000_0000})]};}
  constraint op_b_c {op_b_i inside {[$signed({32'hFFFF_FFFF, 32'hFFFF_FFFF})-1: $signed({32'h0000_0000, 32'h0000_0000})]};}

  // Constructor to set the test name.
  function new( string name, $unit u );
    super.new( name, u );
  endfunction

  // Build phase
  // Generate the sequences and items and set their default values
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dut = serdiv::type_id::create("dut", this);

    // Randomization configurations
    uvm_config_db #(virtual serdiv_config)::get(null, "", "config", config);
    config.is_active_randomization = 1;
    config.is_active_pass_en = 1;
    `uvm_info(get_type_name(), $psprintf("Randomization: %s", config.to_s()), UVM_NONE)
  endfunction

  // Run phase
  // Randomize and execute sequences of operations
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    // Variable declarations
    serdiv_config config;
    serdiv_tests_common t = serdiv_tests_common::type_id::create("test", this);
    serdiv_seq seq = serdiv_seq::type_id::create("seq", this);
    serdiv_driver drv = serdiv_driver::type_id::create("drv", this);
    serdiv_monitor mon = serdiv_monitor::type_id::create("mon", this);
    serdiv_agent agt = serdiv_agent::type_id::create("agt", this);
    
    // Configuring
    uvm_config_db #(virtual serdiv_config)::set(null, "", "config", config);
    agt.config = config;

    // Connecting
    uvm_config_db #(virtual serdiv_config)::set(drv, "*", "config", config);
    uvm_config_db #(virtual serdiv_config)::set(mon, "*", "config", config);
    uvm_config_db #(virtual serdiv_config)::set(agt, "*", "config", config);

    agt.driver = drv;
    agt.monitor = mon;

    seq.agent = agt;

    // Creating the sequence items.
    serdiv_seq_item req = serdiv_seq_item::type_id::create("req");
    serdiv_seq_item rsp = serdiv_seq_item::type_id::create("rsp");

    // Configuring the items.
    req.set_opcode(opcode_i);
    req.set_id(id_i);
    req.set_op_a(op_a_i);
    req.set_op_b(op_b_i);

    // Randomizing inputs using sequences.
    for(int i=0; i<10; i++) begin
      seq.start(req);
      seq.finish(rsp);
      
      // Assert responses. Expected result is obtained from software.
      `uvm_info(get_type_name(), $psprintf(" Response %d: Expected: %0h got %0h", i, serdiv_expected_result(req, rsp), rsp.get_res()), UVM_NONE)
      if(rsp.get_res() !== serdiv_expected_result(req, rsp))
        `uvm_fatal(get_type_name(), $psprintf(" Response %d: Expected: %0h got %0h", i, serdiv_expected_result(req, rsp), rsp.get_res()))
    end
  endtask

endclass
```## UVM Testbench and Test Code for Verilog Code

Below is the UVM testbench and test code for the given Verilog code. The test is aimed at verifying whether the registers and flags have the correct values after reset or flush. 

```systemverilog
`timescale 1ns/1ns
package tb_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
 
  // Define the testbench
  class tb extends uvm_test;
    `uvm_component_utils(tb)

  // DUT handle
    dut_if dut;
    
  // Test case
    test test1;

    // Sequence
      sequence flush_sequence;
        task body();
          dut.flush_i = 1'b1;
          #1;
          assert(dut.state_q === IDLE);
          assert(dut.op_a_q === 1'b0);
          assert(dut.op_b_q === 1'b0);
          assert(dut.res_q === 1'b0);
          assert(dut.cnt_q === 1'b0);
          assert(dut.id_q === 1'b0);
          assert(dut.rem_sel_q === 1'b0);
          assert(dut.comp_inv_q === 1'b0);
          assert(dut.res_inv_q === 1'b0);
          assert(dut.op_b_zero_q === 1'b0);
          assert(dut.div_res_zero_q === 1'b0);
        endtask
      endsequence

    // Driver
      class test_driver extends uvm_driver#(transaction);
        `uvm_component_utils(test_driver)

        // Constructor
        function new(string name, uvm_component parent);
          super.new(name, parent);
        endfunction

        // Main task
        task run_phase(uvm_phase phase);
          forever begin
            transaction txn;
            seq_item_port.get_next_item(txn);
            dut.load_en = txn.load_en;
            dut.opcode_i = txn.opcode_i;
            dut.op_a_sign = txn.op_a_sign;
            dut.op_b_sign = txn.op_b_sign;
            dut.op_b_zero = txn.op_b_zero;
            dut.id_i = txn.id;
            #1;
            assert(dut.rem_sel_d == txn.rem_sel);
            assert(dut.comp_inv_d == txn.comp_inv);
            assert(dut.op_b_zero_d == txn.op_b_zero);
            assert(dut.res_inv_d == txn.res_inv);
            assert(dut.id_d == txn.id);
            assert(dut.id_o == txn.id);
            assert(dut.op_a_d == txn.add_out || dut.op_a_q == txn.op_a_q);
            assert(dut.op_b_d == txn.b_mux || dut.op_b_q == txn.op_b_q);
            assert(dut.res_d == txn.res_q || dut.res_reg_en == 1'b0);
            seq_item_port.item_done(txn);
          end
        endtask
      endclass

    // Environment
      class env extends uvm_env;
        `uvm_component_utils(env)

        // Driver
        test_driver t_driver;

        // Constructor
        function new(string name, uvm_component parent);
          super.new(name, parent);
        endfunction

        // Build phase
        virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          dut = dut_if::type_id::create("dut", this);
          t_driver = test_driver::type_id::create("t_driver", this);
          uvm_config_db#(virtual test_driver)::set(null, "*", "vif_driver", t_driver);
        endfunction
      endclass

    // Top level agent
      class tb_agent extends uvm_agent;
        `uvm_component_utils(tb_agent)

        // Environment
        env e;

        // Constructor
        function new(string name, uvm_component parent);
          super.new(name, parent);
        endfunction

        // Build phase
        virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          e = env::type_id::create("env", this);
        endfunction
      endclass

    // Factory registration
      `uvm_object_param_utils(transaction)

    // Constructor
      function new(string name="tb");
        super.new(name);
      endfunction

    // Build phase
      virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        set_config_int("e.t_driver", "vif_driver", "sequence_item_queue_size", 10);
      endfunction

  endclass

endpackage
```

The testbench consists of the following components:
- Agent: Contains the environment and acts as the top-level component.
- Environment: Contains the driver and the DUT.
- Driver: Sends sequences to the DUT.
- Test case: Specifies a sequence of transactions that the driver should send to the DUT.
- Transaction: Contains the values for the input signals and the expected values for the output signals.

The test verifies whether the registers and flags in the DUT have the correct values after reset or flush. Specifically, the test ensures that the state, op_a, op_b, res, cnt, id, rem_sel, comp_inv, res_inv, op_b_zero, and div_res_zero have the expected values. 

The `flush_sequence` task sets the flush input to 1, waits for 1 unit of time, and then verifies that all the registers and flags in the DUT have been reset to 0.

The `test_driver` sends sequences of transactions to the DUT. The driver sets the input signals of the DUT according to the values in the transaction, waits for 1 time unit, and then verifies that the output signals of the DUT have the expected values.

Finally, the `tb` class builds the testbench components and sets the configuration for the driver sequence item queue size.