# VerifAI TestGuru
# tests for: ariane_regfile.sv
```
// Testbench for ariane_regfile_lol

module ariane_regfile_lol_tb;

  // Inputs
  logic clk;
  logic rst;
  logic test_en;
  logic [NR_READ_PORTS-1:0][4:0] raddr;
  logic [NR_READ_PORTS-1:0][DATA_WIDTH-1:0] rdata;
  logic [NR_WRITE_PORTS-1:0][4:0] waddr;
  logic [NR_WRITE_PORTS-1:0][DATA_WIDTH-1:0] wdata;
  logic [NR_WRITE_PORTS-1:0] we;

  // Outputs
  logic [NR_READ_PORTS-1:0][DATA_WIDTH-1:0] q;

  // Instantiate the DUT
  ariane_regfile_lol #(
    .DATA_WIDTH(DATA_WIDTH),
    .NR_READ_PORTS(NR_READ_PORTS),
    .NR_WRITE_PORTS(NR_WRITE_PORTS),
    .ZERO_REG_ZERO(ZERO_REG_ZERO)
  ) dut(
    .clk(clk),
    .rst(rst),
    .test_en(test_en),
    .raddr(raddr),
    .rdata(rdata),
    .waddr(waddr),
    .wdata(wdata),
    .we(we)
  );

  // Testbench
  initial begin
    // Initialize all registers to 0
    for (int i = 0; i < NUM_WORDS; i++) begin
      q[i] = '0;
    end

    // Set clock to 0
    clk = 0;
    #10;

    // Set clock to 1
    clk = 1;
    #10;

    // Write to register 0
    waddr = 0;
    wdata = 10;
    we = 1;
    #10;

    // Read from register 0
    raddr = 0;
    #10;

    // Check that the register value is correct
    assert(q[0] == 10);

    // Reset the DUT
    rst = 1;
    #10;
    rst = 0;
    #10;

    // Write to register 1
    waddr = 1;
    wdata = 20;
    we = 1;
    #10;

    // Read from register 1
    raddr = 1;
    #10;

    // Check that the register value is correct
    assert(q[1] == 20);

    // Cleanup
    #10;
    $finish;
  end

endmodule
```