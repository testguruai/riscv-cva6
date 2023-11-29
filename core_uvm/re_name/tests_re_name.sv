// VerifAI TestGuru
// tests for: re_name.sv
systemverilog
class re_name_test;

  typedef scoreboard_entry_t;

  // Declare the UVM components
  re_name uut;

  scoreboard_entry_t issue_instr_i;
  logic clk_i;
  logic rst_ni;
  logic flush_i;
  logic flush_unissied_instr_i;
  logic issue_instr_valid_i;
  logic issue_ack_i;

  initial begin
    // Create the test and environment
    uut = new();
    #10; // Allow for some time to pass
    uut.clk_i = 1; // Toggle clock
    #10;
    uut.rst_ni = 1; // Toggle reset
    #10;
    
    // Set initial values for inputs
    issue_instr_i = scoreboard_entry_t'(0);
    clk_i = 0;
    rst_ni = 0;
    flush_i = 0;
    flush_unissied_instr_i = 0;
    issue_instr_valid_i = 0;
    issue_ack_i = 0;

    // Apply stimulus
    #10;
    issue_instr_i = scoreboard_entry_t'(1);
    issue_instr_valid_i = 1;
    #10;
    issue_ack_i = 1;
    #10;
    flush_i = 1;

    #10;
    // Ensure the desired response
    if (uut.issue_ack_o != 1'b1) begin
      $display("Error: issue_ack_o != 1'b1");
    end

    if (uut.issue_instr_valid_o != 1'b1) begin
      $display("Error: issue_instr_valid_o != 1'b1");
    end

    #10;
    // Check the expected values of registers after re-naming
    if (uut.re_name_table_gpr_n != 32'h00000000) begin
      $display("Error: re_name_table_gpr_n != 32'h00000000");
    end

    if (uut.re_name_table_fpr_n != 32'h00000000) begin
      $display("Error: re_name_table_fpr_n != 32'h00000000");
    end
  end

  // Function to run the test
  function run();
    
    uvm_config_db#(scoreboard_entry_t)::set(null, "*", "scoreboard_entry_t", scoreboard_entry_t'(1));
    
    uvm_config_db#(logic)::set(null, "*", "clk_i", 1);
    uvm_config_db#(logic)::set(null, "*", "rst_ni", 0);
    uvm_config_db#(logic)::set(null, "*", "flush_i", 0);
    uvm_config_db#(logic)::set(null, "*", "flush_unissied_instr_i", 0);
    uvm_config_db#(logic)::set(null, "*", "issue_instr_valid_i", 0);
    uvm_config_db#(logic)::set(null, "*", "issue_ack_i", 0);
    
    run();
  endfunction

endclass

// Create an instance of the test and run it
module top;
  re_name_test test;
  initial begin
    test = new();
    test.run();
  end
endmodule
