# VerifAI TestGuru
# tests for: lsu_bypass.sv
```
`include "ariane_pkg.sv"

module lsu_bypass_tb;

    logic clk, rst;
    logic flush;

    lsu_ctrl_t lsu_req;
    logic lsu_req_valid;
    logic pop_ld, pop_st;

    lsu_ctrl_t lsu_ctrl_o;
    logic ready_o;

    // instantiate DUT
    lsu_bypass dut(
        .clk_i(clk),
        .rst_ni(rst),
        .flush_i(flush),

        .lsu_req_i(lsu_req),
        .lsu_req_valid_i(lsu_req_valid),
        .pop_ld_i(pop_ld),
        .pop_st_i(pop_st),

        .lsu_ctrl_o(lsu_ctrl_o),
        .ready_o(ready_o)
    );

    initial begin
        // initialize DUT
        clk = 0;
        rst = 1;
        #10;
        rst = 0;

        // generate test stimulus
        forever begin
            #10;
            lsu_req_valid = 1;
            lsu_req.addr = 'h1234;
            lsu_req.data = 'h5678;
            #10;
            lsu_req_valid = 0;
            #10;
            pop_ld = 1;
            #10;
            pop_ld = 0;
            #10;
            flush = 1;
            #10;
            flush = 0;
        end
    end

    always #5 clk = ~clk;

endmodule
```