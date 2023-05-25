# VerifAI TestGuru
# Explanation for: branch_unit.sv
### UVM Test Bench

```systemverilog
`include "uvm_macros.svh"

module branch_unit_tb;

  import uvm_pkg::*;
  `uvm_component_param_utils(branch_unit_tb)

  logic                      clk;
  branch_unit                branch_unit_dut;
  uvm_env                    env;
  
  initial begin
    uvm_config_db#(virtual branch_unit)::set(null, "*", "dut", branch_unit_dut);
    uvm_config_db#(virtual uvm_env)::set(null, "*", "env", env);
    run_test();
  end
  
  task run_test();
    forever begin
      #10ns clk = ~clk;
    end
  endtask
  
endmodule
```

### UVM Test Code

```systemverilog
`include "uvm_macros.svh"

class test_branch_unit extends uvm_test;
  `uvm_component_param_utils(test_branch_unit)

  virtual branch_unit      branch_unit_vif;
  virtual env_monitor      env_monitor_vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    branch_unit_vif = virtual.branch_unit::type_id::create("branch_unit_vif", this);
    env_monitor_vif = virtual.env_monitor::type_id::create("env_monitor_vif", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

endclass

class env_monitor extends uvm_monitor;
  `uvm_component_param_utils(env_monitor)

  virtual branch_unit branch_unit_dut;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    branch_unit_dut = virutal.branch_unit::type_id::lookup(this); 
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask
    
endclass
```