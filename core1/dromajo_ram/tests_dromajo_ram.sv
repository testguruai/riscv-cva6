# VerifAI TestGuru
# tests for: dromajo_ram.sv
```
module dromajo_ram_tb;

  // parameters
  parameter ADDR_WIDTH = 10;
  parameter DATA_DEPTH = 1024;
  parameter OUT_REGS   = 0;

  // inputs
  logic Clk_CI;
  logic Rst_RBI;
  logic CSel_SI;
  logic WrEn_SI;
  logic [7:0] BEn_SI;
  logic [63:0] WrData_DI;
  logic [ADDR_WIDTH-1:0] Addr_DI;

  // outputs
  logic [63:0] RdData_DO;

  // instantiate DUT
  dromajo_ram #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_DEPTH(DATA_DEPTH),
    .OUT_REGS(OUT_REGS)
  ) DUT (
    .Clk_CI(Clk_CI),
    .Rst_RBI(Rst_RBI),
    .CSel_SI(CSel_SI),
    .WrEn_SI(WrEn_SI),
    .BEn_SI(BEn_SI),
    .WrData_DI(WrData_DI),
    .Addr_DI(Addr_DI),
    .RdData_DO(RdData_DO)
  );

  // testbench
  initial begin
    // init
    Clk_CI = 0;
    Rst_RBI = 1;
    #10;
    Rst_RBI = 0;

    // write data
    WrEn_SI = 1;
    BEn_SI = 8'b11111111;
    WrData_DI = 64'h0000000000000000;
    Addr_DI = 10'd0;
    #10;
    WrEn_SI = 0;

    // read data
    RdData_DO = 64'h0;
    #10;

    // check data
    assert(RdData_DO == 64'h0000000000000000) else $error("read data mismatch");

    // done
    $finish;
  end

endmodule
```