# VerifAI TestGuru
# tests for: axi_adapter.sv
Please write a test bench and test code for the following verilog code
 ```
/* Copyright 2018 ETH Zurich and University of Bologna.
 * Copyright and related rights are licensed under the Solderpad Hardware
 * License, Version 0.51 (the "License"); you may not use this file except in
 * compliance with the License.  You may obtain a copy of the License at
 * http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
 * or agreed to in writing, software, hardware and materials distributed under
 * this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 * File:  axi_adapter.sv
 * Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
 * Date:   1.8.2018
 *
 * Description: Manages communication with the AXI Bus
 */
//import std_cache_pkg::*;

module axi_adapter #(
  parameter int unsigned DATA_WIDTH            = 256,
  parameter logic        CRITICAL_WORD_FIRST   = 0, // the AXI subsystem needs to support wrapping reads for this feature
  parameter int unsigned CACHELINE_BYTE_OFFSET = 8,
  parameter int unsigned AXI_ADDR_WIDTH        = 0,
  parameter int unsigned AXI_DATA_WIDTH        = 0,
  parameter int unsigned AXI_ID_WIDTH          = 0,
  parameter type axi_req_t = ariane_axi::req_t,
  parameter type axi_rsp_t = ariane_axi::resp_t
)(
  input  logic                             clk_i,  // Clock
  input  logic                             rst_ni, // Asynchronous reset active low

  input  logic                             req_i,
  input  ariane_axi::ad_req_t              type_i,
  input  ariane_pkg::amo_t                 amo_i,
  output logic                             gnt_o,
  input  logic [riscv::XLEN-1:0]           addr_i,
  input  logic                             we_i,
  input  logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][AXI_DATA_WIDTH-1:0]      wdata_i,
  input  logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][(AXI_DATA_WIDTH/8)-1:0]  be_i,
  input  logic [1:0]                       size_i,
  input  logic [AXI_ID_WIDTH-1:0]          id_i,
  // read port
  output logic                             valid_o,
  output logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][AXI_DATA_WIDTH-1:0] rdata_o,
  output logic [AXI_ID_WIDTH-1:0]          id_o,
  // critical word - read port
  output logic                             critical_word_valid_o,
  output logic [AXI_DATA_WIDTH-1:0]        critical_word_o,
  // AXI port
  output axi_req_t                         axi_req_o,
  input  axi_rsp_t                         axi_resp_i
);
  localparam BURST_SIZE = (DATA_WIDTH/AXI_DATA_WIDTH)-1;
  localparam ADDR_INDEX = ($clog2(DATA_WIDTH/AXI_DATA_WIDTH) > 0) ? $clog2(DATA_WIDTH/AXI_DATA_WIDTH) : 1;

  enum logic [3:0] {
    IDLE, WAIT_B_VALID, WAIT_AW_READY, WAIT_LAST_W_READY_AW_READY, WAIT_AW_READY_BURST,
    WAIT_R_VALID, WAIT_R_VALID_MULTIPLE, COMPLETE_READ, WAIT_AMO_R_VALID
  } state_q, state_d;

  // counter for AXI transfers
  logic [ADDR_INDEX-1:0] cnt_d, cnt_q;
  logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][AXI_DATA_WIDTH-1:0] cache_line_d