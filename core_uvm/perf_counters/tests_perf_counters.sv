// VerifAI TestGuru
// tests for: perf_counters.sv
systemverilog

module test_perf_counters();
   // Declare signals
   logic clk;
   logic rst_ni;
   logic debug_mode_i;
   logic [4:0] addr_i;
   logic we_i;
   logic [31:0] data_i;
   logic [31:0] data_o;
   scoreboard_entry_t commit_instr_i [NR_COMMIT_PORTS-1:0];
   logic commit_ack_i [NR_COMMIT_PORTS-1:0];
   logic l1_icache_miss_i;
   logic l1_dcache_miss_i;
   logic itlb_miss_i;
   logic dtlb_miss_i;
   logic sb_full_i;
   logic if_empty_i;
   exception_t ex_i;
   logic eret_i;
   bp_resolve_t resolved_branch_i;

   // Instantiate the perf_counters module
   perf_counters perf(.clk_i(clk), 
                      .rst_ni(rst_ni),
                      .debug_mode_i(debug_mode_i),
                      .addr_i(addr_i), 
                      .we_i(we_i), 
                      .data_i(data_i), 
                      .data_o(data_o),
                      .commit_instr_i(commit_instr_i),
                      .commit_ack_i(commit_ack_i),
                      .l1_icache_miss_i(l1_icache_miss_i),
                      .l1_dcache_miss_i(l1_dcache_miss_i),
                      .itlb_miss_i(itlb_miss_i),
                      .dtlb_miss_i(dtlb_miss_i),
                      .sb_full_i(sb_full_i),
                      .if_empty_i(if_empty_i),
                      .ex_i(ex_i),
                      .eret_i(eret_i),
                      .resolved_branch_i(resolved_branch_i)
                    );

   // Initialize signals
   initial begin
      clk = 0;
      rst_ni = 0;
      debug_mode_i = 0;
      addr_i = 0;
      we_i = 0;
      data_i = 0;
      commit_instr_i = {default: scoreboard_entry_t};
      commit_ack_i = '0;
      l1_icache_miss_i = 0;
      l1_dcache_miss_i = 0;
      itlb_miss_i = 0;
      dtlb_miss_i = 0;
      sb_full_i = 0;
      if_empty_i = 0;
      ex_i = '0;
      eret_i = 0;
      resolved_branch_i = '0;

      // Test case 1
      #10;
      clk = 1;
      rst_ni = 1;
      l1_icache_miss_i = 1;
      commit_instr_i[0].fu = LOAD;
      commit_ack_i[0] = '1;
      #10;
      assert(data_o == 1'b1);
      #10;
      l1_dcache_miss_i = 1;
      commit_instr_i[1].fu = STORE;
      commit_ack_i[1] = '1;
      #10;
      assert(data_o == 1'b1);
      #10;
      itlb_miss_i = 1;
      commit_instr_i[2].fu = CTRL_FLOW;
      commit_ack_i[2] = '1;
      #10;
      assert(data_o == 1'b1);
      #10;
      dtlb_miss_i = 1;
      commit_instr_i[3].fu = CTRL_FLOW;
      commit_instr_i[3].op = JALR;
      commit_instr_i[3].rd = 1'b1;
      commit_ack_i[3] = '1;
      #10;
      assert(data_o == 1'b1);
      #10;
      sb_full_i = 1;
      #10;
      assert(data_o == 1'b1);
      #10;
      if_empty_i = 1;
      #10;
      assert(data_o == 1'b1);
      #10;
      
      // Test case 2
      l1_icache_miss_i = 0;
      l1_dcache_miss_i = 0;
      itlb_miss_i = 0;
      dtlb_miss_i = 0;
      sb_full_i = 0;
      if_empty_i = 0;
      #10;
      clk = 0;
      commit_ack_i = '0;
      #10;
      rst_ni = 0;
      debug_mode_i = 1;
      commit_ack_i = '1;
      #10;
      assert(data_o == 0);
      #10;
      clk = 1;
      rst_ni = 1;
      debug_mode_i = 0;
      commit_ack_i = '0;

      // Test case 3
      l1_icache_miss_i = 1;
      commit_ack_i[0] = '1;
      #10;
      assert(data_o == 1'b1);
      #10;
      l1_dcache_miss_i = 1;
      commit_ack_i[1] = '1;
      #10;
      assert(data_o == 1'b1);
      #10;
      itlb_miss_i = 1;
      commit_ack_i[2] = '1;
      #10;
      assert(data_o == 1'b1);
      #10;
      dtlb_miss_i = 1;
      commit_intr_i[3].fu = CTRL;
      commit_intr_i[3].op = JALR;
      commit_intr_i[3].rd = 1'b1;
      commit_ack_i[3] = '1;
      #10;
      assert(data_o == 1'b1);
      #10;
      sb_full_i = 1;
      #10;
      assert(data_o == 1'b1);
      #10;
      if_empty_i = 1;
      #10;
      assert(data_o == 1'b1);
      #10;
   end
endmodule
