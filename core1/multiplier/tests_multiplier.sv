// VerifAI TestGuru
// tests for: multiplier.sv

module multiplier_tb #(parameter TRANS_ID_BITS = 4);

    bit clk, rst_ni;
    enum logic [1:0] {ADD, MUL} fu_op;
    logic [TRANS_ID_BITS-1:0] trans_id_i;
    logic mult_valid_i;
    logic [riscv::XLEN-1:0] operand_a_i, operand_b_i;
    logic [riscv::XLEN-1:0] result_o;
    logic mult_valid_o, mult_ready_o;
    logic [TRANS_ID_BITS-1:0] mult_trans_id_o;

    multiplier #(
        .XLEN(riscv::XLEN)
    ) multiplier_i (
        .clk_i(clk),
        .rst_ni(rst_ni),
        .trans_id_i(trans_id_i),
        .mult_valid_i(mult_valid_i),
        .operator_i(operator_i),
        .operand_a_i(operand_a_i),
        .operand_b_i(operand_b_i),
        .result_o(result_o),
        .mult_valid_o(mult_valid_o),
        .mult_ready_o(mult_ready_o),
        .mult_trans_id_o(mult_trans_id_o)
    );

    // initial begin
    //     clk = 0;
    //     rst_ni = 1;
    //     trans_id_i = 0;
    //     mult_valid_i = 0;
    //     operator_i = MUL;
    //     operand_a_i = 10;
    //     operand_b_i = 10;
    //     #10;
    //     rst_ni = 0;
    //     #10;
    //     mult_valid_i = 1;
    //     #10;
    //     $display("mult_valid_o = %b", mult_valid_o);
    //     $display("mult_trans_id_o = %d", mult_trans_id_o);
    //     $display("result_o = %x", result_o);
    //     #100;
    //     $finish;
    // end

    // always #5 clk = ~clk;
endmodule
