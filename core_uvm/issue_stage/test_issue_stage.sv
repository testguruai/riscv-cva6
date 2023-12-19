
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: issue_stage.sv
// UVM Test Bench and Test Code for issue_stage.sv Verilog Code
// ==============================================================================
interface dut_if(input logic clk);
  wire wbdata;
  assign wbdata = $random;
  //add all the dut interface signals here
endinterface 

class dut_driver extends uvm_driver;
  `uvm_component_utils(dut_driver)

  dut_if vif;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      `uvm_info(get_name(), "Driving signals", UVM_LOW)
      @(posedge vif.clk);
      vif.wbdata = $random;  // driving random values
    end
  endtask
endclass

class dut_monitor extends uvm_monitor;
  `uvm_component_utils(dut_monitor)

  dut_if vif;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      `uvm_info(get_name(), "Monitoring signals", UVM_LOW)
      @(posedge vif.clk);
      if(vif.wbdata !== 'bX) begin  
        `uvm_info(get_name(), "Monitor Detected data", UVM_HIGH)
      end
    end
  endtask
endclass

class dut_env extends uvm_env;
  `uvm_component_utils(dut_env)

  dut_if vif;
  dut_agent dut_a0;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    dut_a0 = new("dut_a0", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(dut_if)::get(this,"","vif",vif))
     `uvm_fatal(get_type_name(),"virtual interface must be set for: vif")
     dut_a0.vif = vif;
  endfunction
endclass

class dut_test extends uvm_test;
  `uvm_component_utils(dut_test)

  dut_env env;
  uvm_config_db#(virtual dut_if) vif;

  function new(string name = "dut_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = dut_env::type_id::create("env", this);
    if(!uvm_config_db#(virtual dut_if)::get(this, "","vif", vif))
      `uvm_fatal("NOVIF","failed to get virtual interface from config DB")
    uvm_config_db#(virtual dut_if)::set(this, "env", "vif", vif);
  endfunction
endclass
