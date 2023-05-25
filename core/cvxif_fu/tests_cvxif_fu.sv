# VerifAI TestGuru
# Explanation for: cvxif_fu.sv
# UVM Test Bench and UVM Test Code for CVXIF_FU Module

The `cvxif_fu` module is a logic module that acts as a functional interface for CoreV-X-Interface. In this section, we provide a UVM test bench and UVM test code for the module.

## UVM Test Bench

```systemverilog
`timescale 1 ns/1 ns

module cvxif_fu_tb;

    // Libraries
    import uvm_pkg::*;
    import ariane_pkg::*;
    import cvxif_pkg::*;
    `include "cvxif_defines.svh"

    // Signals
    logic                                clk;
    logic                                rst_n;
    fu_data_t                            fu_data;
    logic                                x_valid;
    logic                                x_ready;
    logic [31:0]                         x_off_instr;
    logic [TRANS_ID_BITS-1:0]            x_trans_id;
    exception_t                          x_exception;
    riscv::xlen_t                        x_result;
    logic                                x_we;
    cvxif_req_t                          cvxif_req;
    cvxif_resp_t                         cvxif_resp;

    // DUT
    cvxif_fu cvxif_fu(
        .clk_i(clk),
        .rst_ni(rst_n),
        .fu_data_i(fu_data),
        .x_valid_i(x_valid),
        .x_ready_o(x_ready),
        .x_off_instr_i(x_off_instr),
        .x_trans_id_o(x_trans_id),
        .x_exception_o(x_exception),
        .x_result_o(x_result),
        .x_valid_o(),
        .x_we_o(x_we),
        .cvxif_req_o(cvxif_req),
        .cvxif_resp_i(cvxif_resp)
    );

    // Driver
    class cvxif_fu_drv extends uvm_driver # (packet_phy) ;
        `uvm_component_utils(cvxif_fu_drv)
        `uvm_do_on(cvxif_req)

        // Methods
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

        virtual task run_phase(uvm_phase phase);
            packet_phy pkt;
            forever begin
                seq_item_port.get_next_item(pkt);
                send_req(pkt);
                seq_item_port.item_done();
            end
        endtask : run_phase

        function void report_phase(uvm_phase phase);
            `uvm_info(get_name(), "finished", UVM_MEDIUM)
        endfunction : report_phase

        virtual function void send_req(packet_phy pkt);
            cvxif_req.x_issue_valid = 1'b1;
            cvxif_req.x_issue_req.instr = pkt.instr;
            cvxif_req.x_issue_req.id = pkt.id;
            cvxif_req.x_issue_req.rs[0] = pkt.rs[0];
            cvxif_req.x_issue_req.rs[1] = pkt.rs[1];
            cvxif_req.x_issue_req.rs_valid = 2'b11;
            cvxif_req.x_commit_valid = 1'b1;
            cvxif_req.x_commit.id = pkt.id;
            cvxif_req.x_commit.x_commit_kill = 1'b0;
            seq_item_port.item_done();
        endfunction : send_req
    endclass : cvxif_fu_drv

    // Monitor
    class cvxif_fu_mon extends uvm_monitor # (packet_phy) ;
        `uvm_component_utils(cvxif_fu_mon)
        uvm_analysis_port #(packet_phy) ap;

        // Methods
        function new(string name, uvm_component parent);
            super.new(name, parent);
            ap = new("ap", this);
        endfunction : new

        virtual task run_phase(uvm_phase phase);
            packet_phy pkt;
            forever begin
                if (cvxif_resp.x_result_valid == 1'b1) begin
                    pkt = new();
                    pkt.instr = cvxif_req.x_issue_req.instr;
                    pkt.id = cvxif_req.x_issue_req.id;
                    pkt.rs = {cvxif_req.x_issue_req.rs[0], cvxif_req.x_issue_req.rs[1]};
                    ap.write(pkt);
                end
                else begin
                    @(posedge cvxif_resp.x_result_valid);
                end
            end
        endtask : run_phase

        function void report_phase(uvm_phase phase);
            `uvm_info(get_name(), "finished", UVM_MEDIUM)
        endfunction : report_phase
    endclass : cvxif_fu_mon

    // Sequencer
    class cvxif_fu_seq extends uvm_sequence #(packet_phy) ;
        `uvm_component_utils(cvxif_fu_seq)

        // Methods
        function new(string name = "cvxif_fu_seq");
            super.new(name);
        endfunction : new

        virtual task body();
            packet_phy pkt;
            pkt = new();
            pkt.instr = 0;
            pkt.id = 0;
            pkt.rs = {0, 0};
            start_item(pkt);
            finish_item(pkt);
        endtask : body
    endclass : cvxif_fu_seq

    // Agent
    class cvxif_fu_agent extends uvm_agent ;
        `uvm_component_utils(cvxif_fu_agent)
        cvxif_fu_mon mon;
        cvxif_fu_drv drv;
        uvm_sequencer #(packet_phy) seqr;

        // Methods
        function new(string name = "cvxif_fu_agent", uvm_component parent = null);
            super.new(name, parent);
            mon = cvxif_fu_mon.type_id.create("cvxif_fu_mon", this);
            drv = cvxif_fu_drv.type_id.create("cvxif_fu_drv", this);
            seqr = uvm_sequencer # (packet_phy) ::type_id::create("seqr", this);
        endfunction : new

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            seqr.seq_item_port.connect(target_port);
        endfunction : build_phase

        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            mon.ap.connect(analyzer_port);
        endfunction : connect_phase
    endclass : cvxif_fu_agent

    // Top Level
    cvxif_fu_agent cvxif_fu_agent0;

    // Environment
    class cvxif_fu_env extends uvm_env ;
        `uvm_component_utils(cvxif_fu_env)
        cvxif_fu_seq seq;

        // Methods
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new

        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            seq = cvxif_fu_seq::type_id::create("seq");
        endfunction : build_phase

        virtual function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cvxif_fu_agent0.target_port.connect(seq.seq_item_export);
        endfunction : connect_phase
    endclass : cvxif_fu_env

    // Test
    class cvxif_fu_test extends uvm_test ;
        `uvm_component_utils(cvxif_fu_test)
        cvxif_fu_env env;

        // Methods
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction : new
        
        virtual function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = cvxif_fu_env::type_id::create("cvxif_fu_env", this);
        endfunction : build_phase
                
        virtual task run_phase(uvm_phase phase);
            super.run_phase(phase);
            env.seq.start(NULL);
        endtask : run_phase

    endclass : cvxif_fu_test

