
// ==============================================================================
// Copyright 2023 VerifAI Inc. All Rights Reserved.
// VerifAI TestGuru
// Test for: dromajo_ram.sv
// UVM Test Bench and Test Code for dromajo_ram.sv Verilog Code
// ==============================================================================
// Define Transaction for UVM
class dromajo_ram_transaction extends uvm_sequence_item;
`uvm_object_utils(dromajo_ram_transaction)

   rand bit          CSel_SI;
   rand bit          WrEn_SI;
   rand bit [7:0]    BEn_SI;
   rand bit [63:0]   WrData_DI;
   rand bit [9:0]    Addr_DI;

   function new(string name = "dromajo_ram_sequence_item");
      super.new(name);
   endfunction 

   function void do_copy(uvm_object rhs);
      dromajo_ram_transaction drt;
      if(!$cast(drt, rhs))
         `uvm_fatal("CASTERR", "Failed to cast to dromajo_ram_transaction")
      CSel_SI    = drt.CSel_SI;
      WrEn_SI    = drt.WrEn_SI;
      BEn_SI     = drt.BEn_SI;
      WrData_DI  = drt.WrData_DI;
      Addr_DI    = drt.Addr_DI;
   endfunction 

   function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      dromajo_ram_transaction drt;
      if(!$cast(drt, rhs))
         `uvm_fatal("CASTERR", "Failed to cast to dromajo_ram_transaction")
      if(!(CSel_SI  == drt.CSel_SI))  return 0;
      if(!(WrEn_SI  == drt.WrEn_SI))  return 0;
      if(!(BEn_SI   == drt.BEn_SI))   return 0;
      if(!(WrData_DI== drt.WrData_DI))return 0;
      if(!(Addr_DI  == drt.Addr_DI))  return 0;
      return 1;
   endfunction 

   function void do_pack(uvm_packer packer);
      packer.pack_field_int(CSel_SI, 1);
      packer.pack_field_int(WrEn_SI, 1);
      packer.pack_field_int(BEn_SI, 8);
      packer.pack_field_int(WrData_DI, 64);
      packer.pack_field_int(Addr_DI, 10);
   endfunction 

endclass 
