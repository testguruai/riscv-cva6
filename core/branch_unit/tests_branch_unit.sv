# VerifAI TestGuru
# Explanation for: branch_unit.sv
### Test Bench and Test Code for Branch Unit Verilog Code

The `branch_unit` Verilog code presented implements the main logic for calculating branch and jump targets and resolving branch mis-predictions. To verify the correctness of this module we will create a test bench that will test the output of each individual block within the `branch_unit` module.

```verilog
module branch_unit_tb();
    // Inputs
    logic                      clk_i;
    logic                      rst_ni;
    logic                      debug_mode_i;
    ariane_pkg::fu_data_t      fu_data_i;
    logic [riscv::VLEN-1:0]    pc_i;
    logic                      is_compressed_instr_i;
    logic                      fu_valid_i;
    logic                      branch_valid_i;
    logic                      branch_comp_res_i;
    ariane_pkg::branchpredict_sbe_t        branch_predict_i;

    // Outputs
    logic [riscv::VLEN-1:0]    branch_result_o;
    ariane_pkg::bp_resolve_t   resolved_branch_o;
    logic                      resolve_branch_o;
    ariane_pkg::exception_t    branch_exception_o;

    branch_unit dut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .debug_mode_i(debug_mode_i),
        .fu_data_i(fu_data_i),
        .pc_i(pc_i),
        .is_compressed_instr_i(is_compressed_instr_i),
        .fu_valid_i(fu_valid_i),
        .branch_valid_i(branch_valid_i),
        .branch_comp_res_i(branch_comp_res_i),
        .branch_predict_i(branch_predict_i),
        .branch_result_o(branch_result_o),
        .resolved_branch_o(resolved_branch_o),
        .resolve_branch_o(resolve_branch_o),
        .branch_exception_o(branch_exception_o)
    );

    // Test cases go here
    // ...

    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end
endmodule
```

In the test bench we only instantiate the `branch_unit` module and connect its inputs and outputs with the signals defined in the test bench. We will now create test cases to verify the output of the `mispredict_handler` and `exception_handling` blocks within the `branch_unit` module.

