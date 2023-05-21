# VerifAI TestGuru
# Explanation for: ariane_regfile_ff.sv
## Test Bench and Test Code for Ariane_Regfile
The following test bench and test code verifies the functionality of the Ariane_Regfile module for different values of read and write ports. 

```
`timescale 1ns / 1ps
module ariane_regfile_tb();

  //Parameters
  localparam NR_READ_PORTS  = 2;
  localparam NR_WRITE_PORTS = 2;
  localparam DATA_WIDTH     = 32;
 
  // Inputs
  reg clk_i;
  reg rst_ni;
  reg test_en_i;             // disable clock gates for testing
  reg [NR_READ_PORTS-1:0][4:0] raddr_i;
  reg [NR_WRITE_PORTS-1:0][4:0] waddr_i;
  reg [NR_WRITE_PORTS-1:0][DATA_WIDTH-1:0] wdata_i;
  reg [NR_WRITE_PORTS-1:0] we_i;

  // Outputs
  wire [NR_READ_PORTS-1:0][DATA_WIDTH-1:0] rdata_o;

  //Instantiate the Unit Under Test (UUT)
  ariane_regfile dut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .test_en_i(test_en_i),
    .raddr_i(raddr_i),
    .rdata_o(rdata_o),
    .waddr_i(waddr_i),
    .wdata_i(wdata_i),
    .we_i(we_i)
  );
  
  //Clock for TB
  initial begin
    clk_i = 0;
    forever #5 clk_i = ~clk_i;
  end

  //Reset for TB
  initial begin
    rst_ni = 1;
    #10 rst_ni = 0;
    #10 rst_ni = 1;
  end

  //Test Cases
  initial begin
    //Initialize write and read ports
    waddr_i[0] = 1; we_i[0] = 1; wdata_i[0] = 924232; //Write data to register 1
    waddr_i[1] = 2; we_i[1] = 1; wdata_i[1] = 3432; //Write data to register 2
    raddr_i[0] = 1; raddr_i[1] = 2; //Read the data from register 1 and register 2
    #20;
    //Testcase 1
    //Check for the expected results
    if(rdata_o[0] == 924232 && rdata_o[1] == 3432) begin
      $display("Testcase 1 Passed : Read Data : %d %d", rdata_o[0], rdata_o[1]);
    end
    else begin
      $display("Testcase 1 Failed : Read Data : %d %d", rdata_o[0], rdata_o[1]);
    end

    //Testcase 2
    //Initialize write and read ports with different values
    waddr_i[0] = 13; we_i[0] = 1; wdata_i[0] = 100; //Write data to register 13
    waddr_i[1] = 14; we_i[1] = 1; wdata_i[1] = 200; //Write data to register 14
    raddr_i[0] = 13; raddr_i[1] = 14; //Read the data from register 13 and register 14
    #20;
    //Check for the expected results
    if(rdata_o[0] == 100 && rdata_o[1] == 200) begin
      $display("Testcase 2 Passed : Read Data : %d %d", rdata_o[0], rdata_o[1]);
    end
    else begin
      $display("Testcase 2 Failed : Read Data : %d %d", rdata_o[0], rdata_o[1]);
    end
    
    //Testcase 3
    //Initialize write and read ports with same register value
    waddr_i[0] = 5; we_i[0] = 1; wdata_i[0] = 1000; //Write data to register 13
    waddr_i[1] = 5; we_i[1] = 1; wdata_i[1] = 1234; //Write same register with new value
    raddr_i[0] = 5; raddr_i[1] = 5; //Read the data from register 5
    #20;
    //Check for the expected results
    if(rdata_o[0] == 1234 && rdata_o[1] == 1234) begin
      $display("Testcase 3 Passed : Read Data : %d %d", rdata_o[0], rdata_o[1]);
    end
    else begin
      $display("Testcase 3 Failed : Read Data : %d %d", rdata_o[0], rdata_o[1]);
    end 
    
  end

endmodule

```
We can run this test bench using an EDA tool like Vivado and simulate the functionality of the Ariane_Regfile module. The test bench provides 3 test cases to check the functionality of the module for different combinations of write and read ports. The expected results are printed on the simulation console.