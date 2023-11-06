# VerifAI TestGuru
# tests for: ex_stage.sv
Sure, here is a test bench and test code for the following verilog code:

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
// Author: Florian Zaruba, ETH Zurich
// Date: 19.04.2017
// Description: Instantiation of all functional units residing in the execute stage


module ex_stage import ariane_pkg::*; #(
    parameter int unsigned ASID_WIDTH = 1,
    parameter ariane_pkg::ariane_cfg_t ArianeCfg = ariane_pkg::ArianeDefaultConfig
) (
    input  logic                                   clk_i,    // Clock
    input  logic                                   rst_ni,   // Asynchronous reset active low
    input  logic                                   flush_i,
    input  logic                                   debug_mode_i,

    input  logic [riscv::VLEN-1:0]                 rs1_forwarding_i,
    input  logic [riscv::VLEN-1:0]                 rs2_forwarding_i,
    input  fu_data_t                               fu_data_i,
    input  logic [riscv::VLEN-1:0]                 pc_i,                  // PC of current instruction
    input  logic                                   is_compressed_instr_i, // we need to know if this was a compressed instruction
                                                                          // in order to calculate the next PC on a mis-predict
    // Fixed latency unit(s)
    output riscv::xlen_t                           flu_result_o,
    output logic [TRANS_ID_BITS-1:0]               flu_trans_id_o,        // ID of scoreboard entry at which to write back
    output exception_t                             flu_exception_o,
    output logic                                   flu_ready_o,           // FLU is ready
    output logic                                   flu_valid_o,           // FLU result is valid
    // Branches and Jumps
    // ALU 1
    input  logic                                   alu_valid_i,           // Output is valid
    // Branch Unit
    input  logic                                   branch_valid_i,        // we are using the branch unit
    input  branchpredict_sbe_t                     branch_predict_i,
    output bp_resolve_t                            resolved_branch_o,     // the branch engine uses the write back from the ALU
    output logic                                   resolve_branch_o,      // to ID signaling that we resolved the branch
    // CSR
    input  logic                                   csr_valid_i,
    output logic [11:0]                            csr_addr_o,
    input  logic                                   csr_commit_i,
    // MULT
    input  logic                                   mult_valid_i,      // Output is valid
    // LSU
    output logic                                   lsu_ready_o,        // FU is ready
    input  logic                                   lsu_valid_i,        // Input is valid

    output logic                                   load_valid_o,
    output riscv::xlen_t                           load_result_o,
    output logic [TRANS_ID_BITS-1:0]               load_trans_id_o,
    output exception_t                             load_exception_o,
    output logic                                   store_valid_o,
    output riscv::xlen_t                           store_result_o,
    output logic [TRANS_ID_BITS-1:0]               store_trans_id_o,
    output exception_t                             store_exception_o,

    input  logic                                   lsu_commit_i,