# VerifAI TestGuru
# explain for: multiplier.sv
The multiplier module is a pipelined module that performs multiplication of two 64-bit operands. It supports the following operations: MUL, MULH, MULHU, MULHSU, MULW, CLMUL, CLMULH, CLMULR. The module has a single pipeline register. The control signals are mult_valid_o, mult_trans_id_o, mult_ready_o. The data signals are result_o.