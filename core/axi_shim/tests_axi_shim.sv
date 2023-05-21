# VerifAI TestGuru
# Explanation for: axi_shim.sv
## Test Bench

```verilog
module axi_shim_tb();

  // Inputs
  logic                            clk_i;  // Clock
  logic                            rst_ni; // Asynchronous reset active low
  // read channel - inputs
  logic                            rd_req_i;
  logic [32-1:0]                   rd_addr_i;
  logic [2-1:0]                    rd_blen_i;
  logic [3-1:0]                    rd_size_i;
  logic                            rd_id_i;
  logic                            rd_lock_i;
  // read channel - outputs
  logic                            rd_gnt_o;
  logic                            rd_last_o;
  logic                            rd_valid_o;
  logic [64-1:0]                   rd_data_o;
  logic [64-1:0]                   rd_user_o;
  logic                            rd_exokay_o;
  logic [5-1:0]                    wr_atop_i;
  // write channel - inputs
  logic                            wr_req_i;
  logic [32-1:0]                   wr_addr_i;
  logic [4-1:0]                    wr_data_i [2:0][64-1:0];
  logic [4-1:0]                    wr_user_i [2:0][64-1:0];
  logic [8-1:0]                    wr_be_i   [2:0][8-1:0];
  logic [2-1:0]                    wr_blen_i;
  logic [3-1:0]                    wr_size_i;
  logic                            wr_id_i;
  logic                            wr_lock_i;
  // write channel - outputs
  logic                            wr_gnt_o;
  logic                            wr_valid_o;
  logic                            wr_exokay_o;
  logic                            wr_id_o;

  // Instantiate the Unit Under Test (UUT)
  axi_shim #(
    .AxiUserWidth(64),
    .AxiNumWords(4),
    .AxiAddrWidth(0),
    .AxiDataWidth(0),
    .AxiIdWidth(0)
  ) uut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .rd_req_i(rd_req_i),
    .rd_gnt_o(rd_gnt_o),
    .rd_addr_i(rd_addr_i),
    .rd_blen_i(rd_blen_i),
    .rd_size_i(rd_size_i),
    .rd_id_i(rd_id_i),
    .rd_lock_i(rd_lock_i),
    .rd_rdy_i(1'b0),
    .rd_last_o(rd_last_o),
    .rd_valid_o(rd_valid_o),
    .rd_data_o(rd_data_o),
    .rd_user_o(rd_user_o),
    .rd_id_o(rd_id_i),
    .rd_exokay_o(rd_exokay_o),
    .wr_req_i(wr_req_i),
    .wr_gnt_o(wr_gnt_o),
    .wr_addr_i(wr_addr_i),
    .wr_data_i({
      wr_data_i[2],
      wr_data_i[1],
      wr_data_i[0]
    }),
    .wr_user_i({
      wr_user_i[2],
      wr_user_i[1],
      wr_user_i[0]
    }),
    .wr_be_i({
      wr_be_i[2],
      wr_be_i[1],
      wr_be_i[0]
    }),
    .wr_blen_i(wr_blen_i),
    .wr_size_i(wr_size_i),
    .wr_id_i(wr_id_i),
    .wr_lock_i(wr_lock_i),
    .wr_atop_i(wr_atop_i),
    .wr_rdy_i(1'b1),
    .wr_valid_o(wr_valid_o),
    .wr_id_o(wr_id_o),
    .wr_exokay_o(wr_exokay_o),
    .axi_req_o(),
    .axi_resp_i()
  );

  initial begin
    // Initialize Inputs
    clk_i = 0;
    rst_ni = 1;

    #10;
    // First test for single write request
    wr_req_i = 1;
    wr_blen_i = 0;
    wr_data_i[0] = 64'b1010101010101010101010101010101010101010101010101010101010101010;
    wr_user_i[0] = 64'b0101010101010101010101010101010101010101010101010101010101010101;
    wr_be_i[0] = 8'b11111111;
    wr_size_i = 2'b01;
    wr_id_i = '0;
    wr_lock_i = 0;

    #10; // wait for 10 ns for response

    assert(wr_gnt_o === 1, "Single Request Test Failed: wr_gnt_o != 1");
    assert(wr_valid_o === 1, "Single Request Test Failed: wr_valid_o != 1");
    assert(wr_exokay_o === 0, "Single Request Test Failed: wr_exokay_o != 0");
    assert(wr_id_o === 0, "Single Request Test Failed: wr_id_o != 0");

    // Second test for burst write request
    wr_req_i = 1;
    wr_blen_i = 3;
    wr_data_i[0] = 64'b1010101010101010101010101010101010101010101010101010101010101010;
    wr_user_i[0] = 64'b0101010101010101010101010101010101010101010101010101010101010101;
    wr_be_i[0] = 8'b11111111;
    wr_data_i[1] = 64'b0101010101010101010101010101010101010101010101010101010101010101;
    wr_user_i[1] = 64'b1010101010101010101010101010101010101010101010101010101010101010;
    wr_be_i[1] = 8'b11111111;
    wr_data_i[2] = 64'b1100110011001100110011001100110011001100110011001100110011001100;
    wr_user_i[2] = 64'b0011001100110011001100110011001100110011001100110011001100110011;
    wr_be_i[2] = 8'b11111111;
    wr_size_i = 2'b01;
    wr_id_i = '0;
    wr_lock_i = 0;

    #10; // wait for 10 ns for response

    assert(wr_gnt_o === 1, "Burst Request Test Failed: wr_gnt_o != 1");
    assert(wr_valid_o === 1, "Burst Request Test Failed: wr_valid_o != 1");
    assert(wr_exokay_o === 0, "Burst Request Test Failed: wr_exokay_o != 0");
    assert(wr_id_o === 0, "Burst Request Test Failed: wr_id_o != 0");

    $display("All tests pass");
  end

endmodule
```

