# VerifAI TestGuru
# explain for: lsu_bypass.sv
The LSU control is a module that handles the address calculation and memory interface signals.
It consists of two independent blocks: the load unit and the store unit.
The load unit and the store unit signal their readiness with separate signals.
If they are not ready, the LSU control should keep the last applied signals stable.
Furthermore, it can be the case that another request for one of the two store units arrives.
In this case, the LSU control should sample it and store it for later application to the units.
It does so by storing it in a two-element FIFO.
This is necessary as we only know very late in the cycle whether the load/store will succeed (address check, TLB hit mainly).
So we better unconditionally allow another request to arrive and store this request in case we need to.