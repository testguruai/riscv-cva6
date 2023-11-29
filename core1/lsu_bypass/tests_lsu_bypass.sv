// VerifAI TestGuru
// tests for: lsu_bypass.sv

module lsu_bypass_tb;

    logic clk, rst;
    logic flush;

    logic lsu_req_valid;
    logic pop_ld, pop_st;

    logic [13:0] lsu_req_addr;
    logic [15:0] lsu_req_data;
    logic [1:0] lsu_ctrl_o;
    logic ready_o;

    lsu_bypass dut(
        .clk_i(clk),
        .rst_ni(rst),
        .flush_i(flush),

        .lsu_req_i({lsu_req_addr, lsu_req_data}),
        .lsu_req_valid_i(lsu_req_valid),
        .pop_ld_i(pop_ld),
        .pop_st_i(pop_st),

        .lsu_ctrl_o(lsu_ctrl_o),
        .ready_o(ready_o)
    );

    initial begin
        clk = 0;
        rst = 1;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        #10 rst = 0;

        #10 lsu_req_valid = 1;
        lsu_req_addr = 16'h1234;
        lsu_req_data = 16'h5678;
        #10 lsu_req_valid = 0;

        #10 pop_ld = 1;
        #10 pop_ld = 0;

        #10 lsu_req_valid = 1;
        lsu_req_addr = 16'h4567;
        lsu_req_data = 16'h8901;
        #10 lsu_req_valid = 0;

        #10 pop_st = 1;
        #10 pop_st = 0;

        #10 flush = 1;
        #10 flush = 0;

        end
    end

endmodule