## Test Code

```verilog
module axi_shim_tb();

  // Inputs
  logic                            clk_i;  // Clock
  logic                            rst_ni; // Asynchronous reset active low
  // read channel - inputs
  logic                            rd_req_i;
  logic [32-1:0]                   rd_addr_i;
  logic [2-1:0]                    rd_blen_i;
  logic [3-1:0]                    rd_size_i;
  logic                            rd_id_i;
  logic                            rd_lock_i;
  // read channel - outputs
  logic                            rd_gnt_o;
  logic                            rd_last_o;
  logic                            rd_valid_o;
  logic [64-1:0]                   rd_data_o;
  logic [64-1:0]                   rd_user_o;
  logic                            rd_exokay_o;
  logic [5-1:0]                    wr_atop_i;
  // write channel - inputs
  logic                            wr_req_i;
  logic [32-1:0]                   wr_addr_i;
  logic [4-1:0]                    wr_data_i [2:0][64-1:0];
  logic [4-1:0]                    wr_user_i [2:0][64-1:0];
  logic [8# Test Bench and Test Code for AXI Adapter 2

The following test bench and test code are designed to verify the functionality of the AXI Adapter 2 Verilog code.

## Test Bench

```verilog
`timescale 1 ns / 1 ps

module axi_adapter2_tb();

  // constants
  localparam AXI_DATA_SIZE = 32;      // AXI bus width
  localparam AxiAddrWidth = 32;       // AXI address width
  localparam AxiIdWidth = 4;          // AXI id width
  localparam AxiNumWords = 2;         // AXI number of data words
  localparam T_RAND_NUM = 64;         // number of random read/write operations
  localparam T_RANDOM_SEED = 10;      // random seed

  // inputs
  reg clk_i;
  reg rst_ni;
  reg wr_req_i;
  reg [AXI_DATA_SIZE-1:0] wr_data_i;
  reg [AxiAddrWidth-1:0] wr_addr_i;
  reg wr_blen_i;
  reg wr_size_i;
  reg wr_last_i;
  reg wr_lock_i;
  reg [AxiIdWidth-1:0] wr_id_i;
  reg rd_req_i;
  reg [AxiAddrWidth-1:0] rd_addr_i;
  reg rd_blen_i;
  reg rd_size_i;
  reg [AxiIdWidth-1:0] rd_id_i;
  reg rd_lock_i;
  reg rd_rdy_i;

  // outputs
  wire wr_gnt_o;
  wire rd_gnt_o;
  wire [AXI_DATA_SIZE-1:0] rd_data_o;
  wire rd_user_o;
  wire rd_last_o;
  wire rd_valid_o;
  wire [AxiIdWidth-1:0] rd_id_o;
  wire rd_exokay_o;

  // instantiate the DUT
  axi_adapter2 dut (
    .clk_i      (clk_i    ),
    .rst_ni     (rst_ni   ),
    .wr_req_i   (wr_req_i ),
    .wr_data_i  (wr_data_i),
    .wr_addr_i  (wr_addr_i),
    .wr_blen_i  (wr_blen_i),
    .wr_size_i  (wr_size_i),
    .wr_last_i  (wr_last_i),
    .wr_lock_i  (wr_lock_i),
    .wr_id_i    (wr_id_i  ),
    .wr_gnt_o   (wr_gnt_o),
    .rd_req_i   (rd_req_i ),
    .rd_addr_i  (rd_addr_i),
    .rd_blen_i  (rd_blen_i),
    .rd_size_i  (rd_size_i),
    .rd_id_i    (rd_id_i  ),
    .rd_lock_i  (rd_lock_i),
    .rd_rdy_i   (rd_rdy_i ),
    .rd_data_o  (rd_data_o),
    .rd_user_o  (rd_user_o),
    .rd_last_o  (rd_last_o),
    .rd_valid_o (rd_valid_o),
    .rd_id_o    (rd_id_o  ),
    .rd_exokay_o(rd_exokay_o)
  );

  // clock generator
  always #5 clk_i = !clk_i;

  // reset generator
  initial begin
    rst_ni = 0;
    repeat (3) @(negedge clk_i);
    rst_ni = 1;
  end

  // stimulus
  reg [AXI_DATA_SIZE-1:0] wr_mem[0:AxiNumWords-1];
  reg [AXI_DATA_SIZE-1:0] rd_mem[0:AxiNumWords-1];
  integer random_seed = T_RANDOM_SEED;
  integer wr_idx = 0;
  integer rd_idx = 0;
  integer i;

  // initialize memories
  initial begin
    for (i = 0; i < AxiNumWords; i = i + 1) begin
      wr_mem[i] = 0;
      rd_mem[i] = 0;
    end
  end

  // random write operations
  initial begin
    for (i = 0; i < T_RAND_NUM; i = i + 1) begin
      // generate random data and address
      wr_data_i = $random(random_seed);
      wr_addr_i = $random(random_seed) % (AxiNumWords * AXI_DATA_SIZE);
      wr_blen_i = ($random(random_seed) % AxiIdWidth) + 1;
      wr_size_i = $clog2(AXI_DATA_SIZE/8);
      wr_last_i = ($random(random_seed) > (2 ** 30));
      wr_lock_i = ($random(random_seed) > (2 ** 31));
      wr_id_i = ($random(random_seed) % (2 ** AxiIdWidth));
      wr_req_i = 1;

      // wait for grant
      repeat (20) @(posedge clk_i);
      while (wr_gnt_o == 0) begin
        repeat (20) @(posedge clk_i);
      end

      // write data
      wr_mem[wr_idx] = wr_data_i;
      wr_req_i = 0;

      // ready for next operation
      wr_idx = (wr_idx + 1) % AxiNumWords;
    end
  end

  // random read operations
  initial begin
    for (i = 0; i < T_RAND_NUM; i = i + 1) begin
      // generate random address
      rd_addr_i = $random(random_seed) % (AxiNumWords * AXI_DATA_SIZE);
      rd_blen_i = ($random(random_seed) % AxiIdWidth) + 1;
      rd_size_i = $clog2(AXI_DATA_SIZE/8);
      rd_id_i = ($random(random_seed) % (2 ** AxiIdWidth));
      rd_lock_i = ($random(random_seed) > (2 ** 31));
      rd_rdy_i = 1;
      rd_req_i = 1;

      // wait for grant
      repeat (20) @(posedge clk_i);
      while (rd_gnt_o == 0) begin
        repeat (20) @(posedge clk_i);
      end

      // read data
      rd_mem[rd_idx] = rd_data_o;
      rd_req_i = 0;

      // ready for next operation
      rd_idx = (rd_idx + 1) % AxiNumWords;
    end
  end

endmodule // axi_adapter2_tb
```

