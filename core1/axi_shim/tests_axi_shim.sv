// VerifAI TestGuru
// tests for: axi_shim.sv

module axi_shim_tb;
  parameter int unsigned AxiUserWidth = 64; // data width in dwords, this is also the maximum burst length, must be >=2
  parameter int unsigned AxiNumWords = 4; // data width in dwords, this is also the maximum burst length, must be >=2
  parameter int unsigned AxiAddrWidth = 32;
  parameter int unsigned AxiDataWidth = 64;
  parameter int unsigned AxiIdWidth   = 8;

  // clock
  logic clk;
  logic rst_ni;

  // AXI interface
  axi_req_t axi_req;
  axi_rsp_t axi_resp;

  // AXI adapter
  axi_shim #(
    AxiUserWidth,
    AxiNumWords,
    AxiAddrWidth,
    AxiDataWidth,
    AxiIdWidth
  ) axi_adapter(
    .clk_i(clk),
    .rst_ni(rst_ni),
    // read channel
    .rd_req_i(1'b0),
    .rd_gnt_o(),
    .rd_addr_i(1'b0),
    .rd_blen_i(1'b0),
    .rd_size_i(1'b0),
    .rd_id_i(1'b0),
    .rd_lock_i(1'b0),
    // read response
    .rd_rdy_i(1'b0),
    .rd_last_o(),
    .rd_valid_o(),
    .rd_data_o(),
    .rd_user_o(),
    .rd_id_o(),
    .rd_exokay_o(),
    // write channel
    .wr_req_i(1'b0),
    .wr_gnt_o(),
    .wr_addr_i(1'b0),
    .wr_data_i(1'b0),
    .wr_user_i(1'b0),
    .wr_be_i(1'b0),
    .wr_blen_i(1'b0),
    .wr_size_i(1'b0),
    .wr_id_i(1'b0),
    .wr_lock_i(1'b0),
    // write response
    .wr_valid_o(),
    .wr_id_o(),
    .wr_exokay_o()
  );

  // testbench
  initial begin
    // set clock
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  // reset
  initial begin
    rst_ni = 1'b1;
    #20 rst_ni = 1'b0;
  end

endmodule
