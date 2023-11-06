# VerifAI TestGuru
# tests for: re_name.sv
```
module re_name_tb;

    logic clk, rst_ni;
    logic flush_i, flush_unissied_instr_i;
    logic issue_instr_valid_i;
    scoreboard_entry_t issue_instr_i;
    logic issue_ack_o;
    scoreboard_entry_t issue_instr_o;
    logic issue_instr_valid_o;
    logic issue_ack_i;

    re_name dut(
        .clk_i(clk),
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
        clk = 0;
        rst_ni = 1;
        #10;
        rst_ni = 0;

        issue_instr_i = '0;
        issue_instr_valid_i = 1;
        issue_ack_i = 0;

        #10;
        issue_instr_i.op = ADD;
        issue_instr_i.rs1 = '0;
        issue_instr_i.rs2 = '1;
        issue_instr_i.result = '2;
        issue_instr_i.rd = '3;

        #10;
        issue_instr_i.op = SUB;
        issue_instr_i.rs1 = '4;
        issue_instr_i.rs2 = '5;
        issue_instr_i.result = '6;
        issue_instr_i.rd = '7;

        #10;
        issue_instr_i.op = MUL;
        issue_instr_i.rs1 = '8;
        issue_instr_i.rs2 = '9;
        issue_instr_i.result = '10;
        issue_instr_i.rd = '11;

        #10;
        issue_instr_i.op = DIV;
        issue_instr_i.rs1 = '12;
        issue_instr_i.rs2 = '13;
        issue_instr_i.result = '14;
        issue_instr_i.rd = '15;

        #10;
        issue_instr_i.op = REM;
        issue_instr_i.rs1 = '16;
        issue_instr_i.rs2 = '17;
        issue_instr_i.result = '18;
        issue_instr_i.rd = '19;

        #10;
        issue_instr_i.op = AND;
        issue_instr_i.rs1 = '20;
        issue_instr_i.rs2 = '21;
        issue_instr_i.result = '22;
        issue_instr_i.rd = '23;

        #10;
        issue_instr_i.op = OR;
        issue_instr_i.rs1 = '24;
        issue_instr_i.rs2 = '25;
        issue_instr_i.result = '26;
        issue_instr_i.rd = '27;

        #10;
        issue_instr_i.op = XOR;
        issue_instr_i.rs1 = '28;
        issue_instr_i.rs2 = '29;
        issue_instr_i.result = '30;
        issue_instr_i.rd = '31;

        #10;
        issue_instr_i.op = SLT;
        issue_