class cross_master_rw_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(cross_master_rw_seq)

  axi_master_sequencer m0_seqr;
  axi_master_sequencer m1_seqr;

  function new(string name = "cross_master_rw_seq");
    super.new(name);
  endfunction

  task body();
    axi_transaction write_tr, read_tr;

    // 1. Master 1 writes to Slave 1
    write_tr = axi_transaction::type_id::create("write_tr");
    write_tr.addr = 32'h0001_0100;
    write_tr.data = 32'hCAFEBABE;
    write_tr.trans_type = WRITE;

    `uvm_info(get_type_name(), "Starting WRITE from Master 1", UVM_MEDIUM)
    start_item_on(write_tr, m1_seqr);
    finish_item_on(write_tr, m1_seqr);

    // 2. Master 0 reads from same address
    read_tr = axi_transaction::type_id::create("read_tr");
    read_tr.addr = 32'h0001_0100;
    read_tr.trans_type = READ;

    `uvm_info(get_type_name(), "Starting READ from Master 0", UVM_MEDIUM)
    start_item_on(read_tr, m0_seqr);
    finish_item_on(read_tr, m0_seqr);

    // Optional: print data
    `uvm_info(get_type_name(), $sformatf("Master 0 read data: 0x%08X", read_tr.data), UVM_LOW)
  endtask
endclass
