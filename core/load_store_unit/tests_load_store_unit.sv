# VerifAI TestGuru
# Explanation for: load_store_unit.sv
# UVM Test Bench and Test Code for Load Store Unit

The Load Store Unit in the verilog code given is responsible for address calculation and memory interface signals. To verify the Load Store Unit, we will create a UVM test bench with two agents: one driver and one monitor. The driver will drive valid load and store transactions to the input of the Load Store Unit and the monitor will check the output of the Load Store Unit for correctness. 

## UVM Test Bench

The UVM test bench for the Load Store Unit will have the following components:

- lsu_tb: The test bench module which instantiates the driver and monitor agents and controls test execution.
- lsu_driver: The driver agent which generates valid load and store transactions to the input of the Load Store Unit.
- lsu_monitor: The monitor agent which checks the output of the Load Store Unit for correctness.

```systemverilog
  `include "uvm_macros.svh"

  module lsu_tb;

    import uvm_pkg::*;
    import ariane_pkg::*;
    import riscv_pkg::*;
    
    // Component Instantiations
    lsu_driver driver;
    lsu_monitor monitor;
    load_store_unit dut;

    // Clock and Reset
    logic clk;
    logic reset;

    // Test Case Configuration
    uvm_test_done_cb test_done_callback;
    uvm_event e_start;
    uvm_event e_done;

    // UVM Phases
    initial begin
      e_start = new();
      e_done = new();
      run_test();
    end

    // Test execution
    task run_test();

      // Reset and Clock Generation
      clk = 1'b0;
      forever #5 clk = ~clk;
      reset = 1'b0;
      #15 reset = 1'b1;
      #25 reset = 1'b0;

      // Component Instantiation
      dut = new("dut");
      
      // Agent Instantiation
      driver = lsu_driver::type_id::create("driver", null);
      monitor = lsu_monitor::type_id::create("monitor", null);
      
      // Connectivity
      driver.lsu_req_port.connect(dut.lsu_req_ports_i[0]);
      dut.dcache_req_ports_i[0].connect(monitor.dcache_req_port);
      
      // Configuration
      driver.vif.reset  = reset;
      driver.vif.clk_i  = clk;
      monitor.vif.reset = reset;
      monitor.vif.clk_i = clk;

      // Set the seed for the randomization
      int seed = $random();

      // Start of Test
      fork
        begin
          uvm_report_info(get_type_name(), $sformatf("SEED=%d", seed), UVM_NONE);
          start_item(driver, seed);
          driver.put_drivers();
          finish_item(driver);
          e_start.trigger(clk);
          #10000;
          e_done.trigger(clk);
        end
      join_any

      // End of Test
      driver.vif.load_ready_o = 1'b1;
      driver.vif.store_ready_o = 1'b1;
      driver.end_of_test();
      test_done_callback();
    endfunction : run_test

    // Callback function to end the test
    function void uvm_test_done_cb;
      $display("LSU test done");
      finish;
    endfunction : uvm_test_done_cb

  endmodule : lsu_tb
```

## UVM Driver Agent

The driver agent is responsible for generating valid load and store transactions to the input of the Load Store Unit. 

```systemverilog
  class lsu_driver extends uvm_driver #(lsu_req_t);

    `uvm_component_utils(lsu_driver)

    virtual lsu_tb_vif vif;
    rand lsu_req_t req;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      vif = lsu_tb_vif::type_id::create("vif", this);
    endfunction : build_phase

    // Override run_phase of the uvm_driver
    task run_phase(uvm_phase phase);
      // Wait for the test case to start
      @(vif.clk_i) vif.clk_i;
      @(vif.clk_i) vif.clk_i;
      @(vif.clk_i) vif.clk_i;

      // Generate load and store transactions
      forever begin
        @(vif.clk_i) vif.clk_i;
        if (!req.valid) begin
          req.trans_type = $random() % 2 == 0 ? LSU_LOAD : LSU_STORE;
          req.addr = $urandom_range(0, (1<<riscv::VLEN)-1);
          req.data = $urandom_range(0, (1<<riscv::XLEN)-1);
          req.valid = 1;
        end else begin
          if (vif.load_valid_i || vif.store_valid_i) begin
            req.valid = 0;
          end
        end
      end
    endtask : run_phase

    // Put load and store requests to the input of the Load Store Unit
    task put_drivers();
      `uvm_do(req)
        vif.load_req_o.addr = req.addr;
        vif.load_req_o.valid = req.trans_type == LSU_LOAD && req.valid;
        vif.store_req_o.addr = req.addr;
        vif.store_req_o.data = req.data;
        vif.store_req_o.valid = req.trans_type == LSU_STORE && req.valid;
      `uvm_end_do
    endtask : put_drivers

  endclass : lsu_driver
```

