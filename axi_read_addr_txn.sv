class axi_read_addr_txn extends uvm_sequence_item;
  rand bit [3:0] id;
  rand bit [31:0] addr;
  rand bit [1:0] burst;
  rand bit [7:0] len;
  rand bit [2:0] size;

  `uvm_object_utils(axi_read_addr_txn)

  function new(string name = "axi_read_addr_txn");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("ID: %0d, Addr: %0h, Burst: %0d, Len: %0d, Size: %0d",
                     id, addr, burst, len, size);
  endfunction
endclass
