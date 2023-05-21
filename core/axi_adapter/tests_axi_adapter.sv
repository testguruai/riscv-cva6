# VerifAI TestGuru
# Explanation for: axi_adapter.sv
# Test Bench and Test Code for axi_adapter

## Test Bench

```verilog
`timescale 1ns / 1ps

module tb_axi_adapter();

  parameter DATA_WIDTH            = 256;
  parameter CRITICAL_WORD_FIRST   = 0;
  parameter CACHELINE_BYTE_OFFSET = 8;
  parameter AXI_ADDR_WIDTH        = 0;
  parameter AXI_DATA_WIDTH        = 0;
  parameter AXI_ID_WIDTH          = 0;

  logic                             clk_i;
  logic                             rst_ni;
  logic                             req_i;
  ariane_axi::ad_req_t              type_i;
  ariane_pkg::amo_t                 amo_i;
  logic                             gnt_o;
  logic [riscv::XLEN-1:0]           addr_i;
  logic                             we_i;
  logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][AXI_DATA_WIDTH-1:0]      wdata_i;
  logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][(AXI_DATA_WIDTH/8)-1:0]  be_i;
  logic [1:0]                       size_i;
  logic [AXI_ID_WIDTH-1:0]          id_i;
  logic                             valid_o;
  logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][AXI_DATA_WIDTH-1:0] rdata_o;
  logic [AXI_ID_WIDTH-1:0]          id_o;
  logic [AXI_DATA_WIDTH-1:0]        critical_word_o;
  logic                             critical_word_valid_o;
  ariane_axi::req_t                axi_req_o;
  ariane_axi::resp_t               axi_resp_i;

  axi_adapter #(
    .DATA_WIDTH(DATA_WIDTH),
    .CRITICAL_WORD_FIRST(CRITICAL_WORD_FIRST),
    .CACHELINE_BYTE_OFFSET(CACHELINE_BYTE_OFFSET),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ID_WIDTH(AXI_ID_WIDTH),
    .axi_req_t(ariane_axi::req_t),
    .axi_rsp_t(ariane_axi::resp_t)
  ) dut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .req_i(req_i),
    .type_i(type_i),
    .amo_i(amo_i),
    .gnt_o(gnt_o),
    .addr_i(addr_i),
    .we_i(we_i),
    .wdata_i(wdata_i),
    .be_i(be_i),
    .size_i(size_i),
    .id_i(id_i),
    .valid_o(valid_o),
    .rdata_o(rdata_o),
    .id_o(id_o),
    .critical_word_o(critical_word_o),
    .critical_word_valid_o(critical_word_valid_o),
    .axi_req_o(axi_req_o),
    .axi_resp_i(axi_resp_i)
  );

  initial begin
    clk_i = 1'b0;
    repeat(10) @(posedge clk_i);
    rst_ni = 1'b0;
    @(posedge clk_i);
    rst_ni = 1'b1;
    @(posedge clk_i);
    #10;
    req_i = 1'b1;
    type_i = ariane_axi::SINGLE_REQ;
    we_i = 1'b1;
    wdata_i = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
    be_i = {8'hFF};
    size_i = 2'b10;
    id_i = 8'h01;
    @(posedge clk_i);
    req_i = 1'b0;
    @(posedge clk_i);
    #10;
    $finish;
  end

  always begin
    clk_i = ~clk_i;
    #(1);
  end

endmodule
```

## Test Code

```verilog
`timescale 1ns / 1ps

module test_axi_adapter();

  parameter DATA_WIDTH            = 256;
  parameter CRITICAL_WORD_FIRST   = 0;
  parameter CACHELINE_BYTE_OFFSET = 8;
  parameter AXI_ADDR_WIDTH        = 0;
  parameter AXI_DATA_WIDTH        = 0;
  parameter AXI_ID_WIDTH          = 0;

  logic                             clk_i;
  logic                             rst_ni;
  logic                             req_i;
  ariane_axi::ad_req_t              type_i;
  ariane_pkg::amo_t                 amo_i;
  logic                             gnt_o;
  logic [riscv::XLEN-1:0]           addr_i;
  logic                             we_i;
  logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][AXI_DATA_WIDTH-1:0]      wdata_i;
  logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][(AXI_DATA_WIDTH/8)-1:0]  be_i;
  logic [1:0]                       size_i;
  logic [AXI_ID_WIDTH-1:0]          id_i;
  logic                             valid_o;
  logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][AXI# Test Bench and Test Code for Verilog Code

## Test Bench

```verilog
`timescale 1 ns / 1 ps

module test_axi_interconnect();

    // Inputs
    reg clk_i;
    reg rst_ni;
    reg [63:0] berr_i;
    reg wr_valid_i;
    reg [6:0] wr_type_i;
    reg [63:0] wr_addr_i;
    reg [7:0] wr_be_i;
    reg [63:0] wr_data_i;
    reg [2:0] wr_size_i;
    reg [3:0] wr_len_i;
    reg [3:0] wr_burst_i;
    reg [5:0] wr_id_i;
    reg rd_valid_i;
    reg [6:0] rd_type_i;
    reg [63:0] rd_addr_i;
    reg [7:0] rd_be_i;
    reg [3:0] rd_size_i;
    reg [3:0] rd_len_i;
    reg [3:0] rd_burst_i;
    reg [5:0] rd_id_i;
    reg [5:0] rd_imp_spec_i;
    reg [5:0] rd_last_i;
    reg [63:0] ar_size_i;
    reg [63:0] ar_len_i;
    reg [63:0] ar_burst_i;
    reg [63:0] ar_addr_i;
    reg [5:0] ar_id_i;
    reg [7:0] ar_size_i;
    reg [2:0] ar_domain_i;
    reg [3:0] aw_imp_spec_i;
    reg [2:0] aw_domain_i;
    reg [7:0] aw_size_i;
    reg [63:0] aw_len_i;
    reg [63:0] aw_burst_i;
    reg [63:0] aw_addr_i;
    reg [5:0] aw_id_i;

    // Outputs
    wire [4:0] gnt_o;
    wire [6:0] type_o;
    wire [63:0] addr_o;
    wire [7:0] be_o;
    wire [63:0] wdata_o;
    wire [2:0] size_o;
    wire [3:0] len_o;
    wire [3:0] burst_o;
    wire [5:0] id_o;
    wire [63:0] rdata_o;
    wire valid_o;
    wire [63:0] critical_word_o;
    wire [3:0] ar_ready_o;
    wire [1:0] aw_ready_o;
    wire w_ready_o;
    wire r_ready_o;

    // Instantiate the Unit Under Test (UUT)
    axi_interconnect uut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .berr_i(berr_i),
        .wr_valid_i(wr_valid_i),
        .wr_type_i(wr_type_i),
        .wr_addr_i(wr_addr_i),
        .wr_be_i(wr_be_i),
        .wr_data_i(wr_data_i),
        .wr_size_i(wr_size_i),
        .wr_len_i(wr_len_i),
        .wr_burst_i(wr_burst_i),
        .wr_id_i(wr_id_i),
        .rd_valid_i(rd_valid_i),
        .rd_type_i(rd_type_i),
        .rd_addr_i(rd_addr_i),
        .rd_be_i(rd_be_i),
        .rd_size_i(rd_size_i),
        .rd_len_i(rd_len_i),
        .rd_burst_i(rd_burst_i),
        .rd_id_i(rd_id_i),
        .rd_imp_spec_i(rd_imp_spec_i),
        .rd_last_i(rd_last_i),
        .ar_size_i(ar_size_i),
        .ar_len_i(ar_len_i),
        .ar_burst_i(ar_burst_i),
        .ar_addr_i(ar_addr_i),
        .ar_id_i(ar_id_i),
        .ar_domain_i(ar_domain_i),
        .aw_imp_spec_i(aw_imp_spec_i),
        .aw_domain_i(aw_domain_i),
        .aw_size_i(aw_size_i),
        .aw_len_i(aw_len_i),
        .aw_burst_i(aw_burst_i),
        .aw_addr_i(aw_addr_i),
        .aw_id_i(aw_id_i),
        .gnt_o(gnt_o),
        .type_o(type_o),
        .addr_o(addr_o),
        .be_o(be_o),
        .wdata_o(wdata_o),
        .size_o(size_o),
        .len_o(len_o),
        .burst_o(burst_o),
        .id_o(id_o),
        .rdata_o(rdata_o),
        .valid_o(valid_o),
        .critical_word_o(critical_word_o),
        .ar_ready_o(ar_ready_o),
        .aw_ready_o(aw_ready_o),
        .w_ready_o(w_ready_o),
        .r_ready_o(r_ready_o)
    );

    // Initialize Inputs
    initial begin
        clk_i = 0;
        forever #10 clk_i = ~clk_i;
    end

    initial begin
        rst_ni = 0;
        #50;
        rst_ni = 1;
    end

    initial begin
        wr_valid_i = 1;
        wr_type_i = 0;
        wr_addr_i = 64'h0000_0000_0000_0000;
        wr_be_i = 8'b1111_1111;
        wr_data_i = 64'h1122_3344_5566_7788;
        wr_size_i = 2'b10;
        wr_len_i = 4'b0000;
        wr_burst_i = 4'b0000;
        wr_id_i = 6'b000001;
        
        #20;
        rd_valid_i = 1;
        rd_type_i = 5;
        rd_addr_i = 64'h0000_0000_2000_0000;
        rd_be_i = 8'b1111_1111;
        rd_size_i = 2'b10;
        rd_len_i = 4'b0000;
        rd_burst_i = 4'b0000;
        rd_id_i = 6'b000001;
    end

    // Check the outputs
    always @(*)
    begin
        assert(gnt_o == 1);
        assert(type_o == 2);
        assert(addr_o == 64'h0000_0000_0000_0000);
        assert(be_o == 8'b1111_1111);
        assert(wdata_o == 64'h1122_3344_5566_7788);
        assert(size_o == 2'b10);
        assert(len_o == 4'b0000);
        assert(burst_o == 4'b0000);
        assert(id_o == 6'b000001);
        assert(rdata_o == 0);
        assert(valid_o == 0);
        assert(critical_word_o == 0);
        assert(ar_ready_o == 2'b00);
        assert(aw_ready_o == 2'b00);
        assert(w_ready_o == 1'b0);
        assert(r_ready_o == 1'b0);
    end
endmodule
```

## Test Code

```verilog
`timescale 1 ns / 1 ps

module axi_interconnect_test ();

    // Inputs
    reg clk;
    reg rst_n;
    reg [63:0] berr;
    reg wr_valid;
    reg [6:0] wr_type;
    reg [63:0] wr_addr;
    reg [7:0] wr_be;
    reg [63:0] wr_data;
    reg [2:0] wr_size;
    reg [3:0] wr_len;
    reg [3:0] wr_burst;
    reg [5:0] wr_id;
    reg rd_valid;
    reg [6:0] rd_type;
    reg [63:0] rd_addr;
    reg [7:0] rd_be;
    reg [3:0] rd_size;
    reg [3:0] rd_len;
    reg [3:0] rd_burst;
    reg [5:0] rd_id;
    reg [5:0] rd_imp_spec;
    reg [5:0] rd_last;
    reg [63:0] ar_size;
    reg [63:0] ar_len;
    reg [63:0] ar_burst;
    reg [63:0] ar_addr;
    reg [5:0] ar_id;
    reg [7:0] ar_size;
    reg [2:0] ar_domain;
    reg [3:0] aw_imp_spec;
    reg [2:0] aw_domain;
    reg [7:0] aw_size;
    reg [63:0] aw_len;
    reg [63:0] aw_burst;
    reg [63:0] aw_addr;
    reg [5:0] aw_id;

    // Outputs
    wire [4:0] gnt;
    wire [6:0] type;
    wire [63:0] addr;
    wire [7:0] be;
    wire [63:0] wdata;
    wire [2:0] size;
    wire [3:0] len;
    wire [3:0] burst;
    wire [5:0] id_out;
    wire [63:0] rdata;
    wire valid;
    wire [63:0] critical_word;
    wire [3:0] ar_ready;
    wire [1:0] aw_ready;
    wire w_ready;
    wire r_ready;

    // Instantiate the Unit Under Test (UUT)
    axi_interconnect uut (
        .clk_i(clk),
        .