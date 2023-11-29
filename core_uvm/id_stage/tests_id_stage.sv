// VerifAI TestGuru
// tests for: id_stage.sv
module id_stage(input logic clk_i, input logic rst_ni, input logic flush_i,
                output logic fetch_entry_ready_o);
    // ---------------------
    // Signal Declarations
    // ---------------------
    logic [1:0] decoded_instruction;
    logic is_control_flow_instr;

    // ----------------------
    // Signal Initialization
    // ----------------------
    assign decoded_instruction = 2'b01;
    assign is_control_flow_instr = 1'b1;

    // -----------------
    // Register (Issue)
    // -----------------
    logic [1:0] issue_q;
    logic [1:0] issue_n;

    // -------------------------------------
    // Combinational Logic (Issue)
    // -------------------------------------
    always_comb begin
        // assign output to input
        fetch_entry_ready_o = 1'b1;
        issue_n = '{1'b1, decoded_instruction, is_control_flow_instr};
    end

    // ------------------------------------------
    // Registers (ID <-> Issue)
    // ------------------------------------------
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if(~rst_ni) begin
            issue_q <= '0;
        end else begin
            issue_q <= issue_n;
        end
    end
endmodule

// Import necessary libraries
`include "uvm_macros.svh"
class id_stage_test extends uvm_test;

  // Define the DUT
  id_stage dut;

  // Define a sequence to generate test instructions
  class id_sequence extends uvm_sequence;
    // Define the sequence body
    task body();
      // Generate and send test instructions to the DUT
      // ...
    endtask
  endclass

  // Define the test case by extending uvm_test_case
  class id_test_case extends uvm_test_case;
    // Define the test sequence
    id_sequence seq;

    // Define the constructor
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    // Define the setup phase
    virtual function void build_phase(uvm_phase phase);
      // Instantiate the sequence
      seq = id_sequence::type_id::create("seq");
    endfunction

    // Define the run phase
    virtual task run_phase(uvm_phase phase);
      // Start the sequence
      seq.start(null);
      // Wait for the sequence to finish
      seq.wait_for_sequences();
    endtask
  endclass

  // Define the factory registration
  `uvm_component_utils(id_test_case)

  // Define the constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Define the run phase
  virtual task run_phase(uvm_phase phase);
    // Create the test case
    id_test_case test_case = id_test_case::type_id::create("test_case", this);
    // Run the test case
    uvm_report_info("RUNNING", $sformatf("Running test case %s", test_case.get_full_name()), UVM_LOW);
    test_case.start(null);
    test_case.wait_for_phase(UVM_TEST_DONE);
  endtask

endclass

// Define the testbench
class id_stage_testbench extends uvm_env;
  // Define the test
  id_stage_test test;

  // Define the constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Define the build phase
  virtual function void build_phase(uvm_phase phase);
    // Create the test
    test = id_stage_test::type_id::create("test", this);
  endfunction

  // Define the run phase
  virtual function void run_phase(uvm_phase phase);
    // Run the test
    test.run_phase(phase);
  endfunction
endclass

// Create the top module
module top;
  // Instantiate the testbench
  id_stage_testbench testbench;

  // Define the clock
  logic clk;
  // Define the reset
  logic rst_n;

  // Define the initial values for clk and rst_n
  initial begin
    clk = 0;
    rst_n = 0;
  end

  // Toggle the clock
  always #5 clk = ~clk;

  // Drive the reset
  initial #10 rst_n = 1;

  // Instantiate the DUT
  id_stage dut (
    .clk_i(clk),
    .rst_ni(rst_n),
    .flush_i(1'b0),
    .fetch_entry_ready_o()
    // Connect the remaining DUT ports
    // ...
  );

  // Instantiate the testbench
  initial begin
    testbench = id_stage_testbench::type_id::create("testbench");
    testbench.build_phase(uvm_run_phase);
    testbench.run_phase(uvm_run_phase);
  end
endmodule

// Run the simulation
initial begin
  $dumpfile("wave.vcd");
  $dumpvars(0, top);
  $timeformat(-9, 2, " ns");
  $display("Starting simulation...");
  $run;
  $display("Simulation done.");
  $finish;
end