## Test Code

The following test code defines the expected behavior of the AXI Adapter 2 Verilog code.

```verilog
`timescale 1 ns / 1 ps

module axi_adapter2_test();

  // constants
  localparam AXI_DATA_SIZE = 32;      // AXI bus width
  localparam AxiAddrWidth = 32;       // AXI address width
  localparam AxiIdWidth = 4;          // AXI id width
  localparam AxiNumWords = 2;         // AXI number of data words
  localparam T_RAND_NUM = 64;         // number of random read/write operations
  localparam T_RANDOM_SEED = 10;      // random seed

  // inputs
  reg clk_i;
  reg rst_ni;
  reg wr_req_i;
  reg [AXI_DATA_SIZE-1:0] wr_data_i;
  reg [AxiAddrWidth-1:0] wr_addr_i;
  reg wr_blen_i;
  reg wr_size_i;
  reg wr_last_i;
  reg wr_lock_i;
  reg [AxiIdWidth-1:0] wr_id_i;
  reg rd_req_i;
  reg [AxiAddrWidth-1:0] rd_addr_i;
  reg rd_blen_i;
  reg rd_size_i;
  reg [AxiIdWidth-1:0] rd_id_i;
  reg rd_lock_i;
  reg rd_rdy_i;

  // expected outputs
  wire [AXI_DATA_SIZE-1:0] exp_rd_data_o;
  wire exp_rd_user_o;
  wire exp_rd_last_o;
  wire exp_rd_valid_o;
  wire [AxiIdWidth-1:0] exp_rd_id_o;
  wire exp_rd_exokay_o;

  // instantiate the DUT
  axi_adapter2 dut (
    .clk_i      (clk_i    ),
    .rst_ni     (rst_ni   ),
    .wr_req_i   (wr_req_i ),
    .wr_data_i  (wr_data_i),
    .wr_addr_i  (wr_addr_i),
    .wr_blen_i  (wr_blen_i),
    .wr_size_i  (wr_size_i),
    .wr_last_i  (wr_last_i),
    .wr_lock_i  (wr_lock_i),
    .wr_id_i    (wr_id_i  ),
    .wr_gnt_o   (),
    .rd_req_i   (rd_req_i ),
    .rd_addr_i  (rd_addr_i),
    .rd_blen_i  (rd_blen_i),
    .rd_size_i  (rd_size_i),
    .rd_id_i    (rd_id_i  ),
    .rd_lock_i  (rd_lock_i),
    .rd_rdy_i   (rd_rdy_i ),
    .rd_data_o  (exp_rd_data_o),
    .rd_user_o  (exp_rd_user_o),
    .rd_last_o  (exp_rd_last_o),
    .rd_valid_o (exp_rd_valid_o),
    .rd_id_o    (exp_rd_id_o  ),
    .rd_exokay_o(exp_rd_exokay_o)
  );

  // clock generator
  always #5 clk_i = !clk_i;

  // reset generator
  initial begin
    rst_ni = 0;
    repeat (3) @(negedge clk_i);
    rst_ni = 1;
  end

  // stimulus
  reg [AXI_DATA_SIZE-1:0] wr_mem[0:AxiNumWords-1];
  reg [AXI_DATA_SIZE-1:0] rd_mem[0:AxiNumWords-1];
  integer random_seed = T_RANDOM_SEED;
  integer wr_idx = 0;
  integer rd_idx = 0;
  integer i;

  // initialize memories
  initial begin
    for (i = 0; i < AxiNumWords; i = i + 1) begin
      wr_mem[i] = 0;
      rd_mem[i] = 0;
    end
  end

  // random write operations
  initial begin
    for (i = 0; i < T_RAND_NUM; i = i + 1) begin
      // generate random data and address
      wr_data_i = $random(random_seed);
      wr_addr_i = $random(random_seed) % (AxiNumWords * AXI_DATA_SIZE);
      wr_blen_i = ($random(random_seed) % AxiIdWidth) + 1;
      wr_size_i = $clog2(AXI_DATA_SIZE/8);
      wr_last_i = ($random(random_seed) > (2 ** 30));
      wr_lock_i = ($random(random_seed) > (2 ** 31));
      wr_id_i = ($random(random_seed) % (2 ** AxiIdWidth));
      wr_req_i = 1;

      // wait for grant
      repeat (20) @(posedge clk_i);
      while (dut.wr_gnt_o == 0) begin
        repeat (20) @(posedge clk_i);
      end

      // write data
      wr_mem[wr_idx] = wr_data_i;
      wr_req_i = 0;

      // ready for next operation
      wr_idx = (wr_idx + 1) % AxiNumWords;
    end
  end

  // random read operations
  initial begin
    for (i = 0; i < T_RAND_NUM; i = i + 1) begin
      // generate random address
      rd_addr_i = $random(random_seed) % (AxiNumWords * AXI_DATA_SIZE);
      rd_blen_i = ($random(random_seed) % AxiIdWidth) + 1;
      rd_size_i = $clog2(AXI_DATA_SIZE/8);
      rd_id_i = ($random(random_seed) % (2 ** AxiIdWidth));
      rd_lock_i = ($random(random_seed) > (2 ** 31));
      rd_rdy_i = 1;
      rd_req_i = 1;

      // wait for grant
      repeat (20) @(posedge clk_i);
      while (dut.rd_gnt_o == 0) begin
        repeat (20) @(posedge clk_i);
      end

      // read data
      rd_mem[rd_idx] = exp_rd_data_o;
      rd_req_i = 0;

      // ready for next operation
      rd_idx = (rd_idx + 1) % AxiNumWords;
    end
  end

  // check results
  integer i;
  initial begin
    repeat (100) @(posedge clk_i);
    for (i = 0; i < AxiNumWords; i = i + 1) begin
      if (wr_mem[i] !== rd_mem[i]) begin
        $display("[ERROR] Mismatch: wr_mem[%0d] = %h, rd_mem[%0d] = %h", i, wr_mem[i], i, rd_mem[i]);
      end
    end
    $display("[COMPLETED] Test complete");
    $finish;
  end

endmodule // axi_adapter2_test
```