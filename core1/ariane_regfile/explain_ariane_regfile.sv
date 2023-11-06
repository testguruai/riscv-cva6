# VerifAI TestGuru
# explain for: ariane_regfile.sv
This module implements a register file with 31 or 15x 32 bit wide registers.
Register 0 is fixed to 0. This register file is based on
latches and is thus smaller than the flip-flop based RF.

The module has three inputs:
- clk_i: clock
- rst_ni: reset
- test_en_i: disable clock gates for testing

The module has two outputs:
- rdata_o: read data
- wdata_i: write data

The module has three read ports and two write ports.

The register file is organized as a memory with 31 or 15 words of 32 bits each.
The address of the register to be read or written is given by the raddr_i and waddr_i signals.
The we_i signal indicates whether a write operation is performed.

The read data is available on the rdata_o signals.

The write data is stored in the wdata_q signals.

The mem_clocks signals are the clock signals for the individual registers.

The waddr_onehot and waddr_onehot_q signals are used to generate the one-hot encoded write address.

The latch_wdata process is used to write the data to the registers.