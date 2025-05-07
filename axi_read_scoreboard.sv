class axi_read_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi_read_scoreboard)

  uvm_analysis_imp #(axi_read_addr_txn, axi_read_scoreboard) ar_imp;
  uvm_analysis_imp #(axi_read_data_txn, axi_read_scoreboard) r_imp;

  axi_read_addr_txn  ar_queue [$];
  axi_read_data_txn  r_queue [$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ar_imp = new("ar_imp", this);
    r_imp  = new("r_imp", this);
  endfunction

  virtual function void write(axi_read_addr_txn t);
    ar_queue.push_back(t);
    `uvm_info(get_type_name(), $sformatf("Stored AR txn: %s", t.convert2string()), UVM_MEDIUM)
  endfunction

  virtual function void write(axi_read_data_txn t);
    r_queue.push_back(t);
    compare_ar_r();
  endfunction

  function void compare_ar_r();
    if (ar_queue.empty() || r_queue.empty())
      return;

    axi_read_addr_txn ar = ar_queue.pop_front();
    axi_read_data_txn r  = r_queue.pop_front();

    int expected_beats = ar.len + 1;
    int actual_beats   = r.data_queue.size();

    if (expected_beats != actual_beats) begin
      `uvm_error("SCOREBOARD", $sformatf("Burst mismatch: ID=%0h, Expected=%0d, Got=%0d",
                                         ar.id, expected_beats, actual_beats))
      return;
    end

    `uvm_info("SCOREBOARD", $sformatf("Burst match: ID=%0h, Beats=%0d",
                                      ar.id, actual_beats), UVM_LOW)

    foreach (r.data_queue[i]) begin
      bit [63:0] expected_data = ar.addr + i;
      bit [63:0] actual_data   = r.data_queue[i];

      if (actual_data !== expected_data) begin
        `uvm_warning("SCOREBOARD", $sformatf("Data mismatch at beat %0d: Expected=0x%0h, Got=0x%0h",
                                             i, expected_data, actual_data))
        break;
      end
    end
  endfunction

endclass
