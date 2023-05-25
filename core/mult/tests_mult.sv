# VerifAI TestGuru
# Explanation for: mult.sv
````markdown
# UVM Test Bench and UVM Test for mult module

The *mult* module takes two operands and performs multiplication or division based on the input operator value. It has two input control signals - mult_valid_i and flush_i which are used to control the multiplication and division operations.

## UVM Test Bench

The UVM test bench for *mult* module will include the following components:

- **mult_tb**: The test bench module which instantiates the *mult* design and provides the input packets.

- **mult_seq_item**: The sequence item which represents the input transaction sent to *mult*.

- **mult_seq**: The sequence that generates the input transactions and sends them to the *mult* module.

- **mult_driver**: The driver that drives the sequence items to the *mult* module.

- **mult_monitor**: The monitor that monitors the output of the *mult* module and raises errors if required.

To keep this example simple, we will only include a basic test case for the multiplication operation.

````



## UVM Test

```systemverilog
class mult_seq_item extends uvm_sequence_item;
    rand logic [31:0] operand_a;
    rand logic [31:0] operand_b;
    rand logic         operator;

    function new(string name = "");
        super.new(name);
        operand_a = 0;
        operand_b = 0;
        operator = 0;
    endfunction

    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field_int("operand_a", operand_a, $bits(operand_a), UVM_DEC, ".", "A");
        printer.print_field_int("operand_b", operand_b, $bits(operand_b), UVM_DEC, ".", "B");
        printer.print_field_int("operator", operator, $bits(operator), UVM_BINARY, ".", "Op");
    endfunction

    `uvm_object_utils(mult_seq_item)
endclass : mult_seq_item

class mult_seq extends uvm_sequence;
    mult_seq_item item;

    `uvm_object_utils(mult_seq)

    function new(string name = "mult_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat (5) begin
            item = mult_seq_item::type_id::create("m_seq_item");
            item.operand_a = $urandom_range(0, 65535);
            item.operand_b = $urandom_range(0, 65535);
            item.operator = $urandom_range(1, 5);
            send(item);
        end
    endtask : body
endclass : mult_seq

class mult_driver extends uvm_driver#(mult_seq_item);
    `uvm_component_param_utils(mult_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            @(posedge env.clk);
            env.mult_valid_i <= 1;
            env.fu_data_i.operand_a <= req.operand_a;
            env.fu_data_i.operand_b <= req.operand_b;
            env.fu_data_i.operator <= req.operator;
            @(posedge env.clk);
            env.mult_valid_i <= 0;
            item_done(req);
        end
    endtask : run_phase
endclass : mult_driver

class mult_monitor extends uvm_monitor;
    `uvm_component_param_utils(mult_monitor)

    mult_seq_item  item;
    bit [31:0]     result;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge env.clk);
            if(env.mult_valid_o) begin
                result = env.result_o;
                // Check that the result is the expected multiplication result.
                if (env.fu_data_i.operator inside { MUL, MULH, MULHU, MULHSU, MULW, CLMUL, CLMULH, CLMULR }) begin
                    if(result != env.fu_data_i.operand_a * env.fu_data_i.operand_b) begin
                        `uvm_error("MULT Monitor", $sformatf("Multiplication failed | Expected: %d | Got: %d", env.fu_data_i.operand_a * env.fu_data_i.operand_b, result));
                    end
                end
            end
        end
    endtask : run_phase
endclass : mult_monitor

class mult_tb extends uvm_env;
    `uvm_component_param_utils(mult_tb)

    mult mult_dut;
    mult_seq seq;
    mult_driver driver;
    mult_monitor monitor;

    `uvm_component_utils(mult_tb)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mult_dut = mult::type_id::create("mult_dut", this);
        seq = mult_seq::type_id::create("seq");
        driver = mult_driver::type_id::create("driver", this);
        monitor = mult_monitor::type_id::create("monitor", this);
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        seq.seq_item_port.connect(driver.seq_item_export);
    endfunction : connect_phase

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(driver);
        phase.drop_objection(this);
        finish(1);
    endtask : run_phase
endclass : mult_tb
```