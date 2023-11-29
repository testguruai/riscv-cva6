// VerifAI TestGuru
// tests for: ariane_regfile.sv

// Testbench for ariane_regfile

module testbench;

    logic clk, rst;
    logic [4:0] raddr_i;
    logic [31:0] rdata_o;
    logic [4:0] waddr_i;
    logic [31:0] wdata_i;
    logic we_i;

    ariane_regfile #(
        .DATA_WIDTH(32),
        .NR_READ_PORTS(2),
        .NR_WRITE_PORTS(2),
        .ZERO_REG_ZERO(0)
    ) dut (
        .clk_i(clk),
        .rst_n(rst),
        .test_en_i(1'b1),
        .raddr_i(raddr_i),
        .rdata_o(rdata_o),
        .waddr_i(waddr_i),
        .wdata_i(wdata_i),
        .we_i(we_i)
    );

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        #10ns;
        rst = 1'b0;

        // Write to register 0
        waddr_i = 5'b00000;
        wdata_i = 32'h00000001;
        we_i = 1'b1;
        #10ns;

        // Read from register 0
        raddr_i = 5'b00000;
        #10ns;
        assert(rdata_o === 32'h00000001);

        // Write to register 1
        waddr_i = 5'b00001;
        wdata_i = 32'h00000002;
        we_i = 1'b1;
        #10ns;

        // Read from register 1
        raddr_i = 5'b00001;
        #10ns;
        assert(rdata_o === 32'h00000002);

        $stop;
    end

    always #5 clk = ~clk;

endmodule
\