class axi_slave_read_seq extends uvm_sequence #(axi_read_data_txn);
  `uvm_object_utils(axi_slave_read_seq)

  function new(string name = "axi_slave_read_seq");
    super.new(name);
  endfunction

  task body();
    axi_read_data_txn txn;
    txn = axi_read_data_txn::type_id::create("txn");

    int burst_len = 15;            

  bit [63:0] base_value = 64'h1000_0000_0000_0000;
  txn.rdata_array = new[txn.burst_len + 1];
  foreach (txn.rdata_array[i])
  txn.rdata_array[i] = base_value + i;

    start_item(txn);
    finish_item(txn);
  endtask
endclass
