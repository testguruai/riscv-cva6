# VerifAI TestGuru
# Explanation for: amo_buffer.sv
## UVM Test Bench and Test Code for AMO Buffer

### AMO Buffer UVM Test Bench

```systemverilog
`timescale 1ns / 1ps

module amo_buffer_tb;

  import uvm_pkg::*;
  import riscv_pkg::*;
  import ariane_pkg::*;

  `include "uvm_macros.svh"

  logic clk = 0;
  logic rst_n = 0;
  logic flush = 0;
  logic amo_valid_commit = 0;
  logic no_st_pending = 0;

  logic valid;
  logic ready;
  amo_t amo_op;
  logic [PLEN-1:0] paddr;
  xlen_t data;
  logic [1:0] data_size;

  amo_buffer u_amo_buffer (

    .clk_i(clk),
    .rst_ni(rst_n),
    .flush_i(flush),

    .valid_i(valid),
    .ready_o(ready),
    .amo_op_i(amo_op),
    .paddr_i(paddr),
    .data_i(data),
    .data_size_i(data_size),

    .amo_req_o(amo_req),
    .amo_resp_i(amo_resp),

    .amo_valid_commit_i(amo_valid_commit),
    .no_st_pending_i(no_st_pending)

  );

  initial begin
    `UVM_INFO("AMO_BUFFER_TB","Start AMO Buffer test", UVM_INFO);
    #100;
    reset();
    await_test_completion();
  end

  task reset();
    rst_n = 0;
    valid = 0;
    ready = 0;
    await_cycles(10);
    rst_n = 1;
    await_cycles(10);
  endtask

  task await_cycles(input int n);
    repeat(n) @(posedge clk);
  endtask

  task await_test_completion();
    #1000;
    uvm_report_info("AMO_BUFFER_TB", $sformatf("TEST COMPLETED"), UVM_NONE);
  endtask

endmodule
```

### UVM Test Code

```systemverilog
class amo_buffer_test extends uvm_test;

  `uvm_component_param_utils(amo_buffer_test)

  virtual_unit virtual_dut;
  amo_buffer u_amo_buffer;

  logic clk;
  logic rst_n;
  logic flush;
  logic amo_valid_commit;
  logic no_st_pending;

  logic valid;
  logic ready;
  amo_t amo_op;
  logic [PLEN-1:0] paddr;
  xlen_t data;
  logic [1:0] data_size;

  amo_req_t amo_req;
  amo_resp_t amo_resp;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    virtual_dut = new("virtual_dut",this);
    u_amo_buffer = amo_buffer::type_id::create("u_amo_buffer",this);

  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    virtual_dut.clk_i.connect(u_amo_buffer.clk_i);
    virtual_dut.rst_ni.connect(u_amo_buffer.rst_ni);
    virtual_dut.flush_i.connect(u_amo_buffer.flush_i);

    virtual_dut.valid_i.connect(u_amo_buffer.valid_i);
    virtual_dut.ready_o.connect(u_amo_buffer.ready_o);
    virtual_dut.amo_op_i.connect(u_amo_buffer.amo_op_i);
    virtual_dut.paddr_i.connect(u_amo_buffer.paddr_i);
    virtual_dut.data_i.connect(u_amo_buffer.data_i);
    virtual_dut.data_size_i.connect(u_amo_buffer.data_size_i);

    virtual_dut.amo_req_o.connect(u_amo_buffer.amo_req_o);
    virtual_dut.amo_resp_i.connect(u_amo_buffer.amo_resp_i);

    virtual_dut.amo_valid_commit_i.connect(u_amo_buffer.amo_valid_commit_i);
    virtual_dut.no_st_pending_i.connect(u_amo_buffer.no_st_pending_i);

  endfunction : connect_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    repeat(10) @(posedge virtual_dut.clk_i);

    // Test AMO Buffer with valid request
    `uvm_info("amo_buffer_test", "Testing AMO buffer with valid request", UVM_HIGH)
    init_test();
    get_amo_info(ARITH_SHIFT_LEFT);
    send_valid_request();
    get_amo_response();
    wait_ready_signal();
    reset();
    check_output();

    // Test AMO Buffer with invalid request - unsupported size
    `uvm_info("amo_buffer_test", "Testing AMO buffer with invalid request - unsupported size", UVM_HIGH)
    init_test();
    get_amo_info(ATOMIC_AND);
    send_invalid_size_request();
    wait_ready_signal();
    reset();

    // Test AMO Buffer with flush
    `uvm_info("amo_buffer_test", "Testing AMO buffer with flush", UVM_HIGH)
    init_test();
    get_amo_info(ARITH_SHIFT_RIGHT);
    send_valid_request();
    get_amo_response();
    wait_ready_signal();
    do_flush();
    check_flush();

  endtask : run_phase

  virtual task init_test();
    clk = 0;
    rst_n = 0;
    flush = 0;
    amo_valid_commit = 0;
    no_st_pending = 0;

    valid = 0;
    ready = 0;
    amo_op = 0;
    paddr = 0;
    data = 0;
    data_size = 0;

    amo_req = 0;
    amo_resp = 0;

    reset();
    #100;
  endtask : init_test

  virtual task get_amo_info(input amo_t op);
    amo_op = op;
    paddr = X"8000_0000";
    data = 0b1000000001;
    data_size = 1;
  endtask : get_amo_info

  virtual task send_valid_request();
    valid = 1;
    repeat(10) @(posedge clk);
    valid = 0;
  endtask : send_valid_request

  virtual task send_invalid_size_request();
    valid = 1;
    data_size = 2;
    repeat(10) @(posedge clk);
    data_size = 0;
    valid = 0;
  endtask : send_invalid_size_request

  virtual task get_amo_response();
    // wait for response_ack
    do begin
      repeat(10) @(posedge virtual_dut.clk_i);
    end while(!amo_resp.ack);
  endtask : get_amo_response

  virtual task wait_ready_signal();
    // wait for ready signal to be asserted
    do begin
      repeat(10) @(posedge virtual_dut.clk_i);
    end while(!virtual_dut.ready_o);
  endtask : wait_ready_signal

  virtual task do_flush();
    flush = 1;
    repeat(10) @(posedge virtual_dut.clk_i);
    flush =0;
  endtask : do_flush

  virtual task check_output();
    if(amo_op != amo_req.amo_op) `uvm_error("amo_buffer_test", "Expected and Actual AMO_OP mismatch")
    if(paddr != amo_req.operand_a[PLEN-1:0]) `uvm_error("amo_buffer_test", "Expected and Actual PADDR mismatch")
    if(data != amo_req.operand_b[XLEN-1:0]) `uvm_error("amo_buffer_test", "Expected and Actual DATA mismatch")
    if(data_size != amo_req.size) `uvm_error("amo_buffer_test", "Expected and Actual REQ_SIZE mismatch")
  endtask : check_output

  virtual task check_flush();
    if(valid != 0) `uvm_error("amo_buffer_test", "FLUSH did not perform as expected")
  endtask : check_flush

  virtual task reset();
    rst_n = 0;
    await_cycles(10);
    rst_n = 1;
    await_cycles(10);
  endtask : reset

  virtual task await_cycles(input int n);
    repeat(n) @(posedge virtual_dut.clk_i);
  endtask : await_cycles

endclass : amo_buffer_test
```