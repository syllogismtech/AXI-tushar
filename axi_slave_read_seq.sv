class axi_read_seq_all_delays extends uvm_sequence #(axi_read_data_resp_txn);
  `uvm_object_utils(axi_read_seq_all_delays)

  axi_read_data_resp_txn txn;
  longint loop_count = 10;

  function new(string name = "axi_read_seq_all_delays");
    super.new(name);
  endfunction

  task body();
    repeat (loop_count) begin
      txn = axi_read_data_resp_txn::type_id::create("txn");
      start_item(txn);
      assert(txn.randomize());
      finish_item(txn);

      case (txn.delay_type)
        0: #(0);
        1: #( $urandom_range(1, 14) );
        2: #(15);
      endcase

      case (txn.data_case)
        0: txn.rdata = txn.addr;
        1: txn.rdata = ~txn.addr;
        2: txn.rdata = 32'hF;
      endcase

      `uvm_info("SEQ", $sformatf("addr=%h delay_type=%0d data_case=%0d rdata=%h",
                   txn.addr, txn.delay_type, txn.data_case, txn.rdata), UVM_MEDIUM)
    end
  endtask
endclass
