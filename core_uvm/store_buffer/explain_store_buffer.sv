# VerifAI TestGuru
# explain for: store_buffer.sv
The store buffer has two parts: a speculative queue and a commit queue. The speculative queue stores speculative stores, which may be evicted if the core flushes. The commit queue stores non-speculative stores, which will be committed to the memory hierarchy.

The core interface of the store buffer is responsible for accepting new store requests and checking if the store buffer is ready to accept a new request. The core interface also evicts speculative stores when the core flushes.

The commit queue interface is responsible for committing non-speculative stores to the memory hierarchy. The commit queue interface also checks if the commit queue is empty.