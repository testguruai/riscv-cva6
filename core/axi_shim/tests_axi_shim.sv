# VerifAI TestGuru
# Explanation for: axi_shim.sv
## UVM Test Bench for axi_shim module

The UVM test bench for the `axi_shim` module would contain the following:

- A UVM test to run the simulation
- An interface agent to drive and sample the signals of the AXI interface
- A sequence to generate AXI transaction requests
- A driver to convert the sequence items into AXI interface signals
- A monitor to sample the AXI interface signals and convert them into sequence items
- An analysis port to receive and process the sequence items generated by the monitor
- A scoreboard to compare the sequence items generated by the sequence with the ones generated by the monitor

## UVM Test Code

### AXI interface agent

```systemverilog
class axi_shim_agent extends uvm_agent;

  // Declare interface and components
  `uvm_component_param_utils(axi_shim_agent)
  
  axi_shim_if                 m_axi_if;
  uvm_analysis_port#(axi_req) ap;
  axi_shim_driver             drv;
  axi_shim_monitor            mon;
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
    drv = axi_shim_driver::type_id::create("drv", this);
    mon = axi_shim_monitor::type_id::create("mon", this);
  endfunction
  
  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Connect interface
    m_axi_if = axi_shim_if::type_id::create("m_axi_if", this);
    uvm_config_db#(virtual axi_shim_if)::set(this, "*", "m_axi_if", m_axi_if);
    // Connect components
    drv.seq_item_port.connect(mon.seq_item_export);
    drv.drive_interface_export(m_axi_if);
    mon.analysis_export.connect(ap);
  endfunction
  
  // Run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "Starting test", UVM_HIGH)
    // Start Sequences
    axi_seq axi_seq1;
    axi_seq1.set_mem_addr(0);
    axi_seq1.set_mem_data(32'hABCD1234);
    drv.seq_item_port.put(axi_seq1);
  endtask

endclass
```

### AXI transaction sequence

```systemverilog
class axi_seq extends uvm_sequence#(axi_req);  

// Randomization properties
  rand bit [31:0] mem_addr;
  rand bit [31:0] mem_data;
  
  // Constructor
  function new(string name = "axi_seq");
    super.new(name);
  endfunction

  // Body of sequence
  task body();
    axi_req req;
    
    // Build request
    req.addr = mem_addr;
    req.data = mem_data;
    req.op   = AXI_WRITE;
    
    // Send request via analysis port
    `uvm_info(get_type_name(), $sformatf("Sending request: addr = 0x%0h, data = 0x%0h", mem_addr, mem_data), UVM_HIGH)
    ap.write(req);
    
    // Wait for response
    axi_rsp rsp;
    `uvm_info(get_type_name(), "Waiting for response", UVM_HIGH)
    mon.seq_item_export.get_next_item(rsp);
    `uvm_info(get_type_name(), $sformatf("Received response: resp = %0h", rsp.resp), UVM_HIGH)
    
  endtask
  
endclass
```

### AXI driver

```systemverilog
class axi_shim_driver extends uvm_driver#(axi_req);

  // Declare interface and sequencer
  `uvm_component_param_utils(axi_shim_driver)
  
  virtual axi_shim_if axi_if;
  axi_shim_sequencer sequencer;
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axi_if = get_interface();
    sequencer = axi_shim_sequencer::type_id::create("sequencer", this);
  endfunction
  
  // Run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    axi_req req;	  
    `uvm_info(get_type_name(), "Starting driver", UVM_HIGH)
    forever begin
      sequencer.seq_item_port.get(req);
      case (req.op)
        AXI_WRITE:
          // Send write request
          axi_if.wr_addr_i  <= req.addr;
          axi_if.wr_data_i  <= req.data;
          axi_if.wr_req_i   <= 1;
          `uvm_info(get_type_name(), $sformatf("Sending write request: addr = 0x%0h, data = 0x%0h", req.addr, req.data), UVM_HIGH)
          wait(axi_if.wr_gnt_o);
          // Clear request
          axi_if.wr_req_i   <= 0;
          do_begin: begin
            // Wait for response
            wait(axi_if.wr_valid_o);
            // Check response
            if (axi_if.wr_exokay_o !== '1) begin
              `uvm_error(get_type_name(), "Exclusive write not okay")
            end
            // Send response via analysis port
            axi_rsp rsp;
            rsp.resp = axi_if.wr_exokay_o;
            `uvm_info(get_type_name(), $sformatf("Sending response: resp = %0h", rsp.resp), UVM_HIGH)
            seq_item_port.put(rsp);
          end
      endcase
    end
  endtask

endclass
```

### AXI monitor

```systemverilog
class axi_shim_monitor extends uvm_monitor;

  // Declare interface and components
  `uvm_component_param_utils(axi_shim_monitor)
  
  axi_shim_if              axi_if;
  uvm_analysis_port#(axi_rsp) seq_item_export;
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    seq_item_export = new("seq_item_export", this);
  endfunction
  
  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axi_if = get_interface();
  endfunction
  
  // Transactor process
  task transactor();
    axi_rsp rsp;
    while (1) begin
      // Wait for valid write response
      wait(axi_if.wr_valid_o);
      // Build response
      rsp.resp = axi_if.wr_exokay_o;
      // Send response via analysis port
      seq_item_export.write(rsp);
    end
  endtask

endclass
```# UVM Test Bench and UVM Test Code

## UVM Test Bench

The UVM test bench for the axi_adapter2 module would consist of the following components:

- A virtual interface (vif) to connect the DUT to the test bench
- A driver to apply stimulus to the DUT
- A monitor to capture and observe the output of the DUT
- A scoreboard to compare the output of the DUT with the expected output
- A test to run the simulation and report the results

```
module axi_adapter2_tb;

  import uvm_pkg::*;

  // Virtual Interface
  `include "uvm_macros.svh"
  `include "axi_adapter2.v"
  `include "tb_vif.sv"
  `include "test.sv"

  // DUT
  axi_adapter2 dut (
    // Port connections
  );

  // Virtual Interface
  tb_vif vif;

  // Test
  my_test test;

  // Driver
  my_driver driver;

  // Monitor
  my_monitor mon;

  // Scoreboard
  my_scoreboard sb;

  // Connect virtual interface to DUT
  initial begin
    vif = new("vif");
    dut.vif = vif;
  end

  // Start UVM
  initial begin
    uvm_component_utils_begin(axi_adapter2_tb)
      // Component registration
    uvm_component_utils_end

    // Top level test
    test = my_test::type_id::create("test");

    // Driver and monitor
    driver = my_driver::type_id::create("driver", test);
    mon = my_monitor::type_id::create("mon", test);

    // Scoreboard
    sb = my_scoreboard::type_id::create("sb", test);

    // Start the test
    test.start(env);
  end

endmodule
```

## UVM Test Code

The UVM test code for the axi_adapter2 module would consist of the following components:

- An environment to create and connect the components
- A test to run the simulation and report the results
- A sequence to generate stimulus for the DUT
- A agent to provide the interface between the test bench and the sequence

```
class axi_adapter2_env extends uvm_env;

  // Components
  my_agent agent;

  // Constructor
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build the environment
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the agent
    agent = my_agent::type_id::create("agent", this);

    // Connect the agent's sequencer and monitor to the bus
    agent.seqr.vif = dut.vif;
    agent.mon.vif = dut.vif;
  endfunction

endclass

class my_test extends uvm_test;

  // Environment
  axi_adapter2_env env;

  // Constructor
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build the test environment
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the environment
    env = axi_adapter2_env::type_id::create("env", this);

    // Set the default phase for the test
    phase.phase_schedule = "run";
  endfunction

  // Run the test
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "Running test...", UVM_MEDIUM)
  endtask

endclass

class my_sequence extends uvm_sequence;

  // Virtual sequence item
  virtual axi_pkg::axi_transaction axi_tx;

  // Constructor
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Generate the sequence
  task body();
    super.body();

    // Generate the AXI transaction
    axi_tx = new("axi_tx");
    // Set the attributes of the transaction item

    // Send the transaction
    // Transmitter.send_request(axi_tx);
    // Wait for the response
    // Transmitter.get_response(axi_tx);
  endtask

endclass

class my_agent extends uvm_agent;

  // Components
  my_sequencer seqr;
  my_driver driver;
  my_monitor mon;

  // Constructor
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build the agent
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the sequencer, driver and monitor
    seqr  = my_sequencer::type_id::create("seqr", this);
    driver = my_driver::type_id::create("driver", this);
    mon = my_monitor::type_id::create("mon", this);

    // Connect the components
    seqr.put_port(driver.seq_item_export);
    mon.get_port(driver.seq_item_export);
  endfunction

endclass

class my_sequencer extends uvm_sequencer#(axi_pkg::axi_transaction);

  // Constructor
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build the sequencer
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass

class my_driver extends uvm_driver#(axi_pkg::axi_transaction);

  // Constructor
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build the driver
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  // Drive the transaction to the DUT
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    // Wait for the sequencer to send a request
    seq_item_port.get_next_item(req);

    // Drive the request to the DUT
    // Monitor the response from the DUT
    // Return the response to the scoreboard
    trans_collected = 1;
    trans_ended = 1;
    seq_item_port.item_done();
  endtask

endclass

class my_monitor extends uvm_monitor;

  // Constructor
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build the monitor
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass

class my_scoreboard extends uvm_scoreboard;

  // Constructor
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build the scoreboard
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

endclass
```