```verilog
// Test case 1
// Test correct branch prediction
initial begin
    // Input values
    clk_i = 1'b0;
    rst_ni = 1'b1;
    debug_mode_i = 1'b0;
    fu_data_i = '{
        .operator       = ariane_pkg::BEQ,
        .operand_a      = 32'hAAAAFFFF,
        .operand_b      = 32'h00000000,
        .imm            = 32'h00000000,
        .srca_mux       = ariane_pkg::PC,
        .srcb_mux       = ariane_pkg::REG,
        .waddr_mux      = ariane_pkg::NPC,
        .wb             = ariane_pkg::WB_DISABLE
    };
    pc_i = 32'h0000_0000;
    is_compressed_instr_i = 1'b0;
    fu_valid_i = 1'b1;
    branch_valid_i = 1'b1;
    branch_comp_res_i = 1'b1;
    branch_predict_i = '{ 
        .cf              = ariane_pkg::NoCF,
        .predict_address = 32'hAAAAFFFF 
    };

    // Expected output values
    branch_result_o = 32'h0000_0004;
    resolved_branch_o = '{ 
        .pc             = 32'h0000_0000, 
        .is_taken       = 1'b1,
        .cf_type        = ariane_pkg::Branch, 
        .is_mispredict  = 1'b0,
        .valid          = 1'b1,
        .target_address = 32'hAAAA_FFFF
    };
    resolve_branch_o = 1'b1;
    branch_exception_o = '{ 
        .cause = riscv::INSTR_ADDR_MISALIGNED, 
        .valid = 1'b0, 
        .tval  = 32'hFFFF_FFFF 
    };

    #10 rst_ni = 1'b0;
    #10 fu_data_i.operator = ariane_pkg::BEQ;
    #10 pc_i = 32'h0000_0000;
    #10 is_compressed_instr_i = 1'b0;
    #10 fu_valid_i = 1'b1;
    #10 branch_valid_i = 1'b1;
    #10 branch_comp_res_i = 1'b1;
    #10 branch_predict_i = '{ 
                             .cf              = ariane_pkg::NoCF,
                             .predict_address = 32'hAAAAFFFF 
                         };

    #10 $display("Test Case 1");
    #10 $display("------------");
    #10 $display("Input Values:");
    #10 $display("    clk_i = %b", clk_i);
    #10 $display("    rst_ni = %b", rst_ni);
    #10 $display("    debug_mode_i = %b", debug_mode_i);
    #10 $display("    fu_data_i = %p", fu_data_i);
    #10 $display("    pc_i = %h", pc_i);
    #10 $display("    is_compressed_instr_i = %b", is_compressed_instr_i);
    #10 $display("    fu_valid_i = %b", fu_valid_i);
    #10 $display("    branch_valid_i = %b", branch_valid_i);
    #10 $display("    branch_comp_res_i = %b", branch_comp_res_i);
    #10 $display("    branch_predict_i = %p", branch_predict_i);
    #10 $display("");
    #10 $display("Output Values:");
    #10 $display("    branch_result_o = %h", branch_result_o);
    #10 $display("    resolved_branch_o = %p", resolved_branch_o);
    #10 $display("    resolve_branch_o = %b", resolve_branch_o);
    #10 $display("    branch_exception_o = %p", branch_exception_o);
    #10 $display("");

    $finish;
end

// Test case 2
// Test branch mis-prediction
initial begin
    // Input values
    clk_i = 1'b0;
    rst_ni = 1'b1;
    debug_mode_i = 1'b0;
    fu_data_i = '{
        .operator       = ariane_pkg::BLTU,
        .operand_a      = 32'h00000001,
        .operand_b      = 32'h00000002,
        .imm            = 32'h0000_000C,
        .srca_mux       = ariane_pkg::PC,
        .srcb_mux       = ariane_pkg::REG,
        .waddr_mux      = ariane_pkg::NPC,
        .wb             = ariane_pkg::WB_DISABLE
    };
    pc_i = 32'h0000_0000;
    is_compressed_instr_i = 1'b0;
    fu_valid_i = 1'b1;
    branch_valid_i = 1'b1;
    branch_comp_res_i = 1'b0;
    branch_predict_i = '{ 
        .cf              = ariane_pkg::NoCF,
        .predict_address = 32'h0000_0000 
    };

    // Expected output values
    branch_result_o = 32'h0000_0004;
    resolved_branch_o = '{ 
        .pc             = 32'h0000_0000, 
        .is_taken       = 1'b0,
        .cf_type        = ariane_pkg::Branch, 
        .is_mispredict  = 1'b1,
        .valid          = 1'b1,
        .target_address = 32'h0000_000C
    };
    resolve_branch_o = 1'b1;
    branch_exception_o = '{ 
        .cause = riscv::INSTR_ADDR_MISALIGNED, 
        .valid = 1'b0, 
        .tval  = 32'hFFFF_FFFF 
    };

    #10 rst_ni = 1'b0;
    #10 fu_data_i.operator = ariane_pkg::BLTU;
    #10 pc_i = 32'h0000_0000;
    #10 is_compressed_instr_i = 1'b0;
    #10 fu_valid_i = 1'b1;
    #10 branch_valid_i = 1'b1;
    #10 branch_comp_res_i = 1'b0;
    #10 branch_predict_i = '{ 
                             .cf              = ariane_pkg::NoCF,
                             .predict_address = 32'h0000_0000 
                         };

    #10 $display("Test Case 2");
    #10 $display("------------");
    #10 $display("Input Values:");
    #10 $display("    clk_i = %b", clk_i);
    #10 $display("    rst_ni = %b", rst_ni);
    #10 $display("    debug_mode_i = %b", debug_mode_i);
    #10 $display("    fu_data_i = %p", fu_data_i);
    #10 $display("    pc_i = %h", pc_i);
    #10 $display("    is_compressed_instr_i = %b", is_compressed_instr_i);
    #10 $display("    fu_valid_i = %b", fu_valid_i);
    #10 $display("    branch_valid_i = %b", branch_valid_i);
    #10 $display("    branch_comp_res_i = %b", branch_comp_res_i);
    #10 $display("    branch_predict_i = %p", branch_predict_i);
    #10 $display("");
    #10 $display("Output Values:");
    #10 $display("    branch_result_o = %h", branch_result_o);
    #10 $display("    resolved_branch_o = %p", resolved_branch_o);
    #10 $display("    resolve_branch_o = %b", resolve_branch_o);
    #10 $display("    branch_exception_o = %p", branch_exception_o);
    #10 $display("");

    $finish;
end

// Test case 3
// Test alignment error exception
initial begin
    // Input values
    clk_i = 1'b0;
    rst_ni = 1'b1;
    debug_mode_i = 1'b0;
    fu_data_i = '{
        .operator       = ariane_pkg::JALR,
        .operand_a      = 32'hFFFFFFFF,
        .operand_b      = 32'h00000002,
        .imm            = 32'h0000_0004,
        .srca_mux       = ariane_pkg::REG,
        .srcb_mux       = ariane_pkg::IMM,
        .waddr_mux      = ariane_pkg::NPC,
        .wb             = ariane_pkg::WB_DISABLE
    };
    pc_i = 32'h0000_0000;
    is_compressed_instr_i = 1'b0;
    fu_valid_i = 1'b1;
    branch_valid_i = 1'b1;
    branch_comp_res_i = 1'b1;
    branch_predict_i = '{ 
        .cf              = ariane_pkg::NoCF,
        .predict_address = 32'h0000_0000 
    };

    // Expected output values
    branch_result_o = 32'h0000_0004;
    resolved_branch_o = '{ 
        .pc             = 32'h0000_0000, 
        .is_taken       = 1'b1,
        .cf_type        = ariane_pkg::JumpR, 
        .is_mispredict  = 1'b0,
        .valid          = 1'b1,
        .target_address = 32'hFFFFFFFC
    };
    resolve_branch_o = 1'b1;
    branch_exception_o = '{ 
        .cause = riscv::INSTR_ADDR_MISALIGNED, 
        .valid = 1'b1, 
        .tval  = 32'hFFFF_FFFC 
    };

    #10 rst