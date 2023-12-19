
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: perf_counters.sv
// UVM Test Bench and Test Code for perf_counters.sv Verilog Code
// ==============================================================================
// Define UVM Testbench Components
class perf_counters_transaction extends uvm_sequence_item;
  rand logic [4:0] addr;
  rand logic we;
  rand riscv::xlen_t data;

  `uvm_object_utils(perf_counters_transaction)

  function new(string name = "perf_counters_transaction");
    super.new(name);
  endfunction

  virtual function void do_copy(uvm_object rhs);
    perf_counters_transaction rhs_;
    if (!$cast(rhs_, rhs)) begin
      uvm_report_fatal("do_copy", "rhs not type perf_counters_transaction", UVM_FATAL);
    end
    addr = rhs_.addr;
    we = rhs_.we;
    data = rhs_.data;
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    perf_counters_transaction rhs_;
    if (!$cast(rhs_, rhs)) begin
      return 0;
    end
    if (!(addr == rhs_.addr)) begin
      return 0;
    end
    if (!(we == rhs_.we)) begin
      return 0;
    end
    if (!(data == rhs_.data)) begin
      return 0;
    end
    return 1;
  endfunction
endclass // perf_counters_transaction

class perf_counters_driver extends uvm_driver #(perf_counters_transaction);
  virtual dut_if vif; // Reference to interface

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

  virtual task drive();
    vif.addr <= req.addr;
    vif.we <= req.we;
    vif.data <= req.data;
  endtask
endclass // perf_counters_driver

class perf_counters_sequencer extends uvm_sequencer #(perf_counters_transaction);
endclass

class perf_counters_agent extends uvm_agent;
  perf_counters_sequencer seqr;
  perf_counters_driver drv;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr = perf_counters_sequencer::type_id::create("seqr", this);
    drv = perf_counters_driver::type_id::create("drv", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
    drv.vif = vif;
  endfunction
endclass // perf_counters_agent
