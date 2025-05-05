class axi_read_data_resp_txn extends uvm_sequence_item;
  rand bit [63:0] rdata_array[]; // Holds data for each beat in a burst
  bit [3:0]       rid;
  rand bit [1:0]  delay_type;    
  rand int        delay_cycles; 
  `uvm_object_utils(axi_read_data_resp_txn)

  constraint delay_type_c {
    delay_type inside {[0:2]};
  }

  constraint delay_cycles_c {
    if (delay_type == 0) delay_cycles == 0;
    else if (delay_type == 1) delay_cycles inside {[1:14]};
    else if (delay_type == 2) delay_cycles == 15;
  }

  
  function new(string name = "axi_read_data_resp_txn");
    super.new(name);
  endfunction
endclass
