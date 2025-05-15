class interleaved_write_test extends base_test;
  `uvm_component_utils(interleaved_write_test)

  function new(string name = "interleaved_write_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    interleaved_write_seq seq = interleaved_write_seq::type_id::create("seq");
    seq.m0_seqr = env.vseqr.master0_seqr;
    seq.m1_seqr = env.vseqr.master1_seqr;

    phase.raise_objection(this);
    seq.start(env.vseqr);
    phase.drop_objection(this);
  endtask
endclass
