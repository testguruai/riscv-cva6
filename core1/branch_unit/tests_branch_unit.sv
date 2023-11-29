// VerifAI TestGuru
// tests for: branch_unit.sv

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

    branch_unit dut (
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
        always @ (posedge clk) begin
            clk = ~clk;
        end

        rst = 1'b1;
        debug_mode = 1'b0;
        fu_data = '0;
        pc = '0;
        is_compressed_instr = 1'b0;
        fu_valid = 1'b0;
        branch_valid = 1'b0;
        branch_comp_res = 1'b0;
        branch_result = '0;

        branch_predict = '{cf: ariane_pkg::NoCF, predict_address: '0};
        resolved_branch = '{target_address: '0, is_taken: 1'b0, valid: 1'b0, is_mispredict: 1'b0, cf_type: ariane_pkg::NoCF};
        resolve_branch = 1'b0;
        branch_exception = '{cause: riscv::INSTR_ADDR_MISALIGNED, valid: 1'b0, tval: '0};

        @(posedge clk) #100;
        rst = 1'b0;

        @(posedge clk) #100;
        fu_data = '{operator: ariane_pkg::ADDI, operand_a: '0, operand_b: '0, imm: '0};
        pc = '0;
        is_compressed_instr = 1'b0;
        fu_valid = 1'b1;
        branch_valid = 1'b0;
        branch_comp_res = 1'b0;
        branch_result = '0;

        @(posedge clk) #100;
        fu_data = '{operator: ariane_pkg::JALR, operand_a: '0, operand_b: '0, imm: '0};
        pc = '0;
        is_compressed_instr = 1'b0;
        fu_valid = 1'b1;
        branch_valid = 1'b0;
        branch_comp_res = 1'b0;
        branch_result = '0;

        @(posedge clk) #100;
        fu_data = '{operator: ariane_pkg::BEQ, operand_a: '0, operand_b: '0, imm: '0};
        pc = '0;
        is_compressed_instr = 1'b0;
        fu_valid = 1'b1;
        branch_valid = 1'b0;
        branch_comp_res = 1'b0;
        branch_result = '0;

        @(posedge clk) #100;
        fu_data = '{operator: ariane_pkg::BNE, operand_a: '0, operand_b: '0, imm: '0};
        pc = '0;
        is_compressed_instr = 1'b0;
        fu_valid = 1'b1;
        branch_valid = 1'b0;
        branch_comp_res = 1'b0;
        branch_result = '0;
    end

endmodule
