// VerifAI TestGuru
// tests for: axi_adapter.sv

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
  output axi_req_t                 axi_req_o,
  input  axi_rsp_t                 axi_resp_i
);
  localparam BURST_SIZE = (DATA_WIDTH/AXI_DATA_WIDTH)-1;
  localparam ADDR_INDEX = ($clog2(DATA_WIDTH/AXI_DATA_WIDTH) > 0) ? $clog2(DATA_WIDTH/AXI_DATA_WIDTH) : 1;

  enum logic [3:0] {
    IDLE, WAIT_B_VALID, WAIT_LAST_W_READY, WAIT_LAST_W_READY_AW_READY, WAIT_AW_READY_BURST,
    WAIT_R_VALID, WAIT_R_VALID_MULTIPLE, WAIT_AMO_R_VALID, COMPLETE_READ
  } state_q, state_d;

  // counter for AXI transfers
  logic [ADDR_INDEX-1:0] cnt_d, cnt_q;
  logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][AXI_DATA_WIDTH-1:0] cache_line_d, cache_line_q;
  logic [(DATA_WIDTH/AXI_DATA_WIDTH)-1:0][(AXI_DATA_WIDTH/8)-1:0] be_d, be_q;
  
  // Sequential logic
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state_q <= IDLE;
      cnt_q <= 0;
      cache_line_q <= '0;
      be_q <= '0;
    end else begin
      state_q <= state_d;
      cnt_q <= cnt_d;
      cache_line_q <= cache_line_d;
      be_q <= be_d;
    end
  end

  // Combinaitional logic
  always_comb begin
    gnt_o = (state_q == IDLE && req_i) ? 1'b1 : 1'b0;
    id_o = id_i;
    axi_req_o.addr = addr_i;
    axi_req_o.prot = 2'b11; // Hardcoded protection bits
    axi_req_o.qos = 4'b0000; // No QoS
        
    case (state_q)
      IDLE:
        case (type_i)
          ariane_axi::ad_dummy_e: begin
            if (req_i) begin
              axi_req_o.prot = 2'b10; // Available for shared reads and writes
              axi_req_o.type = clean_adp_type;
              axi_req_o.len = { {12{1'b0}}, riscv::XLEN-1 - CACHELINE_BYTE_OFFSET };
              axi_req_o.id = id_i;
              axi_req_o.always_do = 1'b1;
        
              // Critical word handling (Read)
              critical_word_valid_o = CRITICAL_WORD_FIRST;
              if (be_i[0] && !req_i) critical_word_o = (DATA_WIDTH/AXI_DATA_WIDTH-1 == cnt_q) ? rdata_o[0] : '0;
            end
          end
                    
          default: begin
              state_d = IDLE;
              cnt_d = 0;
              cache_line_d = '0;
              be_d = '0;
          end
      end
              
      // Remaining code...
              
    endcase
  end
endmodule