endmodule : cvxif_fu_tb
```

## UVM Test Code

```systemverilog
class packet_phy extends uvm_sequence_item;
    rand riscv::xlen_t instr;
    rand integer id;
    rand riscv::xlen_t rs[2];

    `uvm_object_utils(packet_phy)

    function new(string name);
        super.new(name);
    endfunction

    constraint c_instr_range {
        instr inside {[0:riscv::MAX_INSTR_VALUE]};
    }

    constraint c_rs_range {
        foreach(rs[i]) {
            rs[i] inside {[0:riscv::MAX_INT_VALUE]};
        }
    }

endclass : packet_phy

module test_top();

    cvxif_fu_tb cvxif_fu_tb0();

    initial begin
        uvm_config_db #(virtual cvxif_pkg::cvxif_config) ::set(null, "*", "vif_config", cvxif_pkg::cvxif_config::get_config());
        uvm_config_db #(virtual cvxif_pkg::cvxif_config) ::set(null, "*", "cfg", cvxif_pkg::cvxif_config::get_config());
        run_test();
    end

    function void run_test();
        uvm_config_db #(virtual cvxif_pkg::cvxif_config) ::set(null, "*", "vif_config", cvxif_pkg::cvxif_config::get_config());

        cvxif_fu_test test = new();
        test.setName("test");
        if (uvm_config_db #(virtual cvxif_pkg::cvxif_config) ::exists(null, "*", "cfg")) begin
            uvm_config_db #(virtual cvxif_pkg::cvxif_config) ::set(null, "*", "cvxif_config", uvm_config_db #(virtual cvxif_pkg::cvxif_config)::get(null, "*", "cfg"));
        end

        run_test(test);

    end

endmodule
```

In this UVM test code, we create a `packet_phy` sequence item class that contains the field values to be written to the `cvxif_fu` module. We create the UVM components in the `cvxif_fu_tb` module and instantiate the `cvxif_fu` module as DUT. We also create the UVM driver, monitor, sequencer, agent, environment, and test classes. Finally, we set the virtual configuration for the test and run it.