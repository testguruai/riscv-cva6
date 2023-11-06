# VerifAI TestGuru
# tests for: decoder.sv
```
// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// File:   issue_read_operands.sv
// Author: Florian Zaruba <zarubaf@ethz.ch>
// Date:   8.4.2017
//
// Copyright (C) 2017 ETH Zurich, University of Bologna
// All rights reserved.
//
// Description: Issues instruction from the scoreboard and fetches the operands
//              This also includes all the forwarding logic
//

module decoder import ariane_pkg::*; (
    input  logic               debug_req_i,             // external debug request
    input  logic [riscv::VLEN-1:0] pc_i,                // PC from IF
    input  logic               is_compressed_i,          // is a compressed instruction
    input  logic [15:0]        compressed_instr_i,      // compressed form of instruction
    input  logic               is_illegal_i,            // illegal compressed instruction
    input  logic [31:0]        instruction_i,           // instruction from IF
    input  branchpredict_sbe_t  branch_predict_i,
    input  logic [1:0]         irq_i,                   // external interrupt
    input  irq_ctrl_t          irq_ctrl_i,              // interrupt control and status information from CSRs
    // From CSR
    input  riscv::priv_lvl_t   priv_lvl_i,              // current privilege level
    input  logic               debug_mode_i,            // we are in debug mode
    input  riscv::xs_t         fs_i,                    // floating point extension status
    input  logic [2:0]         frm_i,                    // floating-point rounding mode
    input  logic               tvm_i,                    // trap virtual memory
    input  logic               tw_i,                     // timeout wait
    input  logic               tsr_i,                    // trap sret
    output scoreboard_entry_t  instruction_o,           // scoreboard entry to scoreboard
    output logic               is_control_flow_instr_o  // this instruction will change the control flow
);
    logic illegal_instr;
    logic illegal_instr_bm;
    logic illegal_instr_non_bm;
    // this instruction is an environment call (ecall), it is handled like an exception
    logic ecall;
    // this instruction is a software break-point
    logic ebreak;
    // this instruction needs floating-point rounding-mode verification
    logic check_fprm;
    riscv::instruction_t instr;
    // --------------------
    // Immediate select
    // --------------------
    enum logic[3:0] {
        NOIMM, IIMM, SIMM, SBIMM, UIMM, JIMM, RS3
    } imm_select;

    riscv::xlen_t imm_i_type;
    riscv::xlen_t imm_s_type;
    riscv::xlen_t imm_sb_type;
    riscv::xlen_t imm_u_type;
    riscv::xlen_t imm_uj_type;
    riscv::xlen_t imm_bi_type;

    always_comb begin : decoder

        imm_select                  = NOIMM;
        is_control_flow_instr_o     = 1'b0;
        illegal_instr               = 1'b0;
        illegal_instr_bm        = 1'b0;
        illegal_instr_non_bm        = 1'b0;
        ecall                       = 1'b0;
        ebreak                      =