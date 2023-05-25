# VerifAI TestGuru
# Explanation for: id_stage.sv
# UVM Test Bench and UVM Test Code for ID Stage

The ID Stage of the design under test is responsible for instruction decoding, issue, and read operands. In this section, we will write a UVM Test Bench and UVM Test Code for the ID Stage.

## UVM Test Bench

The UVM Test Bench consists of a sequence, driver, monitor, and scoreboard. The sequence generates the stimulus, the driver converts the stimulus into signals, and the monitor records the signals at the output of the ID Stage. The scoreboard verifies the expected output against the actual output.

```systemverilog
`include "uvm_macros.svh"

module id_stage_tb;

  import uvm_pkg::*;

  // Interface signals
  logic clk_i;
  logic rst_ni;
  logic flush_i;
  logic debug_req_i;
  ariane_pkg::fetch_entry_t fetch_entry_i;
  logic fetch_entry_valid_i;
  logic fetch_entry_ready_o;
  ariane_pkg::scoreboard_entry_t issue_entry_o;
  logic issue_entry_valid_o;
  logic is_ctrl_flow_o;
  logic issue_instr_ack_i;
  riscv::priv_lvl_t priv_lvl_i;
  riscv::xs_t fs_i;
  logic [2:0] frm_i;
  logic [1:0] irq_i;
  ariane_pkg::irq_ctrl_t irq_ctrl_i;
  logic debug_mode_i;
  logic tvm_i;
  logic tw_i;
  logic tsr_i;

  // DUT Instance
  id_stage id_stage_i (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .flush_i(flush_i),
    .debug_req_i(debug_req_i),
    .fetch_entry_i(fetch_entry_i),
    .fetch_entry_valid_i(fetch_entry_valid_i),
    .fetch_entry_ready_o(fetch_entry_ready_o),
    .issue_entry_o(issue_entry_o),
    .issue_entry_valid_o(issue_entry_valid_o),
    .is_ctrl_flow_o(is_ctrl_flow_o),
    .issue_instr_ack_i(issue_instr_ack_i),
    .priv_lvl_i(priv_lvl_i),
    .fs_i(fs_i),
    .frm_i(frm_i),
    .irq_i(irq_i),
    .irq_ctrl_i(irq_ctrl_i),
    .debug_mode_i(debug_mode_i),
    .tvm_i(tvm_i),
    .tw_i(tw_i),
    .tsr_i(tsr_i)
  );

  // Sequence Instance
  id_stage_seq id_seq;

  // Driver Instance
  id_stage_driver id_driver (
    .clk_i(clk_i),
    .fetch_entry_i(fetch_entry_i),
    .fetch_entry_valid_i(fetch_entry_valid_i),
    .issue_instr_ack_i(issue_instr_ack_i)
  );

  // Monitor Instance
  id_stage_monitor id_monitor (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .flush_i(flush_i),
    .debug_req_i(debug_req_i),
    .fetch_entry_i(fetch_entry_i),
    .fetch_entry_valid_i(fetch_entry_valid_i),
    .fetch_entry_ready_o(fetch_entry_ready_o),
    .issue_entry_o(issue_entry_o),
    .issue_entry_valid_o(issue_entry_valid_o),
    .is_ctrl_flow_o(is_ctrl_flow_o),
    .issue_instr_ack_i(issue_instr_ack_i),
    .priv_lvl_i(priv_lvl_i),
    .fs_i(fs_i),
    .frm_i(frm_i),
    .irq_i(irq_i),
    .irq_ctrl_i(irq_ctrl_i),
    .debug_mode_i(debug_mode_i),
    .tvm_i(tvm_i),
    .tw_i(tw_i),
    .tsr_i(tsr_i),
    .seq_item_port(id_seq.seq_item_export)
  );

  // Scoreboard Instance
  id_stage_scoreboard id_scoreboard;

  initial begin
    // Set default values to the interface signals
    clk_i = 0;
    rst_ni = 0;
    flush_i = 0;
    debug_req_i = 0;
    fetch_entry_i = 0;
    fetch_entry_valid_i = 0;
    fetch_entry_ready_o = 0;
    issue_entry_o = 0;
    issue_entry_valid_o = 0;
    is_ctrl_flow_o = 0;
    issue_instr_ack_i = 0;
    priv_lvl_i = 0;
    fs_i = 0;
    frm_i = 0;
    irq_i = 0;
    irq_ctrl_i = 0;
    debug_mode_i = 0;
    tvm_i = 0;
    tw_i = 0;
    tsr_i = 0;

    // Start the test sequence
    id_seq = id_stage_seq::type_id::create("id_seq");
    assert(id_seq.randomize());

    // Run the test
    run_test();

  end

endmodule
```

## UVM Test Code

The following code describes the sequence and scoreboard for the ID Stage.

```systemverilog
`include "uvm_macros.svh"

class id_stage_seq extends uvm_sequence#(ariane_pkg::fetch_entry_t);

  `uvm_object_utils(id_stage_seq)

  virtual task body();
    // Create a sequence item
    ariane_pkg::fetch_entry_t req;

    for (int i=0; i<10; i++) begin
      assert(req.randomize());
      // Send the sequence item
      if (!req.address) begin
        req.address = 64'hff0;
      end
      send(req);
      wait(randomize(1, 10));
    end
  endtask

endclass : id_stage_seq

class id_stage_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(id_stage_scoreboard)

  bit match;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void compare_item(uvm_object subst);
    super.compare_item(subst);
    if(subst.issue_entry_valid_o) begin
      match = ((subst.issue_entry_o.opcode) == ariane_pkg::ARIANE_INST_OPCODE_SW);
      if (!match) begin
        `uvm_error("ID_STAGE_SCOREBOARD", "Error: Opcode does not match expected value.")
      end
    end
  endfunction

endclass : id_stage_scoreboard
```