# VerifAI TestGuru
# Explanation for: ariane_regfile_ff.sv
# UVM Test Bench for ariane_regfile

The following is a UVM Test Bench for the `ariane_regfile` module. The test bench instantiates an `ariane_regfile` DUT and drives it with various transactions through its `we_i` and `raddr_i` interfaces. The output from the `rdata_o` interface is then compared to the input data for correctness.

```systemverilog
`include "uvm_macros.svh"

module ariane_regfile_tb;

  import uvm_pkg::*;

  `uvm_component_param_utils(ariane_regfile_tb)

  // DUT
  ariane_regfile #(
    .DATA_WIDTH(32),
    .NR_READ_PORTS(2),
    .NR_WRITE_PORTS(2),
    .ZERO_REG_ZERO(0)
  ) dut();

  // UVM Test Bench
  initial begin
    uvm_component comp;
    comp = new("test_bench");
    ariane_regfile_tb tb;
    tb = ariane_regfile_tb::type_id::create("tb", comp);
    tb.dut = dut;

    run_test();
  end

  // UVM Test
  task run_test();
    // Create UVM Test
    uvm_test test = ariane_regfile_test::type_id::create("ariane_regfile_test");

    // Create UVM Test Sequences
    ariane_regfile_write_seq wr_seq;
    ariane_regfile_read_seq rd_seq;

    // Add all UVM Test Sequences to UVM Test Case
    test.add_seq(wr_seq);
    test.add_seq(rd_seq);

    // Set the UVM Test as the active test
    uvm_top.print_banner("Starting Test");
    run_test(test);
  end

endmodule
```

# UVM Test for ariane_regfile

The following is a UVM test case for the `ariane_regfile` DUT. The test case defines a number of test sequences to write and read values to and from the register file. It then checks that the read data matches the expected data.

```systemverilog
class ariane_regfile_test extends uvm_test;

  `uvm_component_utils(ariane_regfile_test)

  // DUT
  ariane_regfile #(
    .DATA_WIDTH(32),
    .NR_READ_PORTS(2),
    .NR_WRITE_PORTS(2),
    .ZERO_REG_ZERO(0)
  ) dut;

  // Expected data
  bit [31:0] data[NUM_WORDS];

  virtual function void build_data();
    data[0] = 32'h00000000;
    for (int i = 1; i < NUM_WORDS; i++) begin
      data[i] = $random();
    end
  endfunction

  // UVM Test Sequences
  virtual class ariane_regfile_write_seq extends uvm_sequence #(logic [NR_WRITE_PORTS-1:0][DATA_WIDTH-1:0]);
    `uvm_object_utils(ariane_regfile_write_seq)

    ariane_regfile #(
      .DATA_WIDTH(32),
      .NR_READ_PORTS(2),
      .NR_WRITE_PORTS(2),
      .ZERO_REG_ZERO(0)
    ) dut;

    // Data to be written
    logic [NR_WRITE_PORTS-1:0][DATA_WIDTH-1:0] data;

    function new(string name="ariane_regfile_write_seq");
      super.new(name);
    endfunction

    virtual task body();
      int unsigned n = 10;
      for (int i = 0; i < n; i++) begin
        for (int j = 0; j < NR_WRITE_PORTS; j++) begin
          data[j] = $cast(dut.mem[i]);
        end
        for (int j = 0; j < NR_WRITE_PORTS; j++) begin
          data[j] = $random();
          dut.we_dec[j][i] = 1;
          dut.mem[i] = data[j];
          @(posedge dut.clk_i);
          dut.we_dec[j][i] = 0;
        end
        `uvm_do_with(data)
      end
    endtask

  endclass

  virtual class ariane_regfile_read_seq extends uvm_sequence #(logic [NR_READ_PORTS-1:0][4:0]);
    `uvm_object_utils(ariane_regfile_read_seq)

    ariane_regfile #(
      .DATA_WIDTH(32),
      .NR_READ_PORTS(2),
      .NR_WRITE_PORTS(2),
      .ZERO_REG_ZERO(0)
    ) dut;

    // Addresses to be read
    logic [NR_READ_PORTS-1:0][4:0] addr;

    function new(string name="ariane_regfile_read_seq");
      super.new(name);
    endfunction

    virtual task body();
      int unsigned n = 10;
      for (int i = 0; i < n; i++) begin
        for (int j = 0; j < NR_READ_PORTS; j++) begin
          addr[j] = $random() % NUM_WORDS;
          dut.raddr_i[j] = addr[j];
        end
        @(posedge dut.clk_i);
        for (int j = 0; j < NR_READ_PORTS; j++) begin
          if (dut.rdata_o[j] !== dut.mem[addr[j]]) begin
            `uvm_fatal("Read Data Mismatch", $sformatf("Expected: %h Actual: %h", dut.mem[addr[j]], dut.rdata_o[j]))
          end
        end
        `uvm_do_with(addr)
      end
    endtask

  endclass

  // UVM Test Constraints
  virtual class ariane_regfile_test_constraints extends uvm_constraints;
    `uvm_object_utils(ariane_regfile_test_constraints)

    ariane_regfile_test test;

    function new(string name="ariane_regfile_test_constraints", ariane_regfile_test test);
      super.new(name);
      this.test = test;
    endfunction

    virtual function void post_randomize();
      test.build_data();
    endfunction

  endclass

  // UVM Test Environment
  virtual class ariane_regfile_test_env extends uvm_env;
    `uvm_component_utils(ariane_regfile_test_env)

    ariane_regfile #(
      .DATA_WIDTH(32),
      .NR_READ_PORTS(2),
      .NR_WRITE_PORTS(2),
      .ZERO_REG_ZERO(0)
    ) dut;

    // UVM Test Constraints
    ariane_regfile_test_constraints constraints;

    function new(string name="ariane_regfile_test_env", uvm_component parent);
      super.new(name, parent);
      constraints = ariane_regfile_test_constraints::type_id::create("constraints", this);
    endfunction

  endclass

  // UVM Test Setup
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Randomize test environment
    ariane_regfile_test_env env = ariane_regfile_test_env::type_id::create("env", this);
    env.dut = dut;
    env.randomize();
  endfunction

endclass
```