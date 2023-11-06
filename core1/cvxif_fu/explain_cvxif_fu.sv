# VerifAI TestGuru
# explain for: cvxif_fu.sv
This module implements the functional unit for the logic of the CoreV-X-Interface. It receives the instruction from the issue stage, sends it to the coprocessor, and receives the result back. If the instruction is illegal, it generates an exception.