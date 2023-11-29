 // VerifAI TestGuru
 // tests for: id_stage.sv

module id_stage_tb;

    logic clk, rst_ni;
    logic flush_i;
    logic debug_req_i;
    ariane_pkg::fetch_entry_t fetch_entry_i;
    logic fetch_entry_valid_i;
    logic fetch_entry_ready_o;
    ariane_pkg::scoreboard_entry_t issue_entry_o;
    logic issue_entry_valid_o;
    logic is_ctrl_flow_o;
    logic issue_instr_ack_i;
    riscv::priv_lvl_t priv_lvl_i;
    riscv::xs_t fs_i;
    logic [2:0] frm_i;
    logic [1:0] irq_i;
    ariane_pkg::irq_ctrl_t irq_ctrl_i;
    logic debug_mode_i;
    logic tvm_i;
    logic tw_i;
    logic tsr_i;

    id_stage id_stage_i (
        .clk_i(clk),
        .rst_ni(rst_ni),
        .flush_i(flush_i),
        .debug_req_i(debug_req_i),
        .fetch_entry_i(fetch_entry_i),
        .fetch_entry_valid_i(fetch_entry_valid_i),
        .fetch_entry_ready_o(fetch_entry_ready_o),
        .issue_entry_o(issue_entry_o),
        .issue_entry_valid_o(issue_entry_valid_o),
        .is_ctrl_flow_o(is_ctrl_flow_o),
        .issue_instr_ack_i(issue_instr_ack_i),
        .priv_lvl_i(priv_lvl_i),
        .fs_i(fs_i),
        .frm_i(frm_i),
        .irq_i(irq_i),
        .irq_ctrl_i(irq_ctrl_i),
        .debug_mode_i(debug_mode_i),
        .tvm_i(tvm_i),
        .tw_i(tw_i),
        .tsr_i(tsr_i)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_ni = 1'b1;
        #10 rst_ni = 1'b0;

        // ------------------------------------------------
        // Test 1: Issue a simple instruction
        // ------------------------------------------------

        fetch_entry_i.instruction = 32'h0000006f;
        fetch_entry_valid_i = 1'b1;
        #10;
        assert(fetch_entry_ready_o == 1'b1);
        assert(issue_entry_valid_o == 1'b1);
        assert(issue_entry_o.instruction == 32'h0000006f);
        assert(issue_entry_o.is_ctrl_flow == 1'b0);

        // ------------------------------------------------
        // Test 2: Issue a branch instruction
        // ------------------------------------------------

        fetch_entry_i.instruction = 32'h000000b3;
        fetch_entry_valid_i = 1'b1;
        #10;
        assert(fetch_entry_ready_o == 1'b1);
        assert(issue_entry_valid_o == 1'b1);
        assert(issue_entry_o.instruction == 32'h000000b3);
        assert(issue_entry_o.is_ctrl_flow == 1'b1);

        // ------------------------------------------------
        // Test 3: Flush the pipeline
        // ------------------------------------------------

        flush_i = 1'b1;
        #10;
        assert(fetch_entry_ready_o == 1'b0);
        assert(issue_entry_valid_o == 1'b0);

        $finish;
    end
endmodule
