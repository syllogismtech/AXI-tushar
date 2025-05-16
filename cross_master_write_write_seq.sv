class cross_master_write_write_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(cross_master_write_write_seq)

  axi_master_sequencer m0_seqr;
  axi_master_sequencer m1_seqr;

  function new(string name = "cross_master_write_write_seq");
    super.new(name);
  endfunction

  task body();
    axi_transaction write_tr_m0, write_tr_m1;

    write_tr_m0 = axi_transaction::type_id::create("write_tr_m0");
    write_tr_m0.addr = 32'h0001_0200;
    write_tr_m0.data = 32'hDEADBEEF;
    write_tr_m0.trans_type = WRITE;

    write_tr_m1 = axi_transaction::type_id::create("write_tr_m1");
    write_tr_m1.addr = 32'h0001_0200;
    write_tr_m1.data = 32'hFEEDFACE;
    write_tr_m1.trans_type = WRITE;

    fork
      begin
        `uvm_info(get_type_name(), "Master 0: Starting WRITE", UVM_MEDIUM)
        start_item_on(write_tr_m0, m0_seqr);
        finish_item_on(write_tr_m0, m0_seqr);
        `uvm_info(get_type_name(), "Master 0: WRITE Completed", UVM_MEDIUM)
      end

      begin
        `uvm_info(get_type_name(), "Master 1: Starting WRITE", UVM_MEDIUM)
        start_item_on(write_tr_m1, m1_seqr);
        finish_item_on(write_tr_m1, m1_seqr);
        `uvm_info(get_type_name(), "Master 1: WRITE Completed", UVM_MEDIUM)
      end
    join

    axi_transaction read_tr;
    read_tr = axi_transaction::type_id::create("read_tr");
    read_tr.addr = 32'h0001_0200;
    read_tr.trans_type = READ;

    `uvm_info(get_type_name(), "Reading back the final data", UVM_MEDIUM)
    start_item_on(read_tr, m0_seqr);
    finish_item_on(read_tr, m0_seqr);

    `uvm_info(get_type_name(), $sformatf("Final read data at 0x00010200 = 0x%08X", read_tr.data), UVM_LOW)
  endtask
endclass
