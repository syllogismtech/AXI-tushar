class axi_read_data_txn extends uvm_sequence_item;
  rand bit [63:0] rdata_array[]; // Holds data for each beat in a burst
  bit [3:0]       rid;
  `uvm_object_utils(axi_read_data_txn)

  function new(string name = "axi_read_data_txn");
    super.new(name);
  endfunction
endclass
