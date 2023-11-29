// VerifAI TestGuru
 // tests for: ariane_regfile_ff.sv
systemverilog
`include "uvm_macros.svh"

class ariane_regfile_test extends uvm_test;

  `uvm_component_utils(ariane_regfile_test)

  ariane_regfile #(32, 2, 2, 0) regfile;

  task initial begin
    regfile.clk_i = 0;
    regfile.rst_ni = 0;
    regfile.test_en_i = 1;
    regfile.waddr_i[0] = 1;
    regfile.wdata_i[0] = 10;
    regfile.we_i[0] = 1;
    regfile.waddr_i[1] = 2;
    regfile.wdata_i[1] = 20;
    regfile.we_i[1] = 1;

    #10;
    regfile.raddr_i[0] = 1;
    fork
      @(posedge regfile.clk_i);
      fork
        @(posedge regfile.clk_i);
        if (regfile.rdata_o[0] == 10)
          $display("Read data from register 1 is correct");
        else
          $display("Read data from register 1 is incorrect");
      end
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 10)
        $display("Read data from register 1 is correct");
      else
        $display("Read data from register 1 is incorrect");
      @(posedge regfile.clk_i);
    join_any

    @(posedge regfile.clk_i);
    regfile.raddr_i[0] = 2;
    #10;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 20)
        $display("Read data from register 2 is correct");
      else
        $display("Read data from register 2 is incorrect");
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 20)
        $display("Read data from register 2 is correct");
      else
        $display("Read data from register 2 is incorrect");
    join_any

    #10;
    regfile.raddr_i[0] = 3;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 0)
        $display("Read data from register 3 is correct");
      else
        $display("Read data from register 3 is incorrect");
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 0)
        $display("Read data from register 3 is correct");
      else
        $display("Read data from register 3 is incorrect");
    join_any

    @(posedge regfile.clk_i);
    regfile.rst_ni = 1;

    #10;
    regfile.raddr_i[0] = 1;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 0)
        $display("Read data from register 1 is correct after reset");
      else
        $display("Read data from register 1 is incorrect after reset");
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 0)
        $display("Read data from register 1 is correct after reset");
      else
        $display("Read data from register 1 is incorrect after reset");
    join_any

    #10;
    regfile.raddr_i[0] = 2;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 0)
        $display("Read data from register 2 is correct after reset");
      else
        $display("Read data from register 2 is incorrect after reset");
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 0)
        $display("Read data from register 2 is correct after reset");
      else
        $display("Read data from register 2 is incorrect after reset");
    join_any

    #10;
    regfile.raddr_i[0] = 3;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 0)
        $display("Read data from register 3 is correct after reset");
      else
        $display("Read data from register 3 is incorrect after reset");
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 0)
        $display("Read data from register 3 is correct after reset");
      else
        $display("Read data from register 3 is incorrect after reset");
    join_any

    #10;
    regfile.clk_i = 1;
    @(posedge regfile.clk_i);
    regfile.raddr_i[0] = 0;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 0)
        $display("Read data from R0 is correct");
      else
        $display("Read data from R0 is incorrect");
    join_any

    #10;
    regfile.waddr_i[0] = 0;
    regfile.we_i[0] = 0;
    fork
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 0)
        $display("Read data from R0 is correct after write disable");
      else
        $display("Read data from R0 is incorrect after write disable");
    join_any

    #10;
    regfile.waddr_i[0] = 0;
    regfile.wdata_i[0] = 100;
    regfile.we_i[0] = 1;
    fork
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 100)
        $display("Read data from R0 is correct after write enable");
      else
        $display("Read data from R0 is incorrect after write enable");
    join_any

    #10;
    regfile.raddr_i[0] = 0;
    fork
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 100)
        $display("Read data from R0 is correct after write");
      else
        $display("Read data from R0 is incorrect after write");
    join_any

    #10;
    regfile.raddr_i[0] = 1;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 10)
        $display("Read data from register 1 is correct after write");
      else
        $display("Read data from register 1 is incorrect after write");
    join_any

    #10;
    regfile.raddr_i[0] = 2;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 20)
        $display("Read data from register 2 is correct after write");
      else
        $display("Read data from register 2 is incorrect after write");
    join_any

    #10;
    regfile.raddr_i[1] = 1;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[1] == 10)
        $display("Read data from register 1 of port 1 is correct");
      else
        $display("Read data from register 1 of port 1 is incorrect");
    join_any

    #10;
    regfile.raddr_i[1] = 2;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[1] == 20)
        $display("Read data from register 2 of port 1 is correct");
      else
        $display("Read data from register 2 of port 1 is incorrect");
    join_any

    #10;
    regfile.waddr_i[1] = 2;
    regfile.wdata_i[1] = 200;
    regfile.we_i[1] = 1;
    fork
      @(posedge regfile.clk_i);
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[1] == 200)
        $display("Read data from register 2 of port 2 is correct after write");
      else
        $display("Read data from register 2 of port 2 is incorrect after write");
    join_any

    #10;
    regfile.raddr_i[1] = 2;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[1] == 200)
        $display("Read data from register 2 of port 2 is correct after write");
      else
        $display("Read data from register 2 of port 2 is incorrect after write");
    join_any

    #10;
    regfile.raddr_i[1] = 1;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[1] == 10)
        $display("Read data from register 1 of port 2 is correct after write");
      else
        $display("Read data from register 1 of port 2 is incorrect after write");
    join_any

    #10;
    regfile.test_en_i = 0;
    regfile.waddr_i[0] = 1;
    regfile.wdata_i[0] = 50;
    regfile.we_i[0] = 1;
    regfile.waddr_i[1] = 1;
    regfile.wdata_i[1] = 100;
    regfile.we_i[1] = 1;

    #10;
    regfile.raddr_i[0] = 1;
    fork
      @(posedge regfile.clk_i);
      if (regfile.rdata_o[0] == 10)
        $display("Read data from register 1 is correct after disabling test");
      else
        $display("Read data from register 1 is incorrect after disabling test");
      @(posedge regfile