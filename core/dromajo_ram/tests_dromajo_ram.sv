# VerifAI TestGuru
# Explanation for: dromajo_ram.sv
## UVM Test Bench Markdown Code

```markdown
# Dromajo RAM UVM Test Bench

This is the test bench for the Dromajo RAM module.

## Test Cases

### Write and Read

#### Description
Write data to the RAM, read it back, and compare it.

#### Test
1. Randomly generate write data and address.
2. Write to the RAM using the generated data and address.
3. Read from the RAM using the generated address.
4. Compare the read data to the written data.

### Read after Reset

#### Description
Write data to the RAM, reset the RAM, and read the data back.

#### Test
1. Randomly generate write data and address.
2. Write to the RAM using the generated data and address.
3. Reset the RAM.
4. Read from the RAM using the generated address.
5. Compare the read data to zero.

```

## UVM Test Code

```systemverilog
`include "uvm_macros.svh"

module testbench;

  import uvm_pkg::*;
  `include "dromajo_ram.sv"

  // The DUT
  dromajo_ram mem(.Clk_CI(Clk_CI),
                  .Rst_RBI(Rst_RBI),
                  .CSel_SI(CSel_SI),
                  .WrEn_SI(WrEn_SI),
                  .BEn_SI(BEn_SI),
                  .WrData_DI(WrData_DI),
                  .Addr_DI(Addr_DI),
                  .RdData_DO(RdData_DO));

  // The test
  class dromajo_ram_test extends uvm_test;
    `uvm_component_utils(dromajo_ram_test)

    // Inside here, we set up the environment
    virtual task run_phase(uvm_phase phase);
      forever begin
        // Run test case 1
        start_test("Write and Read");

        // Generate random data and address
        int unsigned data = $urandom_range(0, (1<<64)-1);
        int unsigned addr = $urandom_range(0, (1<<ADDR_WIDTH)-1);

        // Write to the RAM
        @(posedge mem.Clk_CI);
        mem.CSel_SI = 1;
        mem.WrEn_SI = 1;
        mem.BEn_SI = 8'hFF;
        mem.WrData_DI = data;
        mem.Addr_DI = addr;
        @(posedge mem.Clk_CI);
        mem.CSel_SI = 0;
        mem.WrEn_SI = 0;

        // Read from the RAM and compare
        @(posedge mem.Clk_CI);
        mem.CSel_SI = 1;
        mem.WrEn_SI = 0;
        mem.BEn_SI = 8'hFF;
        mem.Addr_DI = addr;
        @(posedge mem.Clk_CI);
        if (mem.RdData_DO != data)
          `uvm_error("WRITE AND READ TEST", $sformatf("Data mismatch: expected %h, got %h", data, mem.RdData_DO));
        mem.CSel_SI = 0;
        mem.WrEn_SI = 0;

        finish_testcase();

        // Run test case 2
        start_test("Read after Reset");

        // Generate random data and address
        data = $urandom_range(0, (1<<64)-1);
        addr = $urandom_range(0, (1<<ADDR_WIDTH)-1);

        // Write to the RAM
        @(posedge mem.Clk_CI);
        mem.CSel_SI = 1;
        mem.WrEn_SI = 1;
        mem.BEn_SI = 8'hFF;
        mem.WrData_DI = data;
        mem.Addr_DI = addr;
        @(posedge mem.Clk_CI);
        mem.CSel_SI = 0;
        mem.WrEn_SI = 0;

        // Reset the RAM
        @(posedge mem.Clk_CI);
        mem.Rst_RBI = 1;
        @(posedge mem.Clk_CI);
        mem.Rst_RBI = 0;

        // Read from the RAM and compare
        @(posedge mem.Clk_CI);
        mem.CSel_SI = 1;
        mem.WrEn_SI = 0;
        mem.BEn_SI = 8'hFF;
        mem.Addr_DI = addr;
        @(posedge mem.Clk_CI);
        if (mem.RdData_DO != 0)
          `uvm_error("READ AFTER RESET TEST", $sformatf("Data mismatch: expected 0, got %h", mem.RdData_DO));
        mem.CSel_SI = 0;
        mem.WrEn_SI = 0;

        finish_testcase();
      end
    endtask
  endclass

  // The environment
  class env extends uvm_env;
    `uvm_component_utils(env)

    // Inside here, we connect the test to the DUT
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction
  endclass

  // The agent
  class agent extends uvm_agent;
    `uvm_component_utils(agent)

    // Inside here, we set up the sequence, driver, and monitor
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
      class seq extends uvm_sequence;
        `uvm_object_utils(seq)

        virtual task body();
        endtask
      endclass

      class drv extends uvm_driver;
        `uvm_component_utils(drv)

        function new(string name, uvm_component parent);
          super.new(name, parent);
        endfunction

        virtual task run_phase(uvm_phase phase);
        endtask
      endclass

      class mon extends uvm_monitor;
        `uvm_component_utils(mon)

        function new(string name, uvm_component parent);
          super.new(name, parent);
        endfunction

        virtual function void run_phase(uvm_phase phase);
        endfunction
      endclass

      seq my_seq;
      drv my_drv;
      mon my_mon;

      my_seq = seq::type_id::create("my_seq", this);
      my_drv = drv::type_id::create("my_drv", this);
      my_mon = mon::type_id::create("my_mon", this);

      my_seq.start(my_drv);
      my_drv.start_item(my_seq);
      my_mon.start(my_drv);

      `uvm_info("AGENT", $sformatf("Sequence started"), UVM_LOW)

      my_mon.wait_for_sequences();

      `uvm_info("AGENT", $sformatf("Sequence ended"), UVM_LOW)

      my_drv.stop_item(my_seq);
      my_mon.stop();
    endtask
  endclass

  // The top level
  class top extends uvm_test_top;
    `uvm_component_utils(top)

    env my_env;
    agent my_agent;
    dromajo_ram_test my_test;

    function new(string name = "top", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      my_env = env::type_id::create("my_env", this);
      my_agent = agent::type_id::create("my_agent", this);
      my_test = dromajo_ram_test::type_id::create("my_test", this);

      phase.connect(my_agent.ap, my_agent.mp);
      phase.connect(my_test.ap, my_agent.ap);

      with (my_agent.driver);
      //   set slave_handle.vif = slave.vif;
      endwith
    endfunction
  endclass

  initial begin
    top t = top::type_id::create("t");
    uvm_config_db#(uvm_object_wrapper)::set(null, "uvm_test_top.env.top.my_test", "vseq_type", seq::type_id::get());
    run_test();
  end

endmodule
```