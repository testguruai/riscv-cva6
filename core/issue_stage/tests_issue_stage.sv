# VerifAI TestGuru
# Explanation for: issue_stage.sv
## UVM Test Bench and Test Case for issue_stage Module

The `issue_stage` module is responsible for dispatching instructions to the functional units (FUs) and keeping track of them in a scoreboard like data-structure. In order to verify the functionality of this module, we need a UVM test bench and a test case. 

### Test Bench

The UVM test bench for the `issue_stage` module includes the following components:
- `test` - the test case
- `env` - the environment, which instantiates the `issue_stage` module and provides the necessary stimulus and checking
- `scoreboard` - a passive monitor that checks the outputs of the `issue_stage` module against the expected results

```systemverilog
`timescale 1ns/1ps

module issue_stage_tb;

    import uvm_pkg::*;
    import ariane_pkg::*;
    `include "uvm_macros.svh"

    parameter NR_ENTRIES = 8;
    parameter NR_WB_PORTS = 4;
    parameter NR_COMMIT_PORTS = 2;

    // Interface signals
    logic clk_i, rst_ni, sb_full_o, flush_unissued_instr_i, flush_i;
    scoreboard_entry_t decoded_instr_i, commit_instr_o[NR_COMMIT_PORTS];
    logic decoded_instr_valid_i, is_ctrl_flow_i, decoded_instr_ack_o;
    logic [riscv::VLEN-1:0] rs1_forwarding_o, rs2_forwarding_o;
    fu_data_t fu_data_o;
    logic [riscv::VLEN-1:0] pc_o;
    logic is_compressed_instr_o;
    logic flu_ready_i, alu_valid_o, resolve_branch_i, lsu_ready_i, lsu_valid_o, branch_valid_o;
    branchpredict_sbe_t branch_predict_o;
    logic mult_valid_o, fpu_ready_i, fpu_valid_o;
    logic [1:0] fpu_fmt_o;
    logic [2:0] fpu_rm_o;
    logic csr_valid_o;
    logic x_issue_valid_o, x_issue_ready_i, x_we_i;
    logic [31:0] x_off_instr_o;
    logic [NR_WB_PORTS-1:0][TRANS_ID_BITS-1:0] trans_id_i;
    bp_resolve_t resolved_branch_i;
    logic [NR_WB_PORTS-1:0][riscv::XLEN-1:0] wbdata_i;
    exception_t [NR_WB_PORTS-1:0] ex_ex_i;
    logic [NR_WB_PORTS-1:0] wt_valid_i;
    logic [NR_COMMIT_PORTS-1:0][4:0] waddr_i;
    logic [NR_COMMIT_PORTS-1:0][riscv::XLEN-1:0] wdata_i;
    logic [NR_COMMIT_PORTS-1:0] we_gpr_i, we_fpr_i;
    input [riscv::VLEN-1:0] lsu_addr_i;
    input [(riscv::XLEN/8)-1:0] lsu_rmask_i;
    input [(riscv::XLEN/8)-1:0] lsu_wmask_i;
    input [TRANS_ID_BITS-1:0] lsu_addr_trans_id_i;

    // UVM components
    uvm_env              env;
    uvm_scoreboard #(
        .NR_COMMIT_PORTS ( NR_COMMIT_PORTS )
    ) scoreboard_inst();

    // Clock generation
    initial clk_i = 0;
    always #5 clk_i = ~clk_i;

    // Reset generation
    initial begin
        rst_ni = 0;
        #20;
        rst_ni = 1;
    end

    // UVM configuration
    initial begin
        `uvm_info("ISSUE_STAGE_TB", "Start test", UVM_LOW)
        run_test();
        `uvm_info("ISSUE_STAGE_TB", "End test", UVM_LOW)
    end

endmodule
```

### Test Case

The `test` case is responsible for configuring the environment and running the test. In this case, we will use the UVM `run_test()` function to execute the test. The test will instantiate the `issue_stage` module and provide the necessary stimuli, as well as check the expected results.

```systemverilog
class test extends uvm_test;
    `uvm_component_param_utils(test)

    // Environment
    issue_stage_env env;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // UVM phases
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TEST", "Build phase", UVM_LOW)

        // Environment
        env = issue_stage_env::type_id::create("env", this);
        assert(env != null);

        // Configurations
        uvm_config_db #(virtual scoreboard #(NR_COMMIT_PORTS))::set(this, "", "sb", env.scoreboard_inst);

        // Connections
        env.clk_i(clk_i);
        env.rst_ni(rst_ni);
        env.sb_full_o(sb_full_o);
        env.flush_unissued_instr_i(flush_unissued_instr_i);
        env.flush_i(flush_i);
        env.decoded_instr_i(decoded_instr_i);
        env.decoded_instr_valid_i(decoded_instr_valid_i);
        env.is_ctrl_flow_i(is_ctrl_flow_i);
        env.decoded_instr_ack_o(decoded_instr_ack_o);
        env.rs1_forwarding_o(rs1_forwarding_o);
        env.rs2_forwarding_o(rs2_forwarding_o);
        env.fu_data_o(fu_data_o);
        env.pc_o(pc_o);
        env.is_compressed_instr_o(is_compressed_instr_o);
        env.flu_ready_i(flu_ready_i);
        env.alu_valid_o(alu_valid_o);
        env.resolve_branch_i(resolve_branch_i);
        env.branch_valid_o(branch_valid_o);
        env.branch_predict_o(branch_predict_o);
        env.lsu_ready_i(lsu_ready_i);
        env.lsu_valid_o(lsu_valid_o);
        env.mult_valid_o(mult_valid_o);
        env.fpu_ready_i(fpu_ready_i);
        env.fpu_valid_o(fpu_valid_o);
        env.fpu_fmt_o(fpu_fmt_o);
        env.fpu_rm_o(fpu_rm_o);
        env.csr_valid_o(csr_valid_o);
        env.x_issue_valid_o(x_issue_valid_o);
        env.x_issue_ready_i(x_issue_ready_i);
        env.x_off_instr_o(x_off_instr_o);
        env.trans_id_i(trans_id_i);
        env.resolved_branch_i(resolved_branch_i);
        env.wbdata_i(wbdata_i);
        env.ex_ex_i(ex_ex_i);
        env.wt_valid_i(wt_valid_i);
        env.x_we_i(x_we_i);
        env.waddr_i(waddr_i);
        env.wdata_i(wdata_i);
        env.we_gpr_i(we_gpr_i);
        env.we_fpr_i(we_fpr_i);
        env.lsu_addr_i(lsu_addr_i);
        env.lsu_rmask_i(lsu_rmask_i);
        env.lsu_wmask_i(lsu_wmask_i);
        env.lsu_addr_trans_id_i(lsu_addr_trans_id_i);

        // Monitors
        scoreboard_inst.port.bind(env.commit_instr_o);
        scoreboard_inst.commit_ack_i.bind(env.commit_ack_i);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TEST", "End of elaboration phase", U