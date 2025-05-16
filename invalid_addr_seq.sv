class invalid_addr_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(invalid_addr_seq)

  axi_master_sequencer m0_seqr;

  function new(string name = "invalid_addr_seq");
    super.new(name);
  endfunction

  task body();
    axi_transaction write_tr, read_tr;

    write_tr = axi_transaction::type_id::create("write_tr");
    write_tr.addr = 32'h0004_0000;
    write_tr.data = 32'hDEADBEEF;
    write_tr.trans_type = WRITE;

    `uvm_info(get_type_name(), "Sending WRITE to invalid address (no slave)", UVM_MEDIUM)
    start_item_on(write_tr, m0_seqr);
    finish_item_on(write_tr, m0_seqr);

    read_tr = axi_transaction::type_id::create("read_tr");
    read_tr.addr = 32'h0004_0000;
    read_tr.trans_type = READ;

    `uvm_info(get_type_name(), "Sending READ to invalid address (no slave)", UVM_MEDIUM)
    start_item_on(read_tr, m0_seqr);
    finish_item_on(read_tr, m0_seqr);

    `uvm_info(get_type_name(), $sformatf("Read Data (invalid): 0x%08X", read_tr.data), UVM_LOW)
  endtask
endclass

