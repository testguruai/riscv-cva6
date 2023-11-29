// VerifAI TestGuru
// tests for: re_name.sv

module re_name_tb;

    logic clk_i;
    logic rst_ni;
    logic flush_i;
    logic flush_unissied_instr_i;
    scoreboard_entry_t issue_instr_i;
    logic issue_instr_valid_i;
    logic issue_ack_o;
    scoreboard_entry_t issue_instr_o;
    logic issue_instr_valid_o;
    logic issue_ack_i;

    re_name_dut re_name_i(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .flush_i(flush_i),
        .flush_unissied_instr_i(flush_unissied_instr_i),
        .issue_instr_i(issue_instr_i),
        .issue_instr_valid_i(issue_instr_valid_i),
        .issue_ack_o(issue_ack_o),
        .issue_instr_o(issue_instr_o),
        .issue_instr_valid_o(issue_instr_valid_o),
        .issue_ack_i(issue_ack_i)
    );

    initial begin
        // initialize all signals
        clk_i = 1'b0;
        rst_ni = 1'b1;
        flush_i = 1'b0;
        flush_unissied_instr_i = 1'b0;
        issue_instr_i = '0;
        issue_instr_valid_i = 1'b0;
        issue_ack_o = 1'b0;
        issue_instr_o = '0;
        issue_instr_valid_o = 1'b0;
        issue_ack_i = 1'b0;

        // start simulation
        #100;
        rst_ni = 1'b0;

        // issue an instruction
        issue_instr_i.op = '0;
        issue_instr_i.rs1 = '0;
        issue_instr_i.rs2 = '0;
        issue_instr_i.rs3 = '0;
        issue_instr_i.rd = '0;
        issue_instr_valid_i = 1'b1;

        // wait for the instruction to be acknowledged
        #100;
        issue_instr_valid_i = 1'b0;

        // flush the renaming state
        flush_i = 1'b1;

        // wait for the flush to complete
        #100;
        flush_i = 1'b0;

        // issue another instruction
        issue_instr_i.op = '0;
        issue_instr_i.rs1 = '0;
        issue_instr_i.rs2 = '0;
        issue_instr_i.rs3 = '0;
        issue_instr_i.rd = '0;
        issue_instr_valid_i = 1'b1;

        // wait for the instruction to be acknowledged
        #100;
        issue_instr_valid_i = 1'b0;

        // stop simulation
        #100;
        $finish;
    end

endmodule
