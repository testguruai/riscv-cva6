
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: cvxif_fu.sv
// UVM Test Bench and Test Code for cvxif_fu.sv Verilog Code
// ==============================================================================
// UVM Agent classes
class cvxif_fu_agent extends uvm_agent;
    // The interfaces are instantiated as virtual to use the signals in the top-level module
    virtual cvxif_fu_if vif;
    cvxif_fu_driver cvxif_fu_d;
    cvxif_fu_monitor cvxif_fu_m;
   
    `uvm_component_utils(cvxif_fu_agent)

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cvxif_fu_d = cvxif_fu_driver::type_id::create("cvxif_fu_d", this);
        cvxif_fu_m = cvxif_fu_monitor::type_id::create("cvxif_fu_m", this);
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        cvxif_fu_d.vif = this.vif;
        cvxif_fu_m.vif = this.vif;
    endfunction: connect_phase
endclass: cvxif_fu_agent

// UVM Environment class
class cvxif_fu_env extends uvm_env;
    cvxif_fu_agent cvxif_fu_a;

    `uvm_component_utils(cvxif_fu_env)
    
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cvxif_fu_a = cvxif_fu_agent::type_id::create("cvxif_fu_a", this);
    endfunction: build_phase
endclass: cvxif_fu_env

// UVM Test class
class cvxif_fu_test extends uvm_test;
    cvxif_fu_env cvxif_fu_e;

    `uvm_component_utils(cvxif_fu_test)

    function new(string name="cvxif_fu_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cvxif_fu_e = cvxif_fu_env::type_id::create("cvxif_fu_e", this);
    endfunction: build_phase
endclass: cvxif_fu_test

// UVM Testbench (top-level UVM module)
module tb_top;
    // Instantiate the DUT
    cvxif_fu dut (.clk_i, .rst_ni, .fu_data_i, .x_valid_i, .x_ready_o, .x_off_instr_i, .x_trans_id_o, .x_exception_o, .x_result_o, .x_valid_o, .x_we_o, .cvxif_req_o, .cvxif_resp_i);
    
    // Instantiate the UVM test
    initial begin
        run_test("cvxif_fu_test");
    end
endmodule
