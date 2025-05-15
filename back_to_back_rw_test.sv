class back_to_back_rw_test extends base_test;
  `uvm_component_utils(back_to_back_rw_test)

  function new(string name = "back_to_back_rw_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    back_to_back_rw_seq seq = back_to_back_rw_seq::type_id::create("seq");
    seq.m0_seqr = env.vseqr.master0_seqr;
    seq.m1_seqr = env.vseqr.master1_seqr;

    phase.raise_objection(this);
    seq.start(env.vseqr);
    phase.drop_objection(this);
  endtask
endclass
