class axi_read_slave_driver extends uvm_driver #(axi_read_data_resp_txn);
  virtual read_interface vif;
  `uvm_component_utils(axi_read_slave_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db #(virtual read_interface)::get(this, "", "vif", vif))
      `uvm_fatal("SLV_DRV", "Interface not found")
  endfunction

task run_phase(uvm_phase phase);
  forever begin
    axi_read_data_resp_txn txn;
    seq_item_port.get_next_item(txn); 

    @(posedge vif.clk);
    if (vif.arvalid && vif.arready) begin
      
      txn.set_dut_arinfo(vif.arid, vif.araddr, vif.arlen);

      repeat (txn.delay_cycles) @(posedge vif.clk);
      for (int i = 0; i <= txn.get_burst_len(); i++) begin
        vif.rid    <= txn.arid;
        vif.rvalid <= 1;
        vif.rlast  <= (i == txn.get_burst_len());
        vif.rdata  <= txn.compute_rdata(i);

        @(posedge vif.clk);
        while (!vif.rready) @(posedge vif.clk);

        vif.rvalid <= 0;
        vif.rlast  <= 0;
      end
    end

    seq_item_port.item_done();  
  end
endtask



endclass
