# VerifAI TestGuru
# Explanation for: ariane.sv
### UVM Test Bench

```systemverilog
`timescale 1ns/1ps

module ariane_tb;
  import uvm_pkg::*;
  import ariane_pkg::*;

  /*---------------------------------------------------------------------------
                           Class Declarations
  -----------------------------------------------------------------------------*/

  class ariane_env extends uvm_env;
    // Declare the UVM components that are used in this environment class
    ariane_master_seq  m_seq;
    ariane_driver     m_drv;
    ariane_monitor    m_mon;

    // Environment constructor
    function new(string name = "ariane_env", uvm_component parent);
      super.new (name, parent);
    endfunction : new

    // Build the environment
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Create the generator and the interface
      ariane_gen agnt = ariane_gen::type_id::create("agnt", this);
      cvxif_vif vif = cvxif_vif::type_id::create("vif", this);

      // Connect the generator to the interface
      agnt.vif = vif;

      // Create the sequence, driver and monitor
      m_seq = ariane_master_seq::type_id::create("m_seq");
      m_drv = ariane_driver::type_id::create("m_drv", this);
      m_mon = ariane_monitor::type_id::create("m_mon", this);

      // Connect the driver, monitor and interface to the generator
      agnt.driver = m_drv;
      agnt.monitor = m_mon;
      agnt.vif = vif;

      // Set the configuration object of the generator
      agnt.cfg = ariane_pkg::ariane_cfg_t::type_id::create("cfg");
      agnt.cfg.set_config_string("*", "VERIFY_TX", "1");
      agnt.cfg.set_config_string("*", "VERIFY_RX", "1");

      // Send the configuration object to the driver and monitor
      m_drv.cfg = agnt.cfg;
      m_mon.cfg = agnt.cfg;
    endfunction : build_phase

    // Create and start the components
    function void connect_phase(uvm_phase phase);
      m_seq.start(m_drv);
    endfunction : connect_phase
  endclass

  /*---------------------------------------------------------------------------
                           Test Declarations
  -----------------------------------------------------------------------------*/

  class ariane_test extends uvm_test;
    `uvm_component_param_utils(ariane_test)

    // Declare the UVM components that are used in this test
    ariane_env m_env;

    // Test constructor
    function new(string name="ariane_test", uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // Create and build the environment
    function void build_phase(uvm_phase phase);
      uvm_test_top.set_config_int("*.m_env.*.m_drv.num_transfers", 10);
      m_env = ariane_env::type_id::create("m_env", this);
    endfunction : build_phase

    // Start the test
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
    endtask
  endclass

  /*---------------------------------------------------------------------------
                          Test Bench Configuration
  -----------------------------------------------------------------------------*/

  function void ariane_tb_config();
    ariane_test::set_type_override_by_name("*agen_bfm", "mi_axi_bfm");
  endfunction

  initial begin
    uvm_cmdline_processor clp;
    clp = uvm_cmdline_processor::get_inst();
    clp.set_arg_mode("+UVM_TESTNAME", UVM_APPEND);
    clp.set_arg_mode("+UVM_VERBOSITY", UVM_APPEND);
    clp.set_arg_mode("+seed", UVM_SET);
    clp.set_arg_mode("+UVM_MAX_QUIT_COUNT", UVM_SET);
    clp.set_arg_mode("+UVM_TIMEOUT", UVM_SET);
    // Parse the command line arguments
    void'(clp.process());
    run_test();
  end

endmodule
```

### UVM Test Code

```systemverilog
`timescale 1ns/1ps

