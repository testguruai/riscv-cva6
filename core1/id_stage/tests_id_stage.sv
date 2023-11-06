# VerifAI TestGuru
# tests for: id_stage.sv
```
module id_stage_tb;

    logic clk;
    logic rst;

    logic flush;
    logic debug_req;

    // from IF
    ariane_pkg::fetch_entry_t fetch_entry;
    logic fetch_entry_valid;
    output logic fetch_entry_ready; // acknowledge the instruction (fetch entry)

    // to ID
    output ariane_pkg::scoreboard_entry_t issue_entry;       // a decoded instruction
    output logic issue_entry_valid; // issue entry is valid
    output logic is_ctrl_flow;      // the instruction we issue is a ctrl flow instructions
    input  logic issue_instr_ack;   // issue stage acknowledged sampling of instructions

    // from CSR file
    input  riscv::priv_lvl_t              priv_lvl;          // current privilege level
    input  riscv::xs_t                    fs;                // floating point extension status
    input  logic [2:0]                    frm;               // floating-point dynamic rounding mode
    input  logic [1:0]                    irq;
    input  ariane_pkg::irq_ctrl_t         irq_ctrl;
    input  logic                          debug_mode;        // we are in debug mode
    input  logic                          tvm;
    input  logic                          tw;
    input  logic                          tsr;

    id_stage id_stage_i(
        .clk_i,
        .rst_ni,

        .flush_i,
        .debug_req_i,
        .fetch_entry_i,
        .fetch_entry_valid_i,
        .fetch_entry_ready_o,
        .issue_entry_o,
        .issue_entry_valid_o,
        .is_ctrl_flow_o,
        .issue_instr_ack_i,
        .priv_lvl_i,
        .fs_i,
        .frm_i,
        .irq_i,
        .irq_ctrl_i,
        .debug_mode_i,
        .tvm_i,
        .tw_i,
        .tsr_i
    );

    initial begin
        clk = 1'b0;
        rst = 1'b1;

        #10;
        rst = 1'b0;

        #100;
        $finish;
    end

    always #5 clk = ~clk;

endmodule
```