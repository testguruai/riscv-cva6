# VerifAI TestGuru
# tests for: ariane_regfile_ff.sv
```
```

```
module ariane_regfile_tb;

  // Parameters
  parameter int unsigned DATA_WIDTH = 32;
  parameter int unsigned NR_READ_PORTS = 2;
  parameter int unsigned NR_WRITE_PORTS = 2;
  parameter bit          ZERO_REG_ZERO = 0;

  // Clock and reset
  logic clk;
  logic rst;

  // Testbench stimulus
  logic [NR_WRITE_PORTS-1:0][4:0] waddr;
  logic [NR_WRITE_PORTS-1:0][DATA_WIDTH-1:0] wdata;
  logic [NR_WRITE_PORTS-1:0] we;

  // DUT
  ariane_regfile #(
    .DATA_WIDTH(DATA_WIDTH),
    .NR_READ_PORTS(NR_READ_PORTS),
    .NR_WRITE_PORTS(NR_WRITE_PORTS),
    .ZERO_REG_ZERO(ZERO_REG_ZERO)
  ) regfile (
    .clk_i(clk),
    .rst_ni(rst),
    .raddr_i(raddr),
    .rdata_o(rdata),
    .waddr_i(waddr),
    .wdata_i(wdata),
    .we_i(we)
  );

  // Testbench stimulus generation
  initial begin
    clk = 1'b0;
    rst = 1'b1;
    #10;
    rst = 1'b0;

    // Write to register 0
    waddr = '0;
    wdata = '0;
    we = '1;
    #10;

    // Write to register 1
    waddr = '1;
    wdata = '1;
    we = '1;
    #10;

    // Read from register 0
    raddr = '0;
    #10;

    // Read from register 1
    raddr = '1;
    #10;

    // Stop the simulation
    $stop;
  end

  // DUT monitor
  always @(posedge clk) begin
    $display("rdata_o = %x", rdata);
  end

endmodule
```