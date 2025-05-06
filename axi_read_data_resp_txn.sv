class axi_read_data_resp_txn extends uvm_sequence_item;
  rand bit [31:0] addr;
  rand bit [31:0] rdata;
  rand int delay_type;    // 0, 1, 2
  rand int data_case;     // 0 = addr, 1 = ~addr, 2 = fixed 'hF

  constraint delay_type_c { delay_type inside {0, 1, 2}; }
  constraint data_case_c  { data_case  inside {0, 1, 2}; }

  `uvm_object_utils(axi_read_data_resp_txn)

  function new(string name = "axi_read_data_resp_txn");
    super.new(name);
  endfunction
endclass
