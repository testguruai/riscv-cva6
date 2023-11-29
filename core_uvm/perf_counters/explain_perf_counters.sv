# VerifAI TestGuru
# explain for: perf_counters.sv
The perf_counters module implements the performance counters for the RISC-V core. It implements the following counters:

* L1 I-cache miss
* L1 D-cache miss
* ITLB miss
* DTLB miss
* Load instruction
* Store instruction
* Branch instruction
* Call instruction
* Return instruction
* Exception
* Exception return
* Mispredicted branch
* Store buffer full
* Instruction fetch buffer empty

The module uses a 32-bit register file to store the counter values. The register file is indexed by the 5-bit address of the counter. The address is shifted left by 5 bits to align with the register file. The module also implements a write enable signal to allow the counters to be written to. The write enable signal is asserted when the write address is valid and the write data is not zero.