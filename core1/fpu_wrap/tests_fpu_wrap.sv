# VerifAI TestGuru
# tests for: fpu_wrap.sv
Please write a test bench and test code for the following verilog code  and return response in markdown format 
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
// Author: Stefan Mach, ETH Zurich
// Date: 12.04.2018
// Description: Wrapper for the floating-point unit


module fpu_wrap import ariane_pkg::*; (
  input  logic                     clk_i,
  input  logic                     rst_ni,
  input  logic                     flush_i,
  input  logic                     fpu_valid_i,
  output logic                     fpu_ready_o,
  input  fu_data_t                 fu_data_i,

  input  logic [1:0]               fpu_fmt_i,
  input  logic [2:0]               fpu_rm_i,
  input  logic [2:0]               fpu_frm_i,
  input  logic [6:0]               fpu_prec_i,
  output logic [TRANS_ID_BITS-1:0] fpu_trans_id_o,
  output logic [FLEN-1:0]          result_o,
  output logic                     fpu_valid_o,
  output exception_t               fpu_exception_o
);

  // this is a workaround
  // otherwise compilation might issue an error if FLEN=0
  enum logic {READY, STALL} state_q, state_d;
  if (FP_PRESENT) begin : fpu_gen
    logic [FLEN-1:0]     operand_a_d,  operand_a_q,  operand_a;
    logic [FLEN-1:0]     operand_b_d,  operand_b_q,  operand_b;
    logic [FLEN-1:0]     operand_c_d,  operand_c_q,  operand_c;
    logic [OPBITS-1:0]   fpu_op_d,     fpu_op_q,     fpu_op;
    logic                fpu_op_mod_d, fpu_op_mod_q, fpu_op_mod;
    logic [FMTBITS-1:0]  fpu_srcfmt_d, fpu_srcfmt_q, fpu_srcfmt;
    logic [FMTBITS-1:0]  fpu_dstfmt_d, fpu_dstfmt_q, fpu_dstfmt;
    logic [2:0]          fpu_rm_d,     fpu_rm_q,     fpu_rm;
    logic                fpu_vec_op_d, fpu_vec_op_q, fpu_vec_op;

    logic fpu_in_ready, fpu_in_valid;
    logic fpu_out_ready, fpu_out_valid;

    //-----------------------------
    // Translate inputs
    //-----------------------------

    always_comb begin : input_translation

      automatic logic vec_replication; // control honoring of replication flag
      automatic logic replicate_c;     // replicate operand C instead of B (for ADD/SUB)
      automatic logic check_ah;        // Decide for AH from RM field encoding

      // Default Values
      operand_a_d         = operand_a_i;
      operand_b_d         = operand_b_i;
      operand_c_d         = operand_c_i;
      fpu_op_d            = fpnew_pkg::SGNJ; // sign injection by default
      fpu_op_mod_d        = 1'b0