## UVM Monitor Agent

The monitor agent checks the output of the Load Store Unit for correctness. In this example, we will check that the data and address of the output load and store transactions match the input data and address.

```systemverilog
  class lsu_monitor extends uvm_monitor;

    `uvm_component_utils(lsu_monitor)

## UVM Test Bench and UVM Test Code

The Verilog code represents a load store unit (LSU) with capability to perform memory access and provide memory access control in Ariane processor. 

To test the LSU, a UVM based test bench with appropriate test cases can be created. The test bench will contain a driver to drive stimulus to the inputs of the LSU, a monitor to capture the outputs of the LSU, a scoreboard to compare the captured output with the expected results and a test to execute the test cases.

### UVM Test Bench

```systemverilog
`include "uvm_macros.svh"

module tb_lsu;

    import uvm_pkg::*;
    import riscv_pkg::*;

    // Interface and DUT
    logic clk;
    logic rst_n;

    load_store_unit dut (
        .clk_i(clk),
        .rst_ni(rst_n)
    );

    // Clock generation
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Test configuration
    parameter int TEST_ITERATION = 2;
    parameter int TEST_DELAY_CYCLES = 2;

    // UVM Components
    initial begin
        // Initialize UVM Core
        uvm_config_db#(virtual riscv_cfg)::set(null, "uvm_test_top.env.riscv_cfg", riscv_cfg::type_id::get());
        riscv_cfg cfg = riscv_cfg::type_id::create("cfg");
        cfg.VLEN = 64; // Data width
        `uvm_info("LSU_TST","LSU test started",UVM_LOW)

        // Create and start the test
        lsu_test test = lsu_test::type_id::create("test");
        test.cfg = cfg;
        test.run_time = TEST_ITERATION;
        test.start(get_full_name());

        // Wait to finish all tests
        #TEST_ITERATION * TEST_DELAY_CYCLES;
        `uvm_info("LSU_TST","LSU test finished",UVM_LOW)
        $finish;
    end

endmodule
```

The test bench includes the interface and the DUT, which is the load store unit. The clock is generated in the test bench. The UVM components are initialized and the test is initialized and started. The test bench waits for the test to run and then the simulation is finished.

### UVM Test

```systemverilog
class lsu_test extends uvm_test;
    `uvm_component_utils(lsu_test)

    // Configuration parameters
    riscv_cfg cfg;
    int unsigned run_time;

    // Test components
    lsu_env env;
    lsu_agent agent;
    lsu_scoreboard sb;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create Environment
        env = lsu_env::type_id::create("env", this);

        // Create Agent
        agent = lsu_agent::type_id::create("agent", this);
        agent.cfg = cfg;

        // Create Scoreboard
        sb = lsu_scoreboard::type_id::create("sb", this);

        // Connections
        env.ls_unit_i.connect(agent.ls_unit_i);
        env.ls_unit_o.connect(agent.ls_unit_o);

        agent.agent_analysis_export.connect(sb.agent_analysis_export);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        // Execute test sequence
        lsu_seq seq;
        seq.cfg = cfg;
        forever begin
            if (!seq.randomize())
                `uvm_fatal("LSU_TST","Failed to randomize sequence fields")

            seq.print();
            agent.ls_seq_item_port.write_seq_item(seq);
            assert(sb.sb_seq_item_port.get(1, my_sequence) == UVM_IS_OK);
            assert(sb.analysis_export.get(lsu_item, 1) == UVM_IS_OK);

            // Check and terminate at end of run_time
            if (phase.get_sim_time() >= run_time) begin
                lsu_item.end_of_test();
                break;
            end

            // Delay sequence
            #2;
        end
    endtask

