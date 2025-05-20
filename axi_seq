class axi_seq extends uvm_sequence #(axi_seq_item);

  `uvm_object_utils(axi_seq)

  const int clearmemory = 0;
  const int window_size = 'h1_0000;

  int xfers_to_send = 1;
  int xfers_done = 0;

  bit valid[];
  bit [2:0] max_burst_size;

  memory m_memory;

  extern function new(string name = "axi_seq");
  extern task body;
  extern function void set_transaction_count(int count);
  extern function bit compare_items(ref axi_seq_item write_item, ref axi_seq_item read_item);

endclass : axi_seq

function axi_seq::new(string name = "axi_seq");
  int dwidth;
  super.new(name);

  `uvm_info(this.get_type_name(), "Looking for AXI_DATA_WIDTH in uvm_config_db", UVM_MEDIUM)

  if (!uvm_config_db#(int)::get(null, "", "AXI_DATA_WIDTH", dwidth)) begin
    `uvm_fatal(this.get_type_name(), "Unable to fetch AXI_DATA_WIDTH from config db.")
  end

  max_burst_size = $clog2(dwidth / 8);
endfunction : new

function void axi_seq::set_transaction_count(int count);
  `uvm_info(this.get_type_name(), $sformatf("set_transaction_count(%0d)", count), UVM_INFO)
  xfers_to_send = count;
endfunction : set_transaction_count

task axi_seq::body;
endtask : body

function bit axi_seq::compare_items(ref axi_seq_item write_item, ref axi_seq_item read_item);

  int miscompare_cntr = 0;

  if (write_item.burst_type == e_FIXED) begin
    int burst_size = 2 ** write_item.burst_size;
    bit [7:0] localbuffer[burst_size];

    foreach (write_item.data[i])
      localbuffer[i % burst_size] = write_item.data[i];

    foreach (read_item.data[i]) begin
      if (read_item.data[i] != localbuffer[i % burst_size]) begin
        miscompare_cntr++;
      end
    end

    if (miscompare_cntr > 0) begin
      `uvm_error("AXI READBACK e_FIXED", $sformatf("%0d mismatches in readback with FIXED burst.", miscompare_cntr));
    end

  end else if (write_item.burst_type inside {e_INCR, e_WRAP}) begin
    foreach (write_item.data[i]) begin
      if (read_item.data[i] != write_item.data[i]) begin
        miscompare_cntr++;
        `uvm_error("AXI READBACK", $sformatf("Mismatch at index %0d: expected 0x%02x, got 0x%02x", i, write_item.data[i], read_item.data[i]));
      end
    end

  end else begin
    `uvm_error("AXI READBACK", $sformatf("Unsupported burst type: %0d", write_item.burst_type));
    miscompare_cntr++;
  end

  return (miscompare_cntr == 0);

endfunction : compare_items
