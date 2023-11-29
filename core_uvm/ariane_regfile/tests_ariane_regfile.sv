module test_ariane_regfile_lol;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  // Define a virtual interface for connecting the testbench to the DUT
  interface dut_if(input logic clk_i, input  logic rst_ni);
    // Clock and Reset
    modport tb_modport(input  logic clk_i,
                      input  logic rst_ni);
  endinterface

  // Define a testbench module
  class tb extends uvm_component;
    // Declare the virtual interface instance
    dut_if dut_vif;

    // Define the UVM components
    `uvm_component_utils(tb)

    // Constructor
    function new(string name = "tb", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);
      // Create and connect the virtual interface
      dut_vif = new("dut_vif");
      dut_vif.clk_i.connect(dut_vif.clk_i);
      dut_vif.rst_ni.connect(dut_vif.rst_ni);
    endfunction

    // Main Phase
    function void main_phase(uvm_phase phase);
      // Create and run the test
      run_test();
      #100;
      phase.finish();
    endfunction

    // Test Task
    function void run_test();
      // Include the test code here
    endfunction
  endclass

  initial begin
    // Create and start the UVM environment
    tb tb_env = new("tb_env");
    uvm_config_db#(virtual dut_if)::set(null, "*", "vif", tb_env.dut_vif);
    run_test("tb_env");
  end

endmodule
