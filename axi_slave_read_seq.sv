class adder_seq_delay0 extends uvm_sequence #(adder_sequence_item);
  `uvm_object_utils(adder_seq_delay0)

  adder_sequence_item txn;
  longint loop_count = 10;

  function new(string name = "adder_seq_delay0");
    super.new(name);
  endfunction

  task body();
    repeat (loop_count) begin
      txn = adder_sequence_item::type_id::create("txn");
      start_item(txn);
      assert(txn.randomize() with { delay_type == 0; });
      finish_item(txn);
    end
  endtask
endclass

class adder_seq_random_delay extends uvm_sequence #(adder_sequence_item);
  `uvm_object_utils(adder_seq_random_delay)

  adder_sequence_item txn;
  longint loop_count = 10;

  function new(string name = "adder_seq_random_delay");
    super.new(name);
  endfunction

  task body();
    repeat (loop_count) begin
      txn = adder_sequence_item::type_id::create("txn");
      start_item(txn);
      assert(txn.randomize() with { delay_type == 1; });
      finish_item(txn);
    end
  endtask
endclass

class adder_seq_delay15 extends uvm_sequence #(adder_sequence_item);
  `uvm_object_utils(adder_seq_delay15)

  adder_sequence_item txn;
  longint loop_count = 10;

  function new(string name = "adder_seq_delay15");
    super.new(name);
  endfunction

  task body();
    repeat (loop_count) begin
      txn = adder_sequence_item::type_id::create("txn");
      start_item(txn);
      assert(txn.randomize() with { delay_type == 2; });
      finish_item(txn);
    end
  endtask
endclass



