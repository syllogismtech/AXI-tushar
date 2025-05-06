class axi_read_data_resp_txn extends uvm_sequence_item;
  rand bit [31:0] addr;
  rand bit [31:0] rdata;
  rand int delay_type;    
  rand int data_case;     
  rand extra_burst_len;
  //typedef enum {DIRECT, RANDOM, FIXED} rdata_mode_e;
  //rdata_mode_e rdata_mode;

  constraint delay_type_c { delay_type inside {0, 1, 2}; }
  constraint rdata_mode_e {rdata_mode inside{0,1,2};}
 // constraint data_case_c  { data_case  inside {0, 1, 2}; }

  `uvm_object_utils(axi_read_data_resp_txn)

  function new(string name = "axi_read_data_resp_txn");
    super.new(name);
  endfunction
endclass
