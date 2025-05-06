class axi_read_data_resp_txn extends uvm_sequence_item;
`uvm_object_utils(axi_read_data_resp_txn)    
  rand int extra_burst_len;
  rand int rdata_mode;
  rand int delay_cycles;
  
  bit [63:0] araddr;
  bit [3:0] arid;
  int arlen;
  
  constraint delay_type_c { delay_type inside {0, 1, 2}; }
  constraint rdata_mode_e {rdata_mode inside{0,1,2};}

  function void set_dut_arinfo(bit [3:0] id, bit [63:0] addr, int len);
    arid = id;
    araddr = addr;
    arlen = len;
  endfunction

  function int get_burst_len();
    return arlen + 1 + extra_burst_len;
  endfunction

  function bit [63:0] compute_rdata(int i);
    case (rdata_mode)
      0: return araddr + i;
      1: return $urandom();
      2: return 64'hFFFF_FFFF_FFFF_FFFF;
    endcase
  endfunction

  function new(string name = "axi_read_data_resp_txn");
    super.new(name);
  endfunction
endclass
