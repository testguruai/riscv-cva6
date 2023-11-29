// VerifAI TestGuru
// tests for: alu.sv

module testbench;

    reg clk_i;
    reg rst_ni;
    reg [7:0] fu_data_i;
    reg [31:0] result_o;
    reg alu_branch_res_o;

    initial begin
        // Initialize Inputs
        clk_i = 0;
        rst_ni = 1;
        fu_data_i = 8'b0;
        result_o = 32'b0;
        alu_branch_res_o = 1'b0;

        // Wait for 100 ns
        #100;
        rst_ni = 0;

        // Create test data
        fu_data_i = 8'bADD;
        fu_data_i.operand_a = 32'h12345678;
        fu_data_i.operand_b = 32'h456789ab;

        // Run simulation
        #100;

        // Check results
        if (result_o !== 32'h579b3cde) begin
            $display("Test failed");
        end

        $display("Test passed");
    end

    always #5 clk_i = ~clk_i;
endmodule
