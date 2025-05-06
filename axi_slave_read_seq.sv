class axi_slave_read_seq extends uvm_sequence #(axi_read_data_txn);
  `uvm_object_utils(axi_slave_read_seq)

  function new(string name = "axi_slave_read_seq");
    super.new(name);
  endfunction

  task body();
    axi_read_data_txn txn;
    txn = axi_read_data_txn::type_id::create("txn");

    int burst_len = 15;            

  //bit [63:0] base_value = 64'h1000_0000_0000_0000;
  //txn.rdata_array = new[txn.burst_len + 1];
  //foreach (txn.rdata_array[i])
  //txn.rdata_array[i] = base_value + i;

    start_item(txn);
    finish_item(txn);
  endtask
endclass:axi_slave_read_seq

class adder_seq_delay0 extends uvm_sequence #(adder_sequence_item);
  `uvm_object_utils(adder_seq_delay0)

  function new(string name = "adder_seq_delay0");
    super.new(name);
  endfunction

  task body();
    repeat (10) begin
      adder_sequence_item req = adder_sequence_item::type_id::create("req");
      start_item(req);
      void'(req.randomize() with { delay_type == 0; });
      req.do_randomize_delay();
      finish_item(req);
    end
  endtask
endclass

class adder_seq_random_delay extends uvm_sequence #(adder_sequence_item);
  `uvm_object_utils(adder_seq_random_delay)

  function new(string name = "adder_seq_random_delay");
    super.new(name);
  endfunction

  task body();
    repeat (10) begin
      adder_sequence_item req = adder_sequence_item::type_id::create("req");
      start_item(req);
      void'(req.randomize() with { delay_type == RANDOM_DELAY; });
      req.do_randomize_delay();
      finish_item(req);
    end
  endtask
endclass

class adder_seq_delay15 extends uvm_sequence #(adder_sequence_item);
  `uvm_object_utils(adder_seq_delay15)

  function new(string name = "adder_seq_delay15");
    super.new(name);
  endfunction

  task body();
    repeat (10) begin
      adder_sequence_item req = adder_sequence_item::type_id::create("req");
      start_item(req);
      void'(req.randomize() with { delay_type == 15; });
      req.do_randomize_delay();
      finish_item(req);
    end
  endtask
endclass


