# VerifAI TestGuru
# tests for: ariane.sv
```
module ariane_tb;

  // Clock and reset
  logic clk;
  logic rst_ni;

  // Inputs
  logic [riscv::VLEN-1:0] boot_addr_i;
  logic [riscv::XLEN-1:0] hart_id_i;
  logic [1:0] irq_i;
  logic ipi_i;
  logic time_irq_i;
  logic debug_req_i;

  // Outputs
  traced_instr_pkg::trace_port_t trace_o;
  ariane_rvfi_pkg::rvfi_port_t rvfi_o;
  wt_cache_pkg::l15_req_t l15_req_o;
  wt_cache_pkg::l15_rtrn_t l15_rtrn_i;
  ariane_axi::req_t axi_req_o;
  ariane_axi::resp_t axi_resp_i;

  // Instantiate the DUT
  ariane #(
    .ArianeCfg ( ArianeDefaultConfig )
  ) dut (
    .clk_i ( clk ),
    .rst_ni ( rst_ni ),
    .boot_addr_i ( boot_addr_i ),
    .hart_id_i ( hart_id_i ),
    .irq_i ( irq_i ),
    .ipi_i ( ipi_i ),
    .time_irq_i ( time_irq_i ),
    .debug_req_i ( debug_req_i ),
    .trace_o ( trace_o ),
    .rvfi_o ( rvfi_o ),
    .l15_req_o ( l15_req_o ),
    .l15_rtrn_i ( l15_rtrn_i ),
    .axi_req_o ( axi_req_o ),
    .axi_resp_i ( axi_resp_i )
  );

  // Testbench
  initial begin
    // Initialize the DUT
    clk = 0;
    rst_ni = 1;
    #10;
    rst_ni = 0;

    // Generate test stimulus
    #100;
    boot_addr_i = 'h0;
    hart_id_i = 'h0;
    irq_i = 'b0;
    ipi_i = 0;
    time_irq_i = 0;
    debug_req_i = 0;

    // Run the simulation
    #10000000;
  end

endmodule
```