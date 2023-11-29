# VerifAI TestGuru
# explain for: amo_buffer.sv
The module `amo_buffer` buffers AMO requests. It is used to interface the AMO unit with the cache subsystem.

The module has the following inputs:

* `clk_i`: Clock
* `rst_ni`: Asynchronous reset active low
* `flush_i`: Pipeline flush
* `valid_i`: AMO is valid
* `ready_o`: AMO unit is ready
* `amo_op_i`: AMO Operation
* `paddr_i`: Physical address of store which needs to be placed in the queue
* `data_i`: Data which is placed in the queue
* `data_size_i`: Type of request we are making (e.g.: bytes to write)
* `amo_req_o`: Request to cache subsytem
* `amo_resp_i`: Response from cache subsystem
* `amo_valid_commit_i`: We have a vaild AMO in the commit stage
* `no_st_pending_i`: There is currently no store pending anymore

The module has the following outputs:

* `amo_req_o`: Request to cache subsytem
* `ready_o`: AMO unit is ready

The module works as follows:

1. When a new AMO request is received, it is buffered in a FIFO.
2. When all stores have drained and the AMO is in the commit stage, the request is validated and sent to the cache subsystem.
3. If the AMO is flushed, it is removed from the FIFO.