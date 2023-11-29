 // VerifAI TestGuru
 // tests for: mult.sv

// Testbench for mult.sv

module mult_tb;

    typedef struct { 
        logic operator; 
        logic [31:0] operand_a; 
        logic [31:0] operand_b; 
    } fu_data_t;

    logic clk;
    logic rst;
    logic flush;
    fu_data_t fu_data;
    logic mult_valid;
    riscv::xlen_t result;
    logic mult_valid_o;
    logic mult_ready_o;
    logic [TRANS_ID_BITS-1:0] mult_trans_id_o;

    mult mult_i (
        .clk_i(clk),
        .rst_ni(rst),
        .flush_i(flush),
        .fu_data_i(fu_data),
        .mult_valid_i(mult_valid),
        .result_o(result),
        .mult_valid_o(mult_valid_o),
        .mult_ready_o(mult_ready_o),
        .mult_trans_id_o(mult_trans_id_o)
    );

    initial begin
        // Initialize all signals
        clk = 0;
        rst = 1;
        flush = 0;
        fu_data = '0;
        mult_valid = 0;
        result = '0;
        mult_valid_o = 0;
        mult_ready_o = 0;
        mult_trans_id_o = '0;

        // Wait for 100ns
        #100;

        // Set reset to 0
        rst = 0;

        // Send a mult request
        fu_data.operator = 1'b1;
        fu_data.operand_a = 32'd10;
        fu_data.operand_b = 32'd20;
        mult_valid = 1'b1;

        // Wait for the result
        #100;

        // Check the result
        assert(result == 32'd200);

        // Send a div request
        fu_data.operator = 1'b0;
        fu_data.operand_a = 32'd10;
        fu_data.operand_b = 32'd2;
        mult_valid = 1'b1;

        // Wait for the result
        #100;

        // Check the result
        assert(result == 32'd5);
    end
endmodule
