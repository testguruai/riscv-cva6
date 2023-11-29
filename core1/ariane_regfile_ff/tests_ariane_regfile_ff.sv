// VerifAI TestGuru
// Tests for: ariane_regfile_ff.sv

`timescale 1ns / 1ps

module ariane_regfile_tb;

  // Parameters
  parameter int unsigned DATA_WIDTH     = 32;
  parameter int unsigned NR_READ_PORTS  = 2;
  parameter int unsigned NR_WRITE_PORTS = 2;
  parameter logic        ZERO_REG_ZERO  = 0;

  // Inputs
  input logic clk_i;
  input logic rst_ni;
  input logic test_en_i;
  input logic [NR_READ_PORTS-1:0][4:0] raddr_i;
  output logic [NR_READ_PORTS-1:0][DATA_WIDTH-1:0] rdata_o;
  input logic [NR_WRITE_PORTS-1:0][4:0] waddr_i;
  input logic [NR_WRITE_PORTS-1:0][DATA_WIDTH-1:0] wdata_i;
  input logic [NR_WRITE_PORTS-1:0] we_i;

  // Outputs
  // Instantiate the DUT
  ariane_regfile #(
    .DATA_WIDTH     (DATA_WIDTH),
    .NR_READ_PORTS  (NR_READ_PORTS),
    .NR_WRITE_PORTS (NR_WRITE_PORTS),
    .ZERO_REG_ZERO  (ZERO_REG_ZERO)
  ) DUT (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .test_en_i(test_en_i),
    .raddr_i(raddr_i),
    .rdata_o(rdata_o),
    .waddr_i(waddr_i),
    .wdata_i(wdata_i),
    .we_i(we_i)
  );

  // Testbench
  initial begin
    // Initialize the DUT
    clk_i = 0;
    rst_ni = 1;
    test_en_i = 0;
    #10;
    rst_ni = 0;
    test_en_i = 1;

    // Write to register 1
    waddr_i[0] = 0;
    waddr_i[1] = 0;
    wdata_i[0] = 10'b10;
    wdata_i[1] = 20'b10;
    we_i[0] = 1;
    we_i[1] = 1;
    #10;

    // Read from register 1
    raddr_i[0] = 0;
    raddr_i[1] = 0;
    #10;

    // Check the results
    if (rdata_o[0] !== 10'b10) begin
      $error("rdata_o[0] != 10");
    end
    if (rdata_o[1] !== 20'b10) begin
      $error("rdata_o[1] != 20");
    end

    // Stop the simulation
    $finish;
  end

endmodule
