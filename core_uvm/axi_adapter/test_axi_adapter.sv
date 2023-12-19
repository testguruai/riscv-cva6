
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: axi_adapter.sv
// UVM Test Bench and Test Code for axi_adapter.sv Verilog Code
// ==============================================================================
// Class Definitions
class axi_adapter_driver extends uvm_driver;
  axi_adapter #(.DIVIDER(5)) i_axi_adapter; //Instantiate the DUT 
  virtual axi_vif vif;
  
  task run_phase;
    forever begin
      @(posedge vif.busy);
      if(vif.busy==1) begin
        i_axi_adapter.AXI_BUS(vif.in);
      end else begin
        i_axi_adapter.AXI_BUS(vif.out);
      end
    end
  endtask

  // Constructor of the class
  function new (string name, uvm_component parent = null);
    super.new(name,parent);
  endfunction
endclass

class axi_adapter_monitor extends uvm_monitor;
  axi_adapter #(.DIVIDER(5)) i_axi_adapter; //Instantiate DUT
  virtual axi_vif vif;
  
  task run_phase; 
    forever begin
        @(posedge vif.busy); 
        i_axi_adapter.AXI_BUS(vif.ob);
    end
  endtask 
  
  // Constructor of the class 
  function new(string name, uvm_component parent = null);
    super.new(name,parent);
  endfunction
endclass

class axi_adapter_env extends uvm_env;
  axi_adapter_monitor mon; //Instantiate Monitor Class 
  axi_adapter_driver drv; //Instantiate Driver Class 

  // Constructor of the class 
  function new (string name, uvm_component parent= null);
    super.new(name,parent); 
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase); //Call the build phase of parent class
    drv = axi_adapter_driver::type_id::create("drv", this);
    mon = axi_adapter_monitor::type_id::create("mon", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase); 
    if(!uvm_config_db#(virtual axi_vif)::get(this, "", "vif", drv.vif))
      `uvm_fatal("NOVIF", "No virtual interface specified for driver instance")
    if(!uvm_config_db#(virtual axi_vif)::get(this, "", "vif", mon.vif))
      `uvm_fatal("NOVIF", "No virtual interface specified for monitor instance")
  endfunction
endclass

class axi_adapter_test extends uvm_test;
  axi_adapter_env env;
  virtual axi_vif vif; 
  
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    phase.drop_objection(this);
  endtask

  function new (string name="axi_adapter_test", uvm_component parent= null);
    super.new(name, parent); 
  endfunction

  function build_phase(uvm_phase phase); 
    super.build_phase(phase);
    env = axi_adapter_env::type_id::create("env", this);
    vif = new;
    uvm_config_db#(virtual axi_vif)::set(this, "env.*", "vif", vif);
  endfunction
endclass

module top;
  virtual axi_vif vif;  
  initial run_test("axi_adapter_test");
endmodule
