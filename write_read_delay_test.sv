class write_read_delay_test extends base_test;
  `uvm_component_utils(write_read_delay_test)

  function new(string name = "write_read_delay_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    write_read_delay_seq seq = write_read_delay_seq::type_id::create("seq");

    // Connect virtual sequencer
    seq.m0_seqr = env.vseqr.master0_seqr;

    phase.raise_objection(this);
    seq.start(env.vseqr);
    phase.drop_objection(this);
  endtask
endclass
