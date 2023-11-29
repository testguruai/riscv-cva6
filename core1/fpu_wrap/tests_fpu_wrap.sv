module fpu_wrap (
  input logic clk_i,
  input logic rst_ni,
  input logic flush_i,
  input logic fpu_valid_i,
  output logic fpu_ready_o,
  input  logic[1:0] fu_data_i,
  input  logic[1:0] fpu_fmt_i,
  input  logic[2:0] fpu_rm_i,
  input  logic[2:0] fpu_frm_i,
  output logic[TRANS_ID_BITS-1:0] fpu_trans_id_o,
  output logic[FLEN-1:0] result_o,
  output logic fpu_valid_o,
  output exception_t fpu_exception_o
);

  // Wrapper code here

endmodule
