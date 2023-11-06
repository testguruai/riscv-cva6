# VerifAI TestGuru
# tests for: branch_unit.sv
```
module branch_unit_tb;

    logic clk;
    logic rst;
    logic debug_mode;
    ariane_pkg::fu_data_t fu_data;
    logic [riscv::VLEN-1:0] pc;
    logic is_compressed_instr;
    logic fu_valid;
    logic branch_valid;
    logic branch_comp_res;
    logic [riscv::VLEN-1:0] branch_result;

    ariane_pkg::branchpredict_sbe_t branch_predict;
    ariane_pkg::bp_resolve_t resolved_branch;
    logic resolve_branch;
    ariane_pkg::exception_t branch_exception;

    branch_unit dut(
        .clk_i(clk),
        .rst_ni(rst),
        .debug_mode_i(debug_mode),
        .fu_data_i(fu_data),
        .pc_i(pc),
        .is_compressed_instr_i(is_compressed_instr),
        .fu_valid_i(fu_valid),
        .branch_valid_i(branch_valid),
        .branch_comp_res_i(branch_comp_res),
        .branch_result_o(branch_result),

        .branch_predict_i(branch_predict),
        .resolved_branch_o(resolved_branch),
        .resolve_branch_o(resolve_branch),
        .branch_exception_o(branch_exception)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        #10 rst = 1'b0;

        // set up some test data
        fu_data = '{
            operator: riscv::JALR,
            operand_a: 'h00000000,
            operand_b: 'h00000000,
            operand_c: 'h00000000
        };
        pc = 'h00000000;
        is_compressed_instr = 1'b0;
        fu_valid = 1'b1;
        branch_valid = 1'b1;
        branch_comp_res = 1'b1;
        branch_predict = '{
            cf: riscv::Branch,
            predict_address: 'h00000004
        };

        #100;

        // check results
        $display("branch_result = %x", branch_result);
        $display("resolved_branch.target_address = %x", resolved_branch.target_address);
        $display("resolved_branch.is_taken = %b", resolved_branch.is_taken);
        $display("resolved_branch.valid = %b", resolved_branch.valid);
        $display("resolved_branch.is_mispredict = %b", resolved_branch.is_mispredict);
        $display("resolved_branch.cf_type = %d", resolved_branch.cf_type);
        $display("branch_exception.cause = %d", branch_exception.cause);
        $display("branch_exception.valid = %b", branch_exception.valid);
        $display("branch_exception.tval = %x", branch_exception.tval);

        $finish;
    end
endmodule
```