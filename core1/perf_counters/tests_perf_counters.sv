# VerifAI TestGuru
# tests for: perf_counters.sv
```
module perf_counters_tb;
  import ariane_pkg::*;

  logic clk, rst;
  logic debug_mode;
  logic [4:0] addr;
  logic we;
  logic [riscv::XLEN-1:0] data_i, data_o;
  logic [NR_COMMIT_PORTS-1:0] commit_instr;
  logic [NR_COMMIT_PORTS-1:0] commit_ack;
  logic l1_icache_miss, l1_dcache_miss;
  logic itlb_miss, dtlb_miss;
  logic sb_full;
  logic if_empty;
  logic ex_valid, ex_i;
  logic eret;
  bp_resolve_t resolved_branch;

  perf_counters #(
    .NR_COMMIT_PORTS(NR_COMMIT_PORTS)
  ) perf_counters (
    .clk_i(clk),
    .rst_ni(rst),
    .debug_mode_i(debug_mode),
    .addr_i(addr),
    .we_i(we),
    .data_i(data_i),
    .data_o(data_o),
    .commit_instr_i(commit_instr),
    .commit_ack_i(commit_ack),
    .l1_icache_miss_i(l1_icache_miss),
    .l1_dcache_miss_i(l1_dcache_miss),
    .itlb_miss_i(itlb_miss),
    .dtlb_miss_i(dtlb_miss),
    .sb_full_i(sb_full),
    .if_empty_i(if_empty),
    .ex_i(ex_i),
    .eret_i(eret),
    .resolved_branch_i(resolved_branch)
  );

  initial begin
    clk = 1'b0;
    rst = 1'b1;
    #10;
    rst = 1'b0;

    // write some data to the perf counters
    data_i = 'h00000000;
    we = 1'b1;
    addr = 'h00;
    #10;
    we = 1'b0;

    // read back the data
    data_o = 'b0;
    #10;

    // check that the data was written correctly
    assert(data_o == data_i);

    $stop;
  end

endmodule
```