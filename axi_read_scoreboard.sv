class axi_read_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(axi_read_scoreboard)

  uvm_analysis_imp#(axi_read_master_transaction, axi_read_scoreboard) m_scb;
  uvm_analysis_imp#(axi_read_slave_transaction,  axi_read_scoreboard) s_scb;

  axi_read_master_transaction master_q[$];
  axi_read_slave_transaction  slave_q[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    m_scb = new("m_scb", this);
    s_scb = new("s_scb", this);
  endfunction

  function void write(axi_read_master_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received Master AR txn: arid=%0h araddr=0x%0h arlen=%0d",
                  t.arid, t.araddr, t.arlen), UVM_HIGH)
    master_q.push_back(t);
  endfunction

  function void write(axi_read_slave_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received Slave R txn: rid=%0h rdata=0x%0h rlast=%0b",
                  t.rid, t.rdata, t.rlast), UVM_HIGH)
    slave_q.push_back(t);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    axi_read_master_transaction master_txn;
    axi_read_slave_transaction  slave_txn;

    forever begin
      wait (master_q.size() > 0 && slave_q.size() >= (master_q[0].arlen + 1));

      master_txn = master_q.pop_front();
      int burst_len = master_txn.arlen + 1;

      for (int i = 0; i < burst_len; i++) begin
        wait (slave_q.size() > 0);
        slave_txn = slave_q.pop_front();

        if (slave_txn.rid !== master_txn.arid) begin
          `uvm_error("SCOREBOARD", $sformatf("ID mismatch at beat %0d: Expected ID = %0h, Got = %0h",
                      i, master_txn.arid, slave_txn.rid))
        end

        bit [63:0] expected_rdata = master_txn.araddr + i;

        if (slave_txn.rdata !== expected_rdata) begin
          `uvm_error("SCOREBOARD", $sformatf("Data mismatch at beat %0d: Expected = 0x%0h, Got = 0x%0h",
                      i, expected_rdata, slave_txn.rdata))
        end else begin
          `uvm_info("SCOREBOARD", $sformatf("Data match at beat %0d: 0x%0h", i, slave_txn.rdata), UVM_LOW)
        end

        if (i == burst_len - 1 && !slave_txn.rlast) begin
          `uvm_error("SCOREBOARD", "Expected RLAST=1 at last beat but got 0")
        end
      end
    end
  endtask

endclass
