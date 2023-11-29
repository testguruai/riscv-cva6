`include "uvm_macros.svh"

module tb;

  // Define a UVM testbench
  class my_testbench extends uvm_component;
    `uvm_component_utils(my_testbench)

    // Instantiate components
    dromajo_ram dut;

    // Define the test sequence
    class my_sequence extends uvm_sequence #(uvm_sequence_item);
      `uvm_object_utils(my_sequence)

      function new(string name = "my_sequence");
        super.new(name);
      endfunction

      task body();
        // Write test sequence code here

        // Example test case: Writing data to the RAM and reading it back
        dut.CSel_SI <= 1'b1;  // Enable chip select
        dut.WrEn_SI <= 1'b1;  // Enable write
        dut.BEn_SI <= 8'b11111111;  // Enable all bytes
        dut.WrData_DI <= 64'h0123456789ABCDEF;  // Write data
        dut.Addr_DI <= 10'd0;  // Write address

        // Wait for a few clock cycles
        #10;

        // Disable write
        dut.WrEn_SI <= 1'b0;

        // Read back the data
        dut.CSel_SI <= 1'b1;  // Enable chip select
        dut.Addr_DI <= 10'd0;  // Read address

        // Wait for a few clock cycles
        #10;

        // Check the read data
        assert(dut.RdData_DO == 64'h0123456789ABCDEF)
          else $error("Read data mismatch");

        // Finish the sequence
        finish_item();
      endtask

    endclass

    // Override the run phase to start the test sequence
    virtual function void run_phase(uvm_phase phase);
      my_sequence seq;

      // Start the test sequence
      seq = my_sequence::type_id::create("seq");
      seq.start(env.sqr);

      // Wait for the sequence to finish
      seq.wait_for_sequence_state(UVM_FINISHED);

      // Finish the test
      phase.raise_objection(this);
      phase.drop_objection(this);
    endfunction

  endclass : my_testbench

  // Override the register model to add uvm_reg adaptors
  class my_register_model extends uvm_reg_block;
    `uvm_object_utils(my_register_model)

    // Register fields and registers
    // Add here the register fields and registers from the dromajo_ram module

  endclass : my_register_model

  // Define the test
  class my_test extends uvm_test;
    `uvm_component_utils(my_test)

    // Instantiate testbench and register model
    my_testbench tb;
    my_register_model reg_model;

    function new(string name = "my_test");
      super.new(name);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      // Create the testbench and register model
      tb = my_testbench::type_id::create("tb", this);
      reg_model = my_register_model::type_id::create("reg_model", this);

      // Connect the components
      tb.dut.Rst_RBI.connect(reg_model.Rst);

      // Add the components to the env
      env.add(tb);
      env.add(reg_model);
    endfunction

    virtual task run_phase(uvm_phase phase);
      // Start the test
      phase.raise_objection(this);
      phase.drop_objection(this);
    endtask

  endclass : my_test

  // Create and run the test
  initial begin
    uvm_config_db#(uvm_object_wrapper)::set(null, "*", "vmm_test", my_test::type_id::get());
    run_test();
  end

endmodule : tb
