# VerifAI TestGuru
# tests for: multiplier.sv
```
module multiplier_tb;

    logic clk, rst;
    logic [TRANS_ID_BITS-1:0] trans_id;
    logic mult_valid;
    fu_op operator;
    logic [riscv::XLEN-1:0] operand_a, operand_b;
    logic [riscv::XLEN-1:0] result;
    logic mult_valid_o, mult_ready_o, mult_trans_id_o;

    multiplier #(
        .XLEN(riscv::XLEN)
    ) multiplier_i (
        .clk_i(clk),
        .rst_ni(rst),
        .trans_id_i(trans_id),
        .mult_valid_i(mult_valid),
        .operator_i(operator),
        .operand_a_i(operand_a),
        .operand_b_i(operand_b),
        .result_o(result),
        .mult_valid_o(mult_valid_o),
        .mult_ready_o(mult_ready_o),
        .mult_trans_id_o(mult_trans_id_o)
    );

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        trans_id = '0;
        mult_valid = 1'b0;
        operator = MUL;
        operand_a = '0;
        operand_b = '0;
        result = '0;
        mult_valid_o = 1'b0;
        mult_ready_o = 1'b0;
        mult_trans_id_o = '0;

        #10;
        rst = 1'b0;

        #10;
        trans_id = 1'b1;
        mult_valid = 1'b1;
        operator = MUL;
        operand_a = 10;
        operand_b = 10;

        #10;
        mult_valid_o = 1'b1;
        mult_ready_o = 1'b1;
        mult_trans_id_o = 1'b1;
        result = 100;

        #100;
        $stop;
    end

endmodule
```