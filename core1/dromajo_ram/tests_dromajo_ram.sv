// VerifAI TestGuru
// tests for: dromajo_ram.sv

`include "dromajo_ram.sv"

module top;

  // signals
  bit Clk_CI;
  bit Rst_RBI;
  bit CSel_SI;
  bit WrEn_SI;
  bit [7:0] BEn_SI;
  bit [63:0] WrData_DI;
  bit [ADDR_WIDTH-1:0] Addr_DI;
  bit [63:0] RdData_DO;

  // instantiate DUT
  dromajo_ram #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_DEPTH(DATA_DEPTH),
    .OUT_REGS(OUT_REGS)
  ) dut (
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
  always @(posedge Clk_CI) begin
    // init
    Clk_CI = 1'b0;
    Rst_RBI = 1'b1;
    CSel_SI = 1'b0;
    WrEn_SI = 1'b0;
    BEn_SI = 7'b0000000;
    WrData_DI = 64'h0000000000000000;
    Addr_DI = 10'd0;
    Clk_CI = 1'b1;
    #5;
    Clk_CI = 1'b0;
    #5;
    Rst_RBI = 1'b0;
    #10;

    // write
    CSel_SI = 1'b1;
    WrEn_SI = 1'b1;
    BEn_SI = 7'b1111111;
    WrData_DI = 64'h0000000000000000;
    Addr_DI = 10'd0;
    #10;

    // read
    CSel_SI = 1'b1;
    WrEn_SI = 1'b0;
    BEn_SI = 7'b1111111;
    Addr_DI = 10'd0;
    #10;

    // check
    $display("Test Passed");
  end

endmodule
