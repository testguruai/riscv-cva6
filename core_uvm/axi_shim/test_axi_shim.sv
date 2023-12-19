
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: axi_shim.sv
// UVM Test Bench and Test Code for axi_shim.sv Verilog Code
// ==============================================================================
class tx_seq extends uvm_sequence #(tx_transaction);

   `uvm_object_utils(tx_seq)

   function new(string name = "tx_seq");
      super.new(name);
   endfunction: new

   task body();
      tx_transaction tx;
      tx = tx_transaction::type_id::create("tx", , get_full_name());
      start_item(tx);
      randomize(tx);
      finish_item(tx);
   endtask

endclass : tx_seq

class tx_transaction extends uvm_sequence_item;

   `uvm_object_utils(tx_transaction)

   rand logic [AxiDataWidth-1:0] data;

   function new(string name = "tx_transaction");
      super.new(name);
   endfunction: new

endclass : tx_transaction

class tx_driver extends uvm_driver #(tx_transaction);

   `uvm_component_utils(tx_driver)

   uvm_analysis_port #(tx_transaction) tx_port;
   virtual tx_if tx_vif;

   function new(string name = "tx_driver", uvm_component parent);
      super.new(name, parent);
      tx_port = new("tx_port", this);
   endfunction: new

   virtual task run_phase(uvm_phase phase);

      tx_transaction tx;

      forever begin
         seq_item_port.get_next_item(tx);
         begin
            tx_port.write(tx);
            drive_tx(tx);
         end
         seq_item_port.item_done();
      end
   endtask : run_phase

   virtual task drive_tx(tx_transaction tx);
      // Drive the data to DUT
      // tx_vif is virtual interface
      tx_vif.wr_req_o  <= tx.wr_req_i;
      tx_vif.wr_data_o <= tx.wr_data_i;
      // Support for other signals omitted for brevity.
   endtask

endclass : tx_driver
