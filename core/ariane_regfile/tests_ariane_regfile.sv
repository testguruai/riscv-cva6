# VerifAI TestGuru
# Explanation for: ariane_regfile.sv
## Test Bench and Test code for the Ariane_regfile_lol module

The following is a test bench and test code for the Ariane_regfile_lol module. 

```systemverilog
`timescale 1ns / 1ps

module tb_ariane_regfile_lol;

    // Parameters
    localparam DATA_WIDTH     = 32;
    localparam NR_READ_PORTS  = 2;
    localparam NR_WRITE_PORTS = 2;

    // Inputs
    reg clk_i;
    reg rst_ni;
    reg test_en_i;
    reg [NR_READ_PORTS-1:0][4:0] raddr_i;
    reg [NR_WRITE_PORTS-1:0][4:0] waddr_i;
    reg [NR_WRITE_PORTS-1:0][DATA_WIDTH-1:0] wdata_i;
    reg [NR_WRITE_PORTS-1:0] we_i;

    // Outputs
    wire [NR_READ_PORTS-1:0][DATA_WIDTH-1:0] rdata_o;

    // Instantiate the Ariane_regfile_lol module
    ariane_regfile_lol #(
      .DATA_WIDTH(DATA_WIDTH),
      .NR_READ_PORTS(NR_READ_PORTS),
      .NR_WRITE_PORTS(NR_WRITE_PORTS)
    ) dut (
      .clk_i(clk_i),
      .rst_ni(rst_ni),
      .test_en_i(test_en_i),
      .raddr_i(raddr_i),
      .rdata_o(rdata_o),
      .waddr_i(waddr_i),
      .wdata_i(wdata_i),
      .we_i(we_i)
    );

    always #5 clk_i = ~clk_i;

    initial begin
        // Reset
        rst_ni = 0;
        test_en_i = 0;
        waddr_i[0] = 5'd0;
        wdata_i[0] = 32'd123;
        we_i[0] = 1'b1;
        #10;
        rst_ni = 1;
        #200;

        // Write to address 5'd0
        waddr_i[0] = 5'd0;
        wdata_i[0] = 32'd123;
        we_i[0] = 1'b1;
        #10;

        // Read from address 5'd0
        raddr_i[0] = 5'd0;
        #10;

        // Write to address 5'd1
        waddr_i[1] = 5'd1;
        wdata_i[1] = 32'd987;
        we_i[1] = 1'b1;
        #10;

        // Read from address 5'd1
        raddr_i[1] = 5'd1;
        #10;

        $finish;
    end

endmodule
```

The test bench performs the following operations:

1.  Reset the module and set `test_en_i` to low
2.  Write data 123 to address 0 in write port 0
3.  Read data from address 0 in read port 0
4.  Write data 987 to address 1 in write port 1
5.  Read data from address 1 in read port 1
6.  Finish the simulation

The values written to the module are checked manually.