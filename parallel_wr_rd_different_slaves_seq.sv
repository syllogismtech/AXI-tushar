class parallel_wr_rd_different_slaves_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(parallel_wr_rd_different_slaves_seq)

  axi_master_sequencer m0_seqr;
  axi_master_sequencer m1_seqr;

  function new(string name = "parallel_wr_rd_different_slaves_seq");
    super.new(name);
  endfunction

  task body();
    axi_transaction write_m0, read_m0;
    axi_transaction write_m1, read_m1;

    write_m0 = axi_transaction::type_id::create("write_m0");
    write_m0.addr = 32'h0000_0500;
    write_m0.data = 32'h12345678;
    write_m0.trans_type = WRITE;

    write_m1 = axi_transaction::type_id::create("write_m1");
    write_m1.addr = 32'h0003_0600;
    write_m1.data = 32'h87654321;
    write_m1.trans_type = WRITE;

    read_m0 = axi_transaction::type_id::create("read_m0");
    read_m0.addr = 32'h0000_0500;
    read_m0.trans_type = READ;

    read_m1 = axi_transaction::type_id::create("read_m1");
    read_m1.addr = 32'h0003_0600;
    read_m1.trans_type = READ;

    fork
      begin
        `uvm_info(get_type_name(), "Master 0: Starting WRITE", UVM_MEDIUM)
        start_item_on(write_m0, m0_seqr);
        finish_item_on(write_m0, m0_seqr);
      end
      begin
        `uvm_info(get_type_name(), "Master 1: Starting WRITE", UVM_MEDIUM)
        start_item_on(write_m1, m1_seqr);
        finish_item_on(write_m1, m1_seqr);
      end
    join

    fork
      begin
        `uvm_info(get_type_name(), "Master 0: Starting READ", UVM_MEDIUM)
        start_item_on(read_m0, m0_seqr);
        finish_item_on(read_m0, m0_seqr);
        `uvm_info(get_type_name(), $sformatf("Master 0 Read Data: 0x%08X", read_m0.data), UVM_LOW)
      end
      begin
        `uvm_info(get_type_name(), "Master 1: Starting READ", UVM_MEDIUM)
        start_item_on(read_m1, m1_seqr);
        finish_item_on(read_m1, m1_seqr);
        `uvm_info(get_type_name(), $sformatf("Master 1 Read Data: 0x%08X", read_m1.data), UVM_LOW)
      end
    join
  endtask
endclass
