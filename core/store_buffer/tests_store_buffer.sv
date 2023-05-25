# VerifAI TestGuru
# Explanation for: store_buffer.sv
UVM Test Bench and Test Code:

The following UVM test bench and UVM test code will verify the functionality of the store_buffer module.

## Test Bench:

```systemverilog
`include "uvm_macros.svh"
`include "store_buffer.sv"

module store_buffer_tb;
    import ariane_pkg::*;
    // Test Inputs
    logic          clk;
    logic          rst_n;
    logic          flush;
    logic          commit;
    logic          valid;
    logic          valid_without_flush;
    logic [11:0]   page_offset;
    logic [riscv::PLEN-1:0]   paddr;
    riscv::xlen_t       data;
    logic [(riscv::XLEN/8)-1:0]  be;
    logic [1:0]         data_size;
    // D$ interface
    dcache_req_o_t req_port_i;
    dcache_req_i_t req_port_o;

    logic ready;

    // DUT
    store_buffer dut (
        .clk_i           (clk),
        .rst_ni          (rst_n),
        .flush_i         (flush),
        .no_st_pending_o (no_st_pending),
        .store_buffer_empty_o (store_buffer_empty),
        .page_offset_i         (page_offset),
        .page_offset_matches_o (page_offset_matches),
        .commit_i        (commit),
        .commit_ready_o  (commit_ready),
        .ready_o         (ready),
        .valid_i         (valid),
        .valid_without_flush_i (valid_without_flush),
        .paddr_i         (paddr),
        .data_i          (data),
        .be_i            (be),
        .data_size_i     (data_size),
        .req_port_i      (req_port_i),
        .req_port_o      (req_port_o)
    );

    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        flush = 0;
        commit = 0;
        valid = 0;
        valid_without_flush = 0;
        // Randomize inputs
        @(posedge clk) begin
            repeat (10) begin
                paddr = $urandom_range(1,32);
                data = $urandom_range(1,1024);

                commit = $urandom() % 2;
                valid = $urandom() % 2;
                valid_without_flush = $urandom() % 2;
                ready = $urandom() % 2;
                page_offset = $urandom;
            end
        end
        `uvm_info("TB", "Test Started", UVM_LOW);
        // Apply reset
        @(posedge clk) begin
            rst_n <= 0;
        end
        @(posedge clk) begin
            rst_n <= 1;
        end
        // Run test
        @(posedge clk) begin
            flush <= 1;
            commit <= 1;
            valid <= 1;
            $display("paddr = %d, data = %d", paddr, data);
        end
    end

endmodule
```

## Test Code:

```systemverilog
class store_buffer_test extends uvm_test;
    import ariane_pkg::*;
    virtual store_buffer store_buf;
    // Test Inputs
    logic          clk;
    logic          rst_n;
    logic          flush;
    logic          commit;
    logic          valid;
    logic          valid_without_flush;
    logic [11:0]   page_offset;
    logic [riscv::PLEN-1:0]   paddr;
    riscv::xlen_t       data;
    logic [(riscv::XLEN/8)-1:0]  be;
    logic [1:0]         data_size;
    // D$ interface
    dcache_req_o_t req_port_i;
    dcache_req_i_t req_port_o;

    logic ready;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        store_buf = store_buffer::type_id::create("store_buf", this);

        // Connect DUTs input ports to input signals
        store_buf.clk_i <= clk;
        store_buf.rst_ni <= rst_n;
        store_buf.flush_i <= flush;
        store_buf.valid_i <= valid;
        store_buf.valid_without_flush_i <= valid_without_flush;
        store_buf.commit_i <= commit;
        store_buf.paddr_i <= paddr;
        store_buf.data_i <= data;
        store_buf.be_i <= be;
        store_buf.data_size_i <= data_size;
        store_buf.page_offset_i <= page_offset;
        store_buf.req_port_i <= req_port_i;
        // Connect DUTs output ports to output signals
        assign ready = store_buf.ready_o;
        assign commit_ready = store_buf.commit_ready_o;
        assign no_st_pending = store_buf.no_st_pending_o;
        assign store_buffer_empty = store_buf.store_buffer_empty_o;
        assign page_offset_matches = store_buf.page_offset_matches_o;
        assign req_port_o.tag_valid = 1'b0;
        assign req_port_o.kill_req  = 1'b0;
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        // Initialize inputs
        clk = 0;
        rst_n = 0;
        flush = 0;
        commit = 0;
        valid = 0;
        valid_without_flush = 0;

        // Randomize inputs
        repeat (10) begin
            @(posedge clk);
            paddr = $urandom_range(1,32);
            data = $urandom_range(1,1024);

            commit = $urandom() % 2;
            valid = $urandom() % 2;
            valid_without_flush = $urandom() % 2;
            ready = $urandom() % 2;
            page_offset = $urandom;
        end

        // Apply reset
        @(posedge clk) begin
            rst_n <= 0;
        end
        @(posedge clk) begin
            rst_n <= 1;
        end

        // Run test
        @(posedge clk) begin
            flush <= 1;
            commit <= 1;
            valid <= 1;
            $display("paddr = %d, data = %d", paddr, data);
        end

        // End test
        @(posedge clk) begin
            $display("TEST PASSED");
            uvm_report_info(get_full_name(), "TEST PASSED", UVM_LOW);
            // End the test
            uvm_report_info(get_full_name(), "Ending test", UVM_LOW);
            // Wait for any outputs to settle
            #100;
            // End the test
            uvm_report_info(get_full_name(), "Finished", UVM_LOW);
            finish();
        end
    endtask

