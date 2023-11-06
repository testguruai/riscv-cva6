# VerifAI TestGuru
# explain for: re_name.sv
The re_name module implements the renaming of registers in the RISC-V pipeline. It takes as input the instruction to be issued, the scoreboard entry for the instruction, and the flush signal. The output is the instruction to be issued and the scoreboard entry for the instruction.

The module first passes through the handshaking signals. It then keeps track of the renaming data structures. The re-naming is done in two steps. First, the destination register is renamed if the instruction is acknowledged. Second, the source registers are renamed according to the register file used for the source operands. The module also handles flushes by resetting the renaming data structures.