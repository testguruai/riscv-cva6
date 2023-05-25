# VerifAI TestGuru
# Explanation for: perf_counters.sv
# UVM Test Bench and Test Code for Perf Counters

The Performance Counters module provided above can be tested using UVM. Below is the UVM test bench and test code for the same.

```systemverilog
`include "uvm_macros.svh"

package perf_counters_pkg;
  import uvm_pkg::*;

  class perf_counters_agent extends uvm_agent;
    `uvm_component_utils(perf_counters_agent)

    perf_counters_dut dut;
    uvm_analysis_port scoreboard_export;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "Build Phase", UVM_MEDIUM)

      dut = perf_counters_dut::type_id::create("dut", this);
      scoreboard_export = new("sb_export", this);

      // connect scoreboard to the DUT
      dut.scoreboard_export.connect(scoreboard_export);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info(get_type_name(), "Connect Phase", UVM_MEDIUM)

      // connect the analysis Export to the scoreboard agent here.
    endfunction : connect_phase
  endclass : perf_counters_agent

  class perf_counters_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(perf_counters_scoreboard)

    uvm_analysis_port#(perf_counters_transactions) analysis_export;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      analysis_export = new("analysis_export", this);
    endfunction : new

    function void write_counters(perf_counters_transactions tr);
      // write perf_counters_transactions to endpoint here
      analysis_export.write(tr);
    endfunction : write_counters
  endclass : perf_counters_scoreboard

  class perf_counters_test extends uvm_test;
    `uvm_component_utils(perf_counters_test)

    perf_counters_agent agent;
    perf_counters_scoreboard scoreboard;
    perf_counters_test_seq seq;

    function new(string name="perf_counters_test", uvm_component parent=null);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "Build Phase", UVM_MEDIUM)

      agent = perf_counters_agent::type_id::create("agent", this);
      scoreboard = perf_counters_scoreboard::type_id::create("scoreboard", this);
      seq = perf_counters_test_seq::type_id::create("seq", this);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info(get_type_name(), "Run Phase", UVM_MEDIUM)

      phase.raise_objection(this);
      start_item(seq);
      finish_item(seq);
      phase.drop_objection(this);
    endtask : run_phase
  endclass : perf_counters_test

  class perf_counters_test_seq extends uvm_sequence;
    `uvm_object_utils(perf_counters_test_seq)

    perf_counters_transactions tr;

    function new(string name = "perf_counters_test_seq");
      super.new(name);
    endfunction

    virtual task body();
      // write test sequence here, write counts to perf_counters_transactions
      scoreboard.write_counters(tr);
      `uvm_info(get_type_name(), $sformatf("Perf counters write is: %0d", tr.counters), UVM_MEDIUM)
    endtask
  endclass : perf_counters_test_seq

  typedef struct {
    int unsigned counters;
  } perf_counters_transactions;

endpackage : perf_counters_pkg
```

## UVM Test Code
```systemverilog
module tb;
  import uvm_pkg::*;
  import perf_counters_pkg::*;

  initial begin
    uvm_component_top top = uvm_component_top::get();
    perf_counters_test test = perf_counters_test::type_id::create("test", top);

    uvm_config_db#(uvm_object_wrapper)::set(null, "uvm_test_top.env.agent.sequencer.default_sequence", "default_sequence", perf_counters_test_seq::type_id::get());

    run_test();
  end
endmodule
```

The above code builds a test bench called `perf_counters_agent` containing a `perf_counters_scoreboard` and `perf_counters_test_seq`. The `perf_counters_scoreboard` component observes the performance counters output by the DUT, and verifies that it matches a set of testcases from `perf_counters_test_seq`.

In the `perf_counters_test_seq` class, we can define the test sequence. We can set the `perf_counters_transactions` and write it to the analysis port of the scoreboard. 

Finally, the above modules can be initialized and run in the UVM test code, where we can set the testcases.