class axi_read_monitor extends uvm_monitor;

  `uvm_component_utils(axi_read_monitor)

  virtual axi_if vif;

  uvm_analysis_port #(axi_read_addr_txn) ar_port;
  uvm_analysis_port #(axi_read_data_txn) r_port;

  typedef struct {
    int expected_beats;
    bit [63:0] base_addr;
  } ar_info_t;
  ar_info_t arlen_map [bit [3:0]];

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

        arlen_map[vif.arid] = '{expected_beats: vif.arlen + 1, base_addr: vif.araddr};

        ar_port.write(ar_txn);
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

          int actual_beats = r_txn.data_queue.size();
          if (arlen_map.exists(r_txn.id)) begin
            int expected_beats = arlen_map[r_txn.id].expected_beats;

            if (actual_beats != expected_beats) begin
              `uvm_error(get_type_name(),
                $sformatf("Burst length mismatch for ID %0h: Expected %0d beats, got %0d",
                          r_txn.id, expected_beats, actual_beats))
            end else begin
              `uvm_info(get_type_name(),
                $sformatf("Burst length matched for ID %0h: %0d beats", r_txn.id, actual_beats), UVM_LOW)
            end

            arlen_map.delete(r_txn.id);
          end else begin
            `uvm_warning(get_type_name(),
              $sformatf("R txn received for unknown ARID %0h", r_txn.id))
          end

          r_txn = null;
        end
      end
    end
  endtask

endclass
