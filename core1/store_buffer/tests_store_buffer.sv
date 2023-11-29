// VerifAI TestGuru
// tests for: store_buffer.sv

module testbench;

    logic clk_i;
    logic rst_ni;
    logic flush_i;
    logic no_st_pending_o;
    logic store_buffer_empty_o;

    logic[11:0] page_offset_i;
    logic page_offset_matches_o;

    logic commit_i;
    logic commit_ready_o;
    logic ready_o;
    logic valid_i;
    logic valid_without_flush_i;

    logic[riscv::PLEN-1:0] paddr_i;
    logic[riscv::XLEN-1:0] data_i;
    logic[(riscv::XLEN/8)-1:0] be_i;
    logic[1:0] data_size_i;

    // D$ interface
    dcache_req_o_t req_port_i;
    dcache_req_i_t req_port_o;

    store_buffer#(
        .DEPTH_SPEC(10),
        .DEPTH_COMMIT(10)
    ) store_buffer_i(
        .clk_i,
        .rst_ni,
        .flush_i,
        .no_st_pending_o,
        .store_buffer_empty_o,
        .page_offset_i,
        .page_offset_matches_o,
        .commit_i,
        .commit_ready_o,
        .ready_o,
        .valid_i,
        .valid_without_flush_i,
        .paddr_i,
        .data_i,
        .be_i,
        .data_size_i,
        .req_port_i,
        .req_port_o
    );

    initial begin
        clk_i = 1'b0;
        forever #5 clk_i = ~clk_i;
    end

    initial begin
        rst_ni = 1'b1;
        #10 rst_ni = 1'b0;

        // flush the store buffer
        #10 flush_i = 1'b1;
        #10 flush_i = 1'b0;

        // put a store in the speculative buffer
        #10 valid_i = 1'b1;
        #10 valid_i = 1'b0;

        // commit the store
        #10 commit_i = 1'b1;
        #10 commit_i = 1'b0;

        // check if the store buffer is empty
        #10 assert(store_buffer_empty_o == 1'b1);

        #10 $stop;
    end
endmodule
