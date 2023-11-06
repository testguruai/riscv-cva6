# VerifAI TestGuru
# tests for: alu.sv
```
module testbench;

    logic clk_i;
    logic rst_ni;
    fu_data_t fu_data_i;
    riscv::xlen_t result_o;
    logic alu_branch_res_o;

    initial begin
        clk_i = 0;
        rst_ni = 1;
        forever begin
            #5 clk_i = ~clk_i;
        end
    end

    always @(posedge clk_i) begin
        if (rst_ni == 0) begin
            fu_data_i.operator = '0;
            fu_data_i.operand_a = '0;
            fu_data_i.operand_b = '0;
        end else begin
            fu_data_i.operator = $random;
            fu_data_i.operand_a = $random;
            fu_data_i.operand_b = $random;
        end
    end

    alu #(
        .XLEN(64)
    ) alu_i (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .fu_data_i(fu_data_i),
        .result_o(result_o),
        .alu_branch_res_o(alu_branch_res_o)
    );

endmodule
```