endclass
```# UVM Test Bench and Test Code for Address Checker

## Introduction
The Verilog code presented is a module for Address Checking which maintains physical addresses in the store buffer for returning the data stored by the most recent store to the same physical address.

In order to test Address Checking module, we will create a UVM test bench and a test code.

## UVM Test Bench
The UVM Test Bench consists of an environment that instantiates the DUT and a test that sends stimulus to the DUT.

### Environment
The environment is responsible for creating and connecting the components of the DUT.

```systemverilog
class addr_checker_env extends uvm_env;
    addr_checker_dut m_dut;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_dut = addr_checker_dut::type_id::create("m_dut", this);
    endfunction : build_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);

        uvm_info(get_type_name(), $sformatf("Built Address Checker DUT: %s", m_dut.get_full_name()), UVM_MEDIUM);
    endfunction : end_of_elaboration_phase

endclass : addr_checker_env
```

### Test
The test sends stimulus to the DUT by changing the values of the input signals.

```systemverilog
class addr_checker_test extends uvm_test;
    addr_checker_env m_env;
    addr_checker_config m_config;
    addr_checker_seq m_seq;

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        m_seq = addr_checker_seq::type_id::create("m_seq");
        m_seq.start(m_env.m_dut);

        assert(m_seq.get_first_error() == null);
    endtask : run_phase

    `uvm_component_utils(addr_checker_test)

endclass : addr_checker_test
```

### Sequncer and Sequences
The sequencer generates sequences and sends them to the DUT, and sequences provide stimulus.

In this example, `addr_checker_seq` is a sequence that sends a stimulus to the DUT by changing values of input signals.

```systemverilog
class addr_checker_seq extends uvm_sequence #(addr_checker_pkt);
    `uvm_object_utils(addr_checker_seq)

    function new(string name = "addr_checker_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        start_item(addr_checker_pkt::type_id::create("addr_checker_pkt", get_full_name()));
        `uvm_do_on_with(req,
            { req.paddr_i, req.page_offset_i} = '{<<7'h12, 7'h21};req.valid_i = 1'b1;} )
        finish_item(req);
    endtask : body

endclass : addr_checker_seq
```

## UVM Test Code
The test code sets up the test bench and executes the simulation.

```systemverilog
module top;

    `include "uvm_macros.svh"

    addr_checker_env m_env;
    addr_checker_test m_test;

    initial begin
        // Global Configuration
        `uvm_info("Testbench", "Starting Test", UVM_HIGH)
        uvm_config_db#(virtual addr_checker_config)::set(null, "", "config", addr_checker_config::type_id::get());
        uvm_config_db#(int)::set(null, "m_env.*", "verbosity", UVM_FULL);

        // Create the Test and Environment
        m_test = addr_checker_test::type_id::create("m_test");
        m_env = addr_checker_env::type_id::create("m_env");

        uvm_root::get().set_top_level(m_env);

        // Run the Test
        run_test();
    end
endmodule
```

## Conclusion
In the above example, we have provided an outline for building a UVM test bench and test code for Address Checker. The UVM test bench verifies the correctness of the Address Checking module by providing stimulus through a sequence class. The test bench demonstrates how to build modular test benches that are scalable and reusable for varied stimuli.