
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: branch_unit.sv
// UVM Test Bench and Test Code for branch_unit.sv Verilog Code
// ==============================================================================
`include "ariane_pkg.sv"
`include "riscv.sv"
`include "uvm_macros.svh"

class branch_unit_utest extends uvm_test;
    `uvm_component_utils(branch_unit_utest)

    branch_unit dut;
    uvm_clock_generator #(1ns) clk_gen;
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        clk_gen.reset();
        fork 
            run_test();
        join_none
    endtask
   
    task run_test();
        /* Write your test here, for example a simple test might be:
        clk_gen.wait_for_posedge(20);

        dut.rst_ni <= 1'b0;
        dut.debug_mode_i <= 1'b1;
        //continue assigning values for test...

        clk_gen.wait_for_posedge(1);
        dut.rst_ni <= 1'b1;

        $display("Resolved branch_o is: %p", dut.resolved_branch_o);	//Prints the current value
        
        */
    endtask
endclass

module top;
    branch_unit_utest u_test;
    initial begin
        uvm_config_db #(uvm_event)::set(null,"*","my_event",uvm_event_pool::get_global_pool().grab());
        run_test("branch_unit_utest");
    end
endmodule
