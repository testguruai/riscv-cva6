# VerifAI TestGuru
# explain for: alu.sv
This module implements the ALU of the Ariane processor. It supports the following operations:

- Add/Sub
- Bitwise operations
- Shifts
- Comparisons
- Bit counting

The ALU is configured by the `fu_data_i` input, which contains the operation to be performed, the operands, and the destination register. The result of the operation is written to the `result_o` output.