endclass
```

The test class is created as a child of uvm_test, which is the base class for all UVM tests. In the `build_phase`, the LSU environment, agent and scoreboard are created. The environment and the agent are then connected to each other. In the `run_phase`, the `seq` object is created which is the test sequence that will be executed by the agent. The sequence is randomized and sent to the agent using the `write_seq_item()` method. The scoreboard and analysis exports are used to check the output and end the test. 

### LSU Environment

The lsu_env component is used to connect the load store unit to the test bench. 

```systemverilog
class lsu_env extends uvm_env;
    `uvm_component_utils(lsu_env)

    //Interface
    load_store_unit_if#(cfg.VLEN) ls_unit_i;
    load_store_unit_if#(cfg.VLEN) ls_unit_o;

    // Connections
    initial begin
        ls_unit_i.connect(ls_unit_o);
    end

endclass
```

The `ls_unit_i` is the input interface and the `ls_unit_o` is the output interface that are connected to the load store unit.

### LSU Agent

The lsu_agent component is used to generate the test cases and send the input values to the load store unit.

```systemverilog
class lsu_agent extends uvm_agent;
    `uvm_component_utils(lsu_agent)

    // Configuration
    riscv_cfg cfg;

    //Port to send sequence items
    uvm_blocking_put_port #(lsu_seq_item) ls_seq_item_port;

    // Load and store sequences
    ls_load_seq ls_load_seq;
    ls_store_seq ls_store_seq;

    //Variables to hold current sequence phase in iteration
    int unsigned start_address;
    int unsigned data;
    load_store_unit_t lsu_req;
    bit[] be;

    //Connections
    load_store_unit_if#(cfg.VLEN) ls_unit_i;
    load_store_unit_if#(cfg.VLEN) ls_unit_o;

    // Phase Transitional Sequences
    function void pre_randomize();
        super.pre_randomize();

        // Set data and start address
        start_address = randomize_with_bounds(start_address, cfg.ADDR_LOW_BOUND, cfg.ADDR_HIGH_BOUND);
        data = randomize_with_bounds(data,cfg.D_LOW_BOUND,cfg.D_HIGH_BOUND);

        // Set lsu_req and be
        lsu_req.operator = ls_load_seq.op;
        lsu_req.fu = LOAD;
        lsu_req.trans_id = ls_load_seq.trans_id;
        lsu_req.vaddr = start_address;
        lsu_req.be = be;

        be = `riscv_create_be(lsu_req.vaddr, ls_load_seq.op);

        lsu_req.operand_b = cfg.VLEN'(data);
    endfunction

    function void pre_randomize_store();
        super.pre_randomize();

        // Set data and start address
        start_address = randomize_with_bounds(start_address, cfg.ADDR_LOW_BOUND, cfg.ADDR_HIGH_BOUND);
        data = randomize_with_bounds(data, cfg.D_LOW_BOUND, cfg.D_HIGH_BOUND);

        // Set lsu_req and be
        lsu_req.operator = ls_store_seq.op;
        lsu_req.fu = STORE;
        lsu_req.trans_id = ls_store_seq.trans_id;
        lsu_req.vaddr = start_address;
        lsu_req.be = be;

        be = `riscv_create_be(lsu_req.vaddr, ls_store_seq.op);

        lsu_req.operand_b = cfg.VLEN'(data);
    endfunction

    // Sequence Generator
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        lsu_seq_item ls_item;

        // Load sequence generator
        ls_load_seq = new();
        ls_load_seq.nbytes = 4;
        ls_load_seq.op = 0;

        // Store sequence generator
        ls_store_seq = new();
        ls_store_seq.nbytes = 4;
        ls_store_seq.op = 0;

        int unsigned i;

        // Load sequence
        for (i = 0; i < cfg.SEQ_LENGTH; i++) begin:ls_load_seq
            ls_load_seq.op++;
            if (ls_load_seq.op > $bits(riscv::ls_op_t)-1) ls_load_seq.op = 0;

            ls_load_seq.start_address = randomize_with_bounds(ls_load_seq.start_address, cfg.ADDR_LOW_BOUND, cfg.ADDR_HIGH_BOUND);
            ls_load_seq.trans_id = i + 1;
            ls_load_seq.randomize();

            // Set lsu_req and be
            lsu_req.operator = ls_load_seq.op;
            lsu_req.fu = LOAD;
            lsu_req.trans_id = ls_load_seq.trans_id;
            lsu_req.vaddr = ls_load_seq.start_address;
            lsu_req