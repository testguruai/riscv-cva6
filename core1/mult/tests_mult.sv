# VerifAI TestGuru
# tests for: mult.sv
```
module mult_tb;

    logic clk;
    logic rst_ni;
    logic flush_i;
    fu_data_t fu_data_i;
    logic mult_valid_i;
    logic [riscv::XLEN-1:0] result_o;
    logic mult_valid_o;
    logic mult_ready_o;
    logic [TRANS_ID_BITS-1:0] mult_trans_id_o;

    mult mult_i (
        .clk_i,
        .rst_ni,
        .flush_i,
        .fu_data_i,
        .mult_valid_i,
        .result_o,
        .mult_valid_o,
        .mult_ready_o,
        .mult_trans_id_o
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_ni = 1'b1;
        #10;
        rst_ni = 1'b0;

        // send a multiplication request
        fu_data_i.operator = MUL;
        fu_data_i.operand_a = 'h12345678;
        fu_data_i.operand_b = 'h12345678;
        fu_data_i.trans_id = 1;
        mult_valid_i = 1'b1;
        #10;
        mult_valid_i = 1'b0;

        // send a division request
        fu_data_i.operator = DIV;
        fu_data_i.operand_a = 'h12345678;
        fu_data_i.operand_b = 'h12345678;
        fu_data_i.trans_id = 2;
        mult_valid_i = 1'b1;
        #10;
        mult_valid_i = 1'b0;

        #100;
        $stop;
    end
endmodule
```