# VerifAI TestGuru
# explain for: instr_realign.sv
The instr_realign module takes 32-bit aligned cache blocks and extracts the instructions.
As we are supporting the compressed instruction set extension in a 32 bit instruction word
are up to 2 compressed instructions.
Furthermore those instructions can be arbitrarily interleaved which makes it possible to fetch
only the lower part of a 32 bit instruction.
Furthermore we need to handle the case if we want to start fetching from an unaligned
instruction e.g. a branch.

The module has a number of inputs and outputs.
The inputs are:
- clk_i: clock
- rst_ni: reset
- flush_i: flush
- valid_i: valid instruction
- serving_unaligned_o: we have an unaligned instruction in [0]
- address_i: instruction address
- data_i: instruction data

The outputs are:
- valid_o: valid instruction
- addr_o: instruction address
- instr_o: instruction data