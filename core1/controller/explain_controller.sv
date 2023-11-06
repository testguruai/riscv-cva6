# VerifAI TestGuru
# explain for: controller.sv
The flush controller is responsible for flushing the pipeline in case of exceptions, mis-predictions, or CSR instructions with side-effects.

The `flush_ctrl` always block first checks if a mis-prediction has occurred. If so, it flushes the un-issued instructions and the IF stage.

Next, the block checks if a fence instruction has been issued. If so, it flushes the entire pipeline, including the DCache.

The `fence_active_d` and `fence_active_q` signals are used to track whether a fence instruction is currently being flushed. This is necessary to avoid deadlocks in the case of a nested fence instruction.

The `flush_dcache` signal is used to flush the DCache. In the case of a write-through cache, this signal is not needed.

The `sfence_vma_i` signal is used to flush the TLBs and the pipeline.

Finally, the block checks if an exception has occurred. If so, it flushes the entire pipeline and the branch predictors.