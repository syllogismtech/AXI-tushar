class axi_read_data_txn extends uvm_sequence_item;
  rand bit [3:0] id;
  rand bit [31:0] data_queue[$];
  rand bit [1:0] resp_queue[$];

  `uvm_object_utils(axi_read_data_txn)

  function new(string name = "axi_read_data_txn");
    super.new(name);
  endfunction

  function string convert2string();
    string s;
    s = $sformatf("ID: %0d, Data: ", id);
    foreach (data_queue[i])
      s = {s, $sformatf("%0h ", data_queue[i])};
    return s;
  endfunction
endclass
