class axi_read_monitor extends uvm_monitor;

  virtual axi_if vif;

  uvm_analysis_port #(axi_read_addr_txn) ar_port;
  uvm_analysis_port #(axi_read_data_txn) r_port;

  event ar_event;
  event r_event;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ar_port = new("ar_port", this);
    r_port  = new("r_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Virtual interface not set for axi_read_monitor")
  endfunction

  virtual task run_phase(uvm_phase phase);
    fork
      monitor_ar_channel();
      monitor_r_channel();
    join_none
  endtask

  task monitor_ar_channel();
    axi_read_addr_txn ar_txn;
    forever begin
      @(posedge vif.aclk);
      if (vif.arvalid && vif.arready) begin
        ar_txn = new();
        ar_txn.addr   = vif.araddr;
        ar_txn.burst  = vif.arburst;
        ar_txn.len    = vif.arlen;
        ar_txn.size   = vif.arsize;
        ar_txn.id     = vif.arid;
        ar_port.write(ar_txn);
        -> ar_event;
        `uvm_info(get_type_name(), $sformatf("Captured AR txn: %s", ar_txn.convert2string()), UVM_LOW)
      end
    end
  endtask

  task monitor_r_channel();
    axi_read_data_txn r_txn;
    forever begin
      @(posedge vif.aclk);
      if (vif.rvalid && vif.rready) begin
        if (r_txn == null) begin
          r_txn = new();
          r_txn.id = vif.rid;
        end
        r_txn.data_queue.push_back(vif.rdata);
        r_txn.resp_queue.push_back(vif.rresp);
        if (vif.rlast) begin
          r_port.write(r_txn);
          -> r_event;
          `uvm_info(get_type_name(), $sformatf("Captured R txn: %s", r_txn.convert2string()), UVM_LOW)
          r_txn = null;
        end
      end
    end
  endtask

endclass
