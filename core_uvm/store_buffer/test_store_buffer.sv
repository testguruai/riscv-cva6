
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: store_buffer.sv
// UVM Test Bench and Test Code for store_buffer.sv Verilog Code
// ==============================================================================
module tb_store_buffer import ariane_pkg::*;

  wire clk;
  wire rst_n;
  wire ready;
  wire store_buffer_empty;
  wire no_st_pending;
  wire page_offset_matches;
  wire commit_ready_o;
  wire req_port_o_data_req;
  
  logic flush;
  logic commit;
  logic valid;
  logic valid_without_flush;
  logic[11:0]   page_offset;
  logic[riscv::PLEN-1:0] paddr;
  riscv::xlen_t data;
  logic[(riscv::XLEN/8)-1:0] be;
  logic[1:0] data_size;
  
  wire[DCACHE_INDEX_WIDTH-1:0] D$IF_address_index;
  wire[DCACHE_TAG_WIDTH-1:0] D$IF_address_tag;
  dcache_req_o_t D$IF_req_o;
  dcache_req_i_t D$IF_req_i;
  
  store_buffer dut_store_buffer (
    .clk_i(clk),
    .rst_ni(rst_n),
    .flush_i(flush),
    .no_st_pending_o(no_st_pending),
    .store_buffer_empty_o(store_buffer_empty),
    .page_offset_matches_o(page_offset_matches),
    .valid_i(valid),
    .valid_without_flush_i(valid_without_flush),
    .data_i(data),
    .be_i(be),
    .data_size_i(data_size),
    .req_port_i(D$IF_req_i),
    .req_port_o(D$IF_req_o)
  );

  clockDriver v_clockDriver (/* pass the appropriate parameters as per your implementation */);
  resetDriver v_resetDriver (/* pass the appropriate parameters as per your implementation */);
  reqPortDriver v_reqPortDriver (clk, rst_n, req_port_i, /* pass the remaining parameters as per your implementation */);
  reqPortMonitor v_reqPortMonitor (clk,rst_n, req_port_o, /* pass the remaining parameters as per your implementation */);

  initial begin
    uvm_config_db #(virtual clockDriver)::set(null,"uvm_test_top","v_clockDriver",v_clockDriver);
    uvm_config_db #(virtual resetDriver)::set(null,"uvm_test_top","v_resetDriver",v_resetDriver);
    uvm_config_db #(virtual reqPortDriver)::set(null,"uvm_test_top","v_reqPortDriver",v_reqPortDriver);
    uvm_config_db #(virtual reqPortMonitor)::set(null,"uvm_test_top","v_reqPortMonitor",v_reqPortMonitor);
  end  

endmodule
