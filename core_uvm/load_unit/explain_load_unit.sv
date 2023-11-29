# VerifAI TestGuru
# explain for: load_unit.sv
The code defines a load unit. It takes care of all load requests. The load unit has a FSM that controls the state of the load unit. The FSM has the following states:

* IDLE: The load unit is idle and waiting for a new load request.
* WAIT_GNT: The load unit is waiting for a grant from the D$.
* SEND_TAG: The load unit is sending the tag of the load request to the D$.
* WAIT_PAGE_OFFSET: The load unit is waiting for the page offset of the load request.
* ABORT_TRANSACTION: The load unit is aborting the load transaction.
* ABORT_TRANSACTION_NI: The load unit is aborting the load transaction because the NI operation does not follow the necessary conditions.
* WAIT_TRANSLATION: The load unit is waiting for the translation of the load request.
* WAIT_FLUSH: The load unit is waiting for the flush of the store buffer.
* WAIT_WB_EMPTY: The load unit is waiting for the write buffer to be empty.

The load unit also has a queue that can hold all outstanding memory requests. The queue is used to decouple the response interface from the request interface.