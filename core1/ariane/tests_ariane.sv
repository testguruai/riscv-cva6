// VerifAI TestGuru
// tests for: ariane.sv

`include "ariane.sv"

module ariane_tb;

  logic clk;
  logic rst_n;
  logic [31:0] boot_addr_i;
  logic [63:0] hart_id_i;

  // Interrupt inputs
  logic [1:0] irq_i;
  logic ipi_i;
  // Timer facilities
  logic time_irq_i;
  logic debug_req_i;
`ifdef FIRESIM_TRACE
  // firesim trace port
  traced_instr_pkg::trace_port_t trace_o;
`endif
`ifdef RVFI_TRACE
  // RISC-V formal interface port (`rvfi`):
  // Can be left open when formal tracing is not needed.
  ariane_rvfi_pkg::rvfi_port_t rvfi_o;
`endif
`ifdef PITON_ARIANE
  // L15 (memory side)
  wt_cache_pkg::l15_req_t l15_req_o;
  wt_cache_pkg::l15_rtrn_t l15_rtrn_i;
`else
  // memory side, AXI Master
  ariane_axi::req_t axi_req_o;
  ariane_axi::resp_t axi_resp_i;
`endif

  // Instantiate DUT
  ariane dut (
    .clk_i(clk),
    .rst_ni(rst_n),
    .boot_addr_i(boot_addr_i),
    .hart_id_i(hart_id_i),
    .irq_i(irq_i),
    .ipi_i(ipi_i),
    .time_irq_i(time_irq_i),
    .debug_req_i(debug_req_i),
`ifdef FIRESIM_TRACE
    .trace_o(trace_o),
`endif
`ifdef RVFI_TRACE
    .rvfi_o(rvfi_o),
`endif
`ifdef PITON_ARIANE
    .l15_req_o(l15_req_o),
    .l15_rtrn_i(l15_rtrn_i),
`else
    .axi_req_o(axi_req_o),
    .axi_resp_i(axi_resp_i),
`endif
  );

  // Testbench
  initial begin
    // Initialize all signals
    clk = 0;
    rst_n = 1;
    boot_addr_i = 0;
    hart_id_i = 0;
    irq_i = 0;
    ipi_i = 0;
    time_irq_i = 0;
    debug_req_i = 0;
`ifdef FIRESIM_TRACE
    trace_o = '0;
`endif
`ifdef RVFI_TRACE
    rvfi_o = '0;
`endif
`ifdef PITON_ARIANE
    l15_req_o = '0;
    l15_rtrn_i = '0;
`else
    axi_req_o = '0;
    axi_resp_i = '0;
`endif

    // Wait for reset to finish
    #10;
    rst_n = 0;

    // Start simulation
    forever begin
      clk = ~clk;
      #1;
    end
  end

endmodule
