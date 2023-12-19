
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: fpu_wrap.sv
// UVM Test Bench and Test Code for fpu_wrap.sv Verilog Code
// ==============================================================================
class ARIANE_FPU_TB;
  virtual uvm_env ariane_fpu_env; // env instantiates the DUT and the testbench components
endclass
    
class ARIANE_FPU_ENV extends uvm_env;
  uvm_sequencer uvm_seqr; // Sends stimulus to the driver
  FPU_DRIVER fpu_drv; // Drives the inputs to the DUT
  FPU_MONITOR fpu_mon; // Checks outputs of the DUT
endclass

class FPU_SEQUENCER extends uvm_sequencer #(fpunit_sequence_item);
endclass

class fpunit_sequence_item extends uvm_sequence_item;
  rand logic           clk_i;
  rand logic           rst_ni;
  rand logic           flush_i;
  rand logic           fpu_valid_i;
  rand fu_data_t       fu_data_i;
  rand logic [1:0]     fpu_fmt_i;
  rand logic [2:0]     fpu_rm_i;
  rand logic [2:0]     fpu_frm_i;
  rand logic [6:0]     fpu_prec_i;
endclass
    
class FPU_DRIVER extends uvm_driver #(fpunit_sequence_item);
  virtual driving_if driving_vif;

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req); // receive sequence item from the sequencer
      // ...
      seq_item_port.item_done();
    end
  endtask
endclass
  
class FPU_MONITOR extends uvm_monitor;
  virtual monitor_if     monitoring_vif;

  task run_phase(uvm_phase phase);
    forever begin
      // monitor the outputs
    end
  endtask
endclass
  
class fpunit_test extends uvm_test;
  ARIANE_FPU_TB ariane_fpu_tb;

  function new(string name = "fpunit_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    ariane_fpu_tb = my_dut_type::type_id::create("my_dut_instance_name", this);
  endfunction: build_phase

  function void run_phase(uvm_phase phase);
    signal_a.start(ariane_fpu_tb.ariane_fpu_env.uvm_seqr);
    signal_b.start(ariane_fpu_tb.ariane_fpu_env.uvm_seqr);
  endfunction: run_phase
endclass: fpunit_test
