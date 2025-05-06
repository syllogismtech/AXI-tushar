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
    int burst_len;
    bit [3:0] arid;
    @(posedge vif.clk);
    if (vif.arvalid && vif.arready) begin
      burst_len=vif.arlen+1+txn.extra_burst_len;
      arid=vif.arid;
      
      repeat (txn.delay_cycles) @(posedge vif.clk);

      for (int i = 0; i <= burst_len; i++) begin
        vif.rid    <=  arid;
        vif.rvalid <= 1;
        vif.rlast  <= (i == burst_len);
        case (txn.rdata_mode)
         0: vif.rdata <= vif.araddr+i;
         1: vif.rdata <= $urandom();
         2 : vif.rdata <= 64'hFFFF_FFFF_FFFF_FFFF;
        endcase
       // case (txn.arsize)
         // 3'd0: vif.rdata <= txn.rdata_array[i][7:0];
          //3'd1: vif.rdata <= txn.rdata_array[i][15:0];
          //3'd2: vif.rdata <= txn.rdata_array[i][31:0];
          //3'd3: vif.rdata <= txn.rdata_array[i][63:0];
          //default: vif.rdata <= 64'hDEADBEEF_DEADBEEF;
        //endcase

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
