# VerifAI TestGuru
# tests for: axi_shim.sv
```
module axi_shim_tb;

  // parameters
  parameter int unsigned AxiUserWidth = 64; // data width in dwords, this is also the maximum burst length, must be >=2
  parameter int unsigned AxiNumWords = 4; // data width in dwords, this is also the maximum burst length, must be >=2
  parameter int unsigned AxiAddrWidth = 0;
  parameter int unsigned AxiDataWidth = 0;
  parameter int unsigned AxiIdWidth   = 0;
  parameter type axi_req_t = ariane_axi::req_t;
  parameter type axi_rsp_t = ariane_axi::resp_t;

  // clock and reset
  logic clk;
  logic rst_ni;

  // AXI interface
  axi_req_t axi_req;
  axi_rsp_t axi_resp;

  // testbench
  initial begin
    // initialize the clock
    clk = 0;
    forever #5 clk = ~clk;

    // initialize the reset
    rst_ni = 1;
    #10 rst_ni = 0;

    // send a write request
    axi_req.aw.addr = 0;
    axi_req.aw.size = 2;
    axi_req.aw.len = 1;
    axi_req.aw.id = 0;
    axi_req.aw.prot = 0;
    axi_req.aw.region = 0;
    axi_req.aw.lock = 0;
    axi_req.aw.cache = 0;
    axi_req.aw.qos = 0;
    axi_req.aw.atop = 0;
    axi_req.aw.user = 0;
    axi_req.w.data = 0;
    axi_req.w.user = 0;
    axi_req.w.strb = 0;
    axi_req.w.last = 0;
    axi_req.b_ready = 1;

    // wait for the write response
    @(axi_resp.b_valid);

    // check the write response
    assert(axi_resp.b.resp == axi_pkg::RESP_EXOKAY);

    // send a read request
    axi_req.ar.addr = 0;
    axi_req.ar.size = 2;
    axi_req.ar.len = 1;
    axi_req.ar.id = 0;
    axi_req.ar.prot = 0;
    axi_req.ar.region = 0;
    axi_req.ar.lock = 0;
    axi_req.ar.cache = 0;
    axi_req.ar.qos = 0;
    axi_req.ar.user = 0;
    axi_req.ar_valid = 1;

    // wait for the read response
    @(axi_resp.r_valid);

    // check the read response
    assert(axi_resp.r.data == 0);

    // stop the simulation
    $stop;
  end

endmodule // axi_shim_tb
```