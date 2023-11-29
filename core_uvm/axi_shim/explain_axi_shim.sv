# VerifAI TestGuru
# explain for: axi_shim.sv
The AXI write channel is implemented using a state machine. The state machine has 5 states:

* IDLE: The AXI write channel is idle and waiting for an incoming request.
* WAIT_AW_READY: The AXI write channel is waiting for the AW_READY signal from the AXI bus.
* WAIT_LAST_W_READY: The AXI write channel is waiting for the W_READY signal from the AXI bus and the last data word has been sent.
* WAIT_LAST_W_READY_AW_READY: The AXI write channel is waiting for the W_READY signal from the AXI bus and the last data word has been sent. The AW_READY signal has also been received.
* WAIT_AW_READY_BURST: The AXI write channel is waiting for the AW_READY signal from the AXI bus and the first data word has been sent.

The state machine transitions to the next state based on the incoming signals and the current state. For example, if the AXI write channel is in the WAIT_AW_READY state and the AW_READY signal is received, the state machine will transition to the WAIT_LAST_W_READY state.

The AXI write channel also has a counter that keeps track of the number of data words that have been sent. The counter is incremented when the W_VALID signal is asserted and the last data word has not been sent. The counter is cleared when the AW_READY signal is received and the AXI write channel is in the IDLE state.

The AXI write channel generates the AXI write request and response signals. The AXI write request signals are generated when the AXI write channel is in the WAIT_AW_READY or WAIT_LAST_W_READY_AW_READY state. The AXI write response signals are generated when the AXI write channel is in the WAIT_LAST_W_READY state.