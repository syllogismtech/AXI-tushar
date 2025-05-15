class slave_busy_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(slave_busy_seq)

  axi_master_sequencer m0_seqr;

  function new(string name = "slave_busy_seq");
    super.new(name);
  endfunction

  task body();
    axi_transaction write_tr, read_tr;

    // Write transaction
    write_tr = axi_transaction::type_id::create("write_tr");
    write_tr.addr = 32'h0002_0800;
    write_tr.data = 32'h12345678;
    write_tr.trans_type = WRITE;

    `uvm_info(get_type_name(), "Sending WRITE while slave is (simulated) busy", UVM_MEDIUM)
    start_item_on(write_tr, m0_seqr);
    finish_item_on(write_tr, m0_seqr);

    // Optional small delay to simulate immediate read after write
    #5ns;

    // Read transaction
    read_tr = axi_transaction::type_id::create("read_tr");
    read_tr.addr = 32'h0002_0800;
    read_tr.trans_type = READ;

    `uvm_info(get_type_name(), "Sending READ while slave is still busy", UVM_MEDIUM)
    start_item_on(read_tr, m0_seqr);
    finish_item_on(read_tr, m0_seqr);

    `uvm_info(get_type_name(), $sformatf("Read Data: 0x%08X", read_tr.data), UVM_LOW)
  endtask
endclass
