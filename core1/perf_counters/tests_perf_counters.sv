// VerifAI TestGuru
// tests for: perf_counters.sv

module perf_counters_tb;

  logic clk;
  logic rst;
  logic debug_mode;
  logic [4:0] addr;
  logic we;
  logic [31:0] data;
  logic [31:0] data_o;
  logic l1_icache_miss;
  logic l1_dcache_miss;
  logic itlb_miss;
  logic dtlb_miss;
  logic sb_full;
  logic if_empty;
  logic ex_valid;
  logic eret;
  logic resolved_branch_valid;
  logic resolved_branch_mispredict;

  logic [NR_COMMIT_PORTS-1:0] commit_instr;
  logic [NR_COMMIT_PORTS-1:0] commit_ack;

  perf_counters perf_counters(
    .clk_i(clk),
    .rst_ni(rst),
    .debug_mode_i(debug_mode),
    .addr_i(addr),
    .we_i(we),
    .data_i(data),
    .data_o(data_o),
    .commit_instr_i(commit_instr),
    .commit_ack_i(commit_ack),
    .l1_icache_miss_i(l1_icache_miss),
    .l1_dcache_miss_i(l1_dcache_miss),
    .itlb_miss_i(itlb_miss),
    .dtlb_miss_i(dtlb_miss),
    .sb_full_i(sb_full),
    .if_empty_i(if_empty),
    .ex_i(ex_valid),
    .eret_i(eret),
    .resolved_branch_i(resolved_branch_valid, resolved_branch_mispredict)
  );

  initial begin
    clk = 1'b0;
    rst = 1'b1;
    debug_mode = 1'b0;
    addr = 5'b0;
    we = 1'b0;
    data = 32'b0;
    data_o = 32'b0;
    l1_icache_miss = 1'b0;
    l1_dcache_miss = 1'b0;
    itlb_miss = 1'b0;
    dtlb_miss = 1'b0;
    sb_full = 1'b0;
    if_empty = 1'b0;
    ex_valid = 1'b0;
    eret = 1'b0;
    resolved_branch_valid = 1'b0;
    resolved_branch_mispredict = 1'b0;

    #100;
    rst = 1'b0;

    #100;
    l1_icache_miss = 1'b1;

    #100;
    l1_dcache_miss = 1'b1;

    #100;
    itlb_miss = 1'b1;

    #100;
    dtlb_miss = 1'b1;

    #100;
    sb_full = 1'b1;

    #100;
    if_empty = 1'b1;

    #100;
    ex_valid = 1'b1;

    #100;
    eret = 1'b1;

    #100;
    resolved_branch_valid = 1'b1;
    resolved_branch_mispredict = 1'b1;

    #100;
    \$stop;
  end

  always #5 clk = ~clk;

endmodule