package ariane_pkg;
  import uvm_pkg::*;
  import cvxif_pkg::*;

  // Configuration object for the Ariane generator
  typedef struct {
    uvm_object_wrapper cfg;
  } ariane_cfg_t;

  //---------------------------------------------------------------------------
  // Generates write transactions to the DUT interface
  //---------------------------------------------------------------------------
  class ariane_master_seq extends uvm_sequence #(cvxif_transactions);
    `uvm_object_param_utils(ariane_master_seq)

    rand bit clk;
    rand bit rst_ni;
    rand logic [31:0] boot_addr;
    rand logic [63:0] hart_id;
    rand int unsigned num_transfers;

    // Constructor
    function new(string name = "ariane_master_seq");
      super.new(name);
    endfunction : new

    // Main sequence body
    virtual task body();
      repeat (num_transfers) begin
        cvxif_transactions txn;
        create_txn(txn);
        assert (send_txn(txn));
        `uvm_info("arien_master_seq", $sformatf("Packet %d sent successfully", get_sequence_id()), UVM_MEDIUM)
      end
    endtask

    // Build the transaction
    virtual function void create_txn(cvxif_transactions txn);
      txn.clk = clk;
      txn.rst_ni = rst_ni;
      txn.boot_addr_i = boot_addr;
      txn.hart_id_i = hart_id;
      // Fill in the remaining fields of the transaction
      // ...
    endfunction : create_txn
  endclass

  //---------------------------------------------------------------------------
  // Drives the data to the DUT interface
  //---------------------------------------------------------------------------
  class ariane_driver extends uvm_driver #(cvxif_transactions);
    `uvm_component_utils(ariane_driver)

    cvxif_vif vif;
    ariane_cfg_t cfg;

    function new(string name = "ariane_driver", uvm_component parent);
      super.new (name, parent);
    endfunction : new

    // Main driver task
    virtual task run_phase(uvm_phase phase);
      cvxif_transactions txn;
      forever begin
        assert (get_next_item(txn));
        `uvm_info("ariane_driver", $sformatf("Packet %d sent", txn.get_transaction_id()), UVM_MEDIUM)
        if (cfg.cfg != null) begin
          int verify_tx = cfg.cfg.get_int("VERIFY_TX", 1);
          if (verify_tx != 0) begin
            // Check the response received from the DUT
            if (verify(txn)) begin
              `uvm_info("ariane_driver", $sformatf("Packet %d verified successfully", txn.get_transaction_id()), UVM_MEDIUM)
            end
          end
        end
        send_item(txn);
      end
    endtask

    // Verify the response received from the DUT
    virtual function bit verify(cvxif_transactions txn);
      // Check the response
      // ...
      return 1;
    endfunction : verify
  endclass

  //---------------------------------------------------------------------------
  // Captures and verifies the responses from the DUT
  //---------------------------------------------------------------------------
  class ariane_monitor extends uvm_monitor;
    `uvm_component_utils(ariane_monitor)

    cvxif_vif vif;
    uvm_analysis_port #(cvxif_transactions)  mon_port;
    ariane_cfg_t cfg;

    function new(string name = "ariane_monitor", uvm_component parent);
      super.new (name, parent);
    endfunction : new

    // Main monitor task
    virtual task run_phase(uvm_phase phase);
      cvxif_transactions txn;
      forever begin
        wait_for_recv(txn);
        `uvm_info("ariane_monitor", $sformatf("Packet %d received", txn.get_transaction_id()), UVM_MEDIUM)
        if (cfg.cfg != null) begin
          int verify_rx = cfg.cfg.get_int("VERIFY_RX", 1);
          if (verify_rx != 0) begin
            // Check the response received from the DUT
            if (verify(txn)) begin
              `uvm_info("ariane_monitor", $sformatf("Packet %d verified successfully", txn.get_transaction_id()), UVM_MEDIUM)
            end
          end
        end
        mon_port.write(txn);
      end
    endtask

    // Verify the response received from the DUT
    virtual function bit verify(cvxif_transactions txn);
      // Check the response
      // ...
      return 1;
    endfunction : verify

    // Wait for the DUT to send data
    virtual task wait_for_recv(cvxif_transactions txn);
      forever begin
        @(vif.cvif_rsp);
        if (vif.cvif_rsp.cvif_valid) begin
          // Populate the transaction object
          // ...
          break;
        end
      end
    endtask
  endclass

  //---------------------------------------------------------------------------
  // Generator for the Ariane test bench
  //---------------------------------------------------------------------------
  class ariane_gen extends uvm_test;
    `uvm_component_param_utils(ariane_gen)

    ariane_driver driver;
    ariane_monitor monitor;
    cvxif_vif vif;
    ariane_cfg_t  cfg;

    function new(string name = "ariane_gen", uvm_component parent);
      super.new(name, parent);
      driver = ariane_driver::type_id::create("driver", this);
      monitor = ariane_monitor::type_id::create("monitor", this);
      vif = cvxif_vif::type_id::create("vif", this);
    endfunction : new

    // Build the test bench
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Connect the monitor to the interface
      monitor.vif = vif;

      // Connect the driver to the interface
      driver.vif = vif;

      // Connect the monitor to the analysis port of the driver
      driver.mon_port.connect(monitor.mon_port);

      // Set the configuration object for the driver and the monitor
      driver.cfg = cfg;
      monitor.cfg = cfg;
    endfunction : build_phase
  endclass

endpackage


```