
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: store_unit.sv
// UVM Test Bench and Test Code for store_unit.sv Verilog Code
// ==============================================================================
module tb_top;
    reg clock;
    reg reset;
    reg flush;
    reg valid_i;
    wire [3:0] trans_id_o;
    
    // define all the wires/regs for interfaces
    // Instance of the store_unit
    store_unit store_unit_inst (
        .clk_i(clock),
        .rst_ni(reset),
        .flush_i(flush),
        .valid_i(valid_i),
        .trans_id_o(trans_id_o)
        // bind all other connection to some wires/ regs according to the interface standard.
    );

    // initialization of inputs
    initial begin
        clock = 1'b0; 
        flush = 1'b0;
        reset = 1'b0;
        valid_i = 1'b0;
    end
  
    // toggle the clock 
    always begin
        #5 clock = ~clock; 
    end
  
    // Test scenario 
    initial begin
        #50;
        reset = 1'b1; 
        #50;
        reset = 1'b0; 
        valid_i = 1'b1;
        #100;
        valid_i = 1'b0;
        // you can add more test scenarios here
        #100;
        $finish;
    end

endmodule
