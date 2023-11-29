// VerifAI TestGuru
// tests for: amo_buffer.sv
module TestGuru;
  import uvm_pkg::*;

  `include "uvm_macros.svh"

  class amo_buffer_test_module extends uvm_test;
    `uvm_component_utils(amo_buffer_test_module)

    virtual amo_buffer amo_buf;

    // Define input and output ports

    logic clk;
    logic rstn;
    logic flush;

    logic valid;
    logic ready;
    ariane_pkg::amo_t amo_op;
    logic [riscv::PLEN-1:0] paddr;
    riscv::xlen_t data;
    logic [1:0] data_size;

    ariane_pkg::amo_req_t amo_req;
    ariane_pkg::amo_resp_t amo_resp;

    logic amo_valid_commit;
    logic no_st_pending;

    task new(string name, uvm_component parent);
      super.new(name, parent);
    endtask
    
    task build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Create and connect UUT

      amo_buf = new("amo_buffer", null);

      amo_buf.clk_i = clk;
      amo_buf.rst_ni = rstn;
      amo_buf.flush_i = flush;
      amo_buf.valid_i = valid;
      amo_buf.ready_o = ready;
      amo_buf.amo_op_i = amo_op;
      amo_buf.paddr_i = paddr;
      amo_buf.data_i = data;
      amo_buf.data_size_i = data_size;
      amo_buf.amo_req_o = amo_req;
      amo_buf.amo_resp_i = amo_resp;
      amo_buf.amo_valid_commit_i = amo_valid_commit;
      amo_buf.no_st_pending_i = no_st_pending;
    endtask

    task run_phase(uvm_phase phase);
      super.run_phase(phase);

      // Initialize input values

      clk = 0;
      rstn = 0;
      flush = 0;
      valid = 0;
      amo_op = ariane_pkg::NONE_AMO;
      paddr = 0;
      data = 0;
      data_size = 0;
      amo_resp = ariane_pkg::AMO_RESP_NONE;

      #10ns;

      // Assert reset

      rstn = 1;

      #10ns;

      // Toggle clock and drive inputs

      forever begin
        clk = ~clk;

        if (clk) begin
          valid = 1;
          amo_op = ariane_pkg::SWAP_AMO;
          paddr = 0x100;
          data = 0x1234;
          data_size = 1;
          amo_valid_commit = 1;
          no_st_pending = 1;
        end
        else begin
          valid = 0;
          amo_op = ariane_pkg::NONE_AMO;
          paddr = 0;
          data = 0;
          data_size = 0;
          amo_valid_commit = 0;
          no_st_pending = 0;
        end

        #5ns;
      end
    endtask
  endclass

initial begin
  amo_buffer_test_module test = amo_buffer_test_module::type_id::create("test");

  uvm_config_db#(virtual amo_buffer)::set(null, "test.env", "uut", test.amo_buf);

  run_test();
end

endmodule
