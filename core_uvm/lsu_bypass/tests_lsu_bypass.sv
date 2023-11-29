// VerifAI TestGuru
// tests for: lsu_bypass.sv
module lsu_bypass_tb;
  import uvm_pkg::*;
  import lsu_pkg::*;

  `include "uvm_macros.svh"

  class lsu_bypass_test extends uvm_test;
    `uvm_component_utils(lsu_bypass_test)

    // Declare testbench components
    lsu_bypass lsu_ctrl;
    uvm_reg_block reg_block;

    // Declare testbench variables
    uvm_reg_adapter reg_adapter;

    // Declare register variables
    uvm_reg_field lsu_req_valid_i;
    uvm_reg_field pop_ld_i;
    uvm_reg_field pop_st_i;
    uvm_reg_field lsu_ctrl_o;
    uvm_reg_field ready_o;

    // Constructor
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    // Build phase
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Create and configure testbench components
      lsu_ctrl = new();
      reg_block = uvm_reg_block::type_id::create("reg_block", this);

      // Create register adapter
      reg_adapter = new();

      // Add the register adapter to the reg_block
      reg_block.adapter = reg_adapter;

      // Create and add registers to the reg_block
      lsu_req_valid_i = new(1);
      pop_ld_i = new(1);
      pop_st_i = new(1);
      lsu_ctrl_o = new($bits(lsu_ctrl.lsu_ctrl_o));
      ready_o = new(1);

      reg_block.add_reg_field(lsu_req_valid_i);
      reg_block.add_reg_field(pop_ld_i);
      reg_block.add_reg_field(pop_st_i);
      reg_block.add_reg_field(lsu_ctrl_o);
      reg_block.add_reg_field(ready_o);

      // Set default values for register fields
      lsu_req_valid_i.set_default(0);
      pop_ld_i.set_default(0);
      pop_st_i.set_default(0);

      // Connect register fields to signals in the DUT
      reg_adapter.add_hdl_path(lsu_req_valid_i, "top.lsu_req_valid_i");
      reg_adapter.add_hdl_path(pop_ld_i, "top.pop_ld_i");
      reg_adapter.add_hdl_path(pop_st_i, "top.pop_st_i");
      reg_adapter.add_hdl_path(lsu_ctrl_o, "top.lsu_ctrl_o");
      reg_adapter.add_hdl_path(ready_o, "top.ready_o");

      // Add the reg_block to the lsu_ctrl
      lsu_ctrl.reg_block = reg_block;

      // Add the lsu_ctrl to the testbench
      reg_adapter.add_monitor(lsu_ctrl);

      // Set the lsu_ctrl as the default sequence item factory for the testbench
      uvm_set_default_sequence(this, lsu_ctrl.get_sequence());

    endfunction

    // Run phase
    task run_phase(uvm_phase phase);
      super.run_phase(phase);

      // Start the lsu_ctrl
      lsu_ctrl.start();

      // Run the test
      run_test();

      // Terminate the simulation
      phase.raise_objection(this);
      phase.drop_objection(this);
    endtask

    // Shutdown phase
    task shutdown_phase(uvm_phase phase);
      // Stop the lsu_ctrl
      lsu_ctrl.stop();

      // Execute the parent's shutdown_phase method
      super.shutdown_phase(phase);
    endtask

  endclass

  // Create top level test
  initial begin
    lsu_bypass_test test = new("test", null);
    uvm_config_db#(uvm_object_wrapper)::set(null, "*", "default_sequence", lsu_ctrl.get_sequence());
    run_test();
  end
endmodule
