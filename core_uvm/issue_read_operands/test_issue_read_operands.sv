
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: issue_read_operands.sv
// UVM Test Bench and Test Code for issue_read_operands.sv Verilog Code
// ==============================================================================
class issue_tb_pkg extends uvm_pkg;
 
  typedef class issue_env;
  
  // Environment
  class issue_env extends uvm_env;
    issue_read_operands m_iss_rd;
    uvm_tlm_analysis_port #(.T(issue_read_operands)) issue_analysis_port;
 
    function new (uvm_component parent=null, string name="iss_env");
      super.new(parent, name);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      m_iss_rd = issue_read_operands::type_id::create("m_iss_rd", this);
      issue_analysis_port = new("m_iss_rd", this);
    endfunction

    function void connect_phase (uvm_phase phase);
     uvm_config_db#(virtual dut_if)::get(this, "", "m_iss_rd", m_iss_rd.v_dut_if);
      connect_analysis_port.connect(m_iss_rd.iss_item);
    endfunction
 
    function void run_phase(uvm_phase phase);
      check();
    endfunction
 
    function void check();
      issue_read_operands tr;

      fork
        begin
          assert (my_alarm);
          $display("Test Passed");
          tr.stop();
        end
      join
    endfunction

    task run_phase (uvm_phase phase);
      issue_read_operands::type_id::get();
    endtask
    `uvm_analysis_imp_decl(_m_iss_rd)

    function void write_m_iss_rd (issue_read_operands t);
      issue_analysis_port.write(t);
    endfunction : write_m_iss_rd

  endclass : issue_env

  // Test
  class issue_read_test extends uvm_test;
    issue_env m_env;

    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
      m_env = issue_env::type_id::create("m_env", this);
    endfunction

    task run_phase (uvm_phase phase);
      phase.phase_done.set_drain_time(this,50ns);
    endtask

  endclass : issue_read_test
  
endclass : issue_tb_pkg

module issue_read_tb;
  
  logic clk;
  issue_read_operands t_hat;
   
  initial begin
    #5 t_hat.v_dut_if.start_a = issue_read_operands; 
    #10 t_hat.v_dut_if.start_b = issue_read_operands; 
     //provide all inputs
    #20 t_hat.print();
    #50 t_hat.v_dut_if.stop_a = 1'b1;
    #60 t_hat.v_dut_if.stop_b = 1'b1;
    #70;
  end
  
  // using always statement to generate clock
  always
  begin
    #5 clk = ~clk; 
  end 

  initial
  begin
    $dumpfile("issue_read_operands.vcd");
    $dumpvars(0,issue_read_tb);
    clk=0;
    uvm_pkg::run_test("issue_tb_pkg::issue_read_test"); //passing a reference to the test to the UVM test executor
  end
endmodule
