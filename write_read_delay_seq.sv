class write_read_delay_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(write_read_delay_seq)

  axi_master_sequencer m0_seqr;

  function new(string name = "write_read_delay_seq");
    super.new(name);
  endfunction

  task body();
    axi_transaction write_tr, read_tr;

    // 1. Write to Slave 2
    write_tr = axi_transaction::type_id::create("write_tr");
    write_tr.addr = 32'h0002_0200;
    write_tr.data = 32'hABCDEF01;
    write_tr.trans_type = WRITE;

    `uvm_info(get_type_name(), "Starting delayed WRITE to Slave 2", UVM_MEDIUM)
    start_item_on(write_tr, m0_seqr);
    finish_item_on(write_tr, m0_seqr);

    // 2. Read from same address
    read_tr = axi_transaction::type_id::create("read_tr");
    read_tr.addr = 32'h0002_0200;
    read_tr.trans_type = READ;

    `uvm_info(get_type_name(), "Starting delayed READ from Slave 2", UVM_MEDIUM)
    start_item_on(read_tr, m0_seqr);
    finish_item_on(read_tr, m0_seqr);

    `uvm_info(get_type_name(), $sformatf("Read Data (after delay): 0x%08X", read_tr.data), UVM_LOW)
  endtask
endclass
