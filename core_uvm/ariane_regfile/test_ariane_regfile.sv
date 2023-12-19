
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: ariane_regfile.sv
// UVM Test Bench and Test Code for ariane_regfile.sv Verilog Code
// ==============================================================================
    interface ariane_regfile_interface;
        logic raddr;
        logic rdata;
        logic waddr;
        logic wdata;
        logic we;
        logic clk;

        task automatic clkgenerator(int period);
            forever #(period) clk = ~clk;
        endtask
    endinterface

    class Sequencer extends uvm_sequencer;
        `uvm_component_utils(Sequencer)
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass

    class Driver extends uvm_driver; 
        `uvm_component_utils(Driver)

        virtual ariane_regfile_interface drv_if;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            forever begin
                seq_item_port.get_next_item(req);
                @(drv_if.clk);
                // Drive signals here
                seq_item_port.item_done();
            end
        endtask
    endclass 

    class Monitor extends uvm_monitor;
        `uvm_component_utils(Monitor)
        virtual ariane_regfile_interface mon_if;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            forever @(posedge mon_if.clk) begin
                // Monitor signals here 
            end
        endtask
    endclass

    class Environment extends uvm_env;
        `uvm_component_utils(Environment)
        Driver ariane_regfile_driver;
        Sequencer ariane_regfile_sequencer;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            ariane_regfile_driver= Driver::type_id::create("ariane_regfile_driver", this);
            ariane_regfile_sequencer= Sequencer::type_id::create("ariane_regfile_sequencer", this);
        endfunction 

        function void connect_phase(uvm_phase phase);
            ariane_regfile_driver.seq_item_port.connect(ariane_regfile_sequencer.seq_item_export);
        endfunction
    endclass

    class Test extends uvm_test;
        `uvm_component_utils(Test)
        Environment ariane_regfile_env;

        function new(string name = "Test", uvm_component parent=null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            ariane_regfile_env = Environment::type_id::create("ariane_regfile_env", this);
        endfunction

        task run_phase(uvm_phase phase);
            // Start sequence here
        endtask
    endclass

    module tb;
        reg clk =0;
        reg rst = 0;
        ariane_regfile_interface ariane_regfile_if();
        // ariane_regfile_lol dut (clk, rst, ...); // Connect other ports - Need to Instantiate DUT here with correct parameters

        initial begin
            fork
                ariane_regfile_if.clkgenerator(5);
            join
        end

        initial begin 
            run_test("Test");
        end
    endmodule
