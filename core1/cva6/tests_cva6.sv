# VerifAI TestGuru
# tests for: cva6.sv
Incomplete code. Please complete the following code.

```
   .csr_commit_o            ( csr_commit_commit_ex        ),
    // LSU
    .lsu_valid_i            ( lsu_valid_id_ex             ),
    .lsu_result_o           ( lsu_result_ex_id            ),
    .lsu_trans_id_o         ( lsu_trans_id_ex_id          ),
    .lsu_valid_o            ( lsu_valid_ex_id             ),
    .lsu_exception_o        ( lsu_exception_ex_id         ),
    .lsu_ready_o            ( lsu_ready_ex_id             ),
    // Multiplier
    .mult_valid_i            ( mult_valid_id_ex             ),
    // FPU
    .fpu_valid_i            ( fpu_valid_id_ex             ),
    .fpu_result_o           ( fpu_result_ex_id            ),
    .fpu_trans_id_o         ( fpu_trans_id_ex_id          ),
    .fpu_valid_o            ( fpu_valid_ex_id             ),
    .fpu_exception_o        ( fpu_exception_ex_id         ),
    .fpu_ready_o            ( fpu_ready_ex_id             ),
    // Commit
    .commit_instr_i         ( commit_instr_id_commit       ),
    .commit_ack_i           ( commit_ack                   ),
    .trans_id_i             ( trans_id_ex_id               ),
    .wbdata_i               ( wbdata_ex_id                 ),
    .ex_ex_i                ( ex_ex_ex_id                  ),
    .wt_valid_i             ( wt_valid_ex_id               ),
    .x_we_i                 ( x_we_ex_id                   ),
    .waddr_i                ( waddr_commit_id              ),
    .wdata_i                ( wdata_commit_id              ),
    .we_gpr_i               ( we_gpr_commit_id             ),
    .we_fpr_i               ( we_fpr_commit_id             ),
    .x_off_instr_o          ( x_off_instr_id_ex            ),
    .x_issue_valid_o        ( x_issue_valid_id_ex          ),
    .x_issue_ready_i        ( x_issue_ready_ex_id          ),
    .lsu_addr_i             ( lsu_addr                     ),
    .lsu_rmask_i            ( lsu_rmask                    ),
    .lsu_wmask_i            ( lsu_wmask                    ),
    .lsu_addr_trans_id_i     ( lsu_addr_trans_id            ),
    .*
  );
```