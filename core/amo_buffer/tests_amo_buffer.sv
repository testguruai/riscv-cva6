# VerifAI TestGuru
# Explanation for: amo_buffer.sv
## Test Bench

```verilog
`timescale 1ns / 1ps

module amo_buffer_tb;

    // Inputs
    reg clk_i = 0;
    reg rst_ni = 1;
    reg flush_i = 0;
    reg valid_i = 0;
    reg [riscv::PLEN-1:0] paddr_i = 0;
    reg [riscv::XLEN-1:0] data_i = 0;
    reg [1:0] data_size_i = 0;
    reg amo_valid_commit_i = 0;
    reg no_st_pending_i = 1;
    reg [2:0] op_i = 0;

    // Outputs
    wire ready_o = 0;
    wire [riscv::PLEN-1:0] operand_a_o = 0;
    wire [riscv::XLEN-1:0] operand_b_o = 0;
    wire [1:0] size_o = 0;
    wire [1:0] amo_req_o = 0;
    wire [2:0] amo_op_o = 0;
    wire amo_resp_i = 0;

    // Instantiate the Unit Under Test (UUT)
    amo_buffer uut (
            .clk_i(clk_i),
            .rst_ni(rst_ni),
            .flush_i(flush_i),
            .valid_i(valid_i),
            .ready_o(ready_o),
            .paddr_i(paddr_i),
            .data_i(data_i),
            .data_size_i(data_size_i),
            .amo_req_o(amo_req_o),
            .amo_op_i({{2{1'b0}}, op_i}),
            .amo_resp_i({{2{1'b0}}, amo_resp_i}),
            .amo_valid_commit_i(amo_valid_commit_i),
            .no_st_pending_i(no_st_pending_i)
     );

    initial begin
        // Initialize Inputs
        clk_i = 0;
        rst_ni = 0;
        flush_i = 0;
        valid_i = 0;
        paddr_i = 0;
        data_i = 0;
        data_size_i = 0;
        op_i = 0;
        amo_valid_commit_i = 0;
        no_st_pending_i = 1;

        #1
        rst_ni = 1;

        // Wait 100 ns for global reset to finish
        #100;

        // Test case 1
        // valid amo operation with data and address
        op_i = 1;
        paddr_i = 1234;
        data_i = 9876;
        data_size_i = 1;
        valid_i = 1;
        #10;

        // flush the amo buffer
        flush_i = 1;
        #10;

        flush_i = 0;
        #10;

        op_i = 2;
        paddr_i = 5678;
        data_i = 5432;
        data_size_i = 0;
        valid_i = 1;
        #10;

        // Test case 2
        // Invalid AMO received, buffer must not acknowledge
        valid_i = 0;
        #10;

        op_i = 100;
        paddr_i = 8765;
        data_i = 1234;
        data_size_i = 2;
        valid_i = 1;
        #10;

        // flush the amo buffer
        flush_i = 1;
        #10;

        flush_i = 0;
        #10;

        op_i = 4;
        paddr_i = 9123;
        data_i = 5678;
        data_size_i = 1;
        valid_i = 1;
        #10;


        $finish;
    end

endmodule
```

## Test Code

```python
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer


@cocotb.test()
async def amo_buffer_test(dut):
    clock = Clock(dut.clk_i, 10, units="ns")
    cocotb.fork(clock.start())

    # Test case 1
    # valid amo operation with data and address
    dut.op_i = 1
    dut.paddr_i = 1234
    dut.data_i = 9876
    dut.data_size_i = 1
    dut.valid_i = 1
    await Timer(10, units="ns")

    # flush the amo buffer
    dut.flush_i = 1
    await Timer(10, units="ns")

    dut.flush_i = 0
    await Timer(10, units="ns")

    dut.op_i = 2
    dut.paddr_i = 5678
    dut.data_i = 5432
    dut.data_size_i = 0
    dut.valid_i = 1
    await Timer(10, units="ns")

    # Test case 2
    # Invalid AMO received, buffer must not acknowledge
    dut.valid_i = 0
    await Timer(10, units="ns")

    dut.op_i = 100
    dut.paddr_i = 8765
    dut.data_i = 1234
    dut.data_size_i = 2
    dut.valid_i = 1
    await Timer(10, units="ns")

    # flush the amo buffer
    dut.flush_i = 1
    await Timer(10, units="ns")

    dut.flush_i = 0
    await Timer(10, units="ns")

    dut.op_i = 4
    dut.paddr_i = 9123
    dut.data_i = 5678
    dut.data_size_i = 1
    dut.valid_i = 1
    await Timer(10, units="ns")
```