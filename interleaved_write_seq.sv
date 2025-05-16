class interleaved_write_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(interleaved_write_seq)

  axi_master_sequencer m0_seqr;
  axi_master_sequencer m1_seqr;

  function new(string name = "interleaved_write_seq");
    super.new(name);
  endfunction

  task body();
    axi_transaction m0_write, m1_write;
    axi_transaction m0_read, m1_read;

    m0_write = axi_transaction::type_id::create("m0_write");
    m0_write.addr = 32'h0002_0700;
    m0_write.data = 32'hAAAA0001;
    m0_write.trans_type = WRITE;

    m1_write = axi_transaction::type_id::create("m1_write");
    m1_write.addr = 32'h0002_0704;
    m1_write.data = 32'hBBBB0002;
    m1_write.trans_type = WRITE;

    fork
      begin
        start_item_on(m0_write, m0_seqr);
        finish_item_on(m0_write, m0_seqr);
      end
      begin
        start_item_on(m1_write, m1_seqr);
        finish_item_on(m1_write, m1_seqr);
      end
    join

    m0_read = axi_transaction::type_id::create("m0_read");
    m0_read.addr = 32'h0002_0700;
    m0_read.trans_type = READ;

    m1_read = axi_transaction::type_id::create("m1_read");
    m1_read.addr = 32'h0002_0704;
    m1_read.trans_type = READ;

    fork
      begin
        start_item_on(m0_read, m0_seqr);
        finish_item_on(m0_read, m0_seqr);
        `uvm_info(get_type_name(), $sformatf("Master 0 read: 0x%08X", m0_read.data), UVM_LOW)
      end
      begin
        start_item_on(m1_read, m1_seqr);
        finish_item_on(m1_read, m1_seqr);
        `uvm_info(get_type_name(), $sformatf("Master 1 read: 0x%08X", m1_read.data), UVM_LOW)
      end
    join
  endtask
endclass
