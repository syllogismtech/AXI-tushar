class back_to_back_rw_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(back_to_back_rw_seq)

  axi_master_sequencer m0_seqr;
  axi_master_sequencer m1_seqr;

  function new(string name = "back_to_back_rw_seq");
    super.new(name);
  endfunction

  task body();
    axi_transaction wr0, wr1, rd0, rd1;
    bit [31:0] base_addrs[4] = '{32'h0000_0100, 32'h0001_0200, 32'h0002_0300, 32'h0003_0400};
    bit [31:0] m0_data[4] = '{32'h11110000, 32'h22220000, 32'h33330000, 32'h44440000};
    bit [31:0] m1_data[4] = '{32'hAAAA0000, 32'hBBBB0000, 32'hCCCC0000, 32'hDDDD0000};

    foreach (base_addrs[i]) begin
      // Master 0 Write
      wr0 = axi_transaction::type_id::create($sformatf("m0_wr_%0d", i));
      wr0.addr = base_addrs[i];
      wr0.data = m0_data[i];
      wr0.trans_type = WRITE;

      // Master 1 Write
      wr1 = axi_transaction::type_id::create($sformatf("m1_wr_%0d", i));
      wr1.addr = base_addrs[i] + 4;
      wr1.data = m1_data[i];
      wr1.trans_type = WRITE;

      // Launch writes
      fork
        begin
          start_item_on(wr0, m0_seqr);
          finish_item_on(wr0, m0_seqr);
        end
        begin
          start_item_on(wr1, m1_seqr);
          finish_item_on(wr1, m1_seqr);
        end
      join

      // Master 0 Read
      rd0 = axi_transaction::type_id::create($sformatf("m0_rd_%0d", i));
      rd0.addr = base_addrs[i];
      rd0.trans_type = READ;

      // Master 1 Read
      rd1 = axi_transaction::type_id::create($sformatf("m1_rd_%0d", i));
      rd1.addr = base_addrs[i] + 4;
      rd1.trans_type = READ;

      // Launch reads
      fork
        begin
          start_item_on(rd0, m0_seqr);
          finish_item_on(rd0, m0_seqr);
          `uvm_info("B2B", $sformatf("M0 read from 0x%08X = 0x%08X", rd0.addr, rd0.data), UVM_LOW)
        end
        begin
          start_item_on(rd1, m1_seqr);
          finish_item_on(rd1, m1_seqr);
          `uvm_info("B2B", $sformatf("M1 read from 0x%08X = 0x%08X", rd1.addr, rd1.data), UVM_LOW)
        end
      join
    end
  endtask
endclass
