class cross_master_rw_test extends base_test;
  `uvm_component_utils(cross_master_rw_test)

  function new(string name = "cross_master_rw_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    cross_master_rw_seq seq = cross_master_rw_seq::type_id::create("seq");

    // Pass sequencers from env to the sequence
    seq.m0_seqr = env.vseqr.master0_seqr;
    seq.m1_seqr = env.vseqr.master1_seqr;

    phase.raise_objection(this);
    seq.start(env.vseqr);
    phase.drop_objection(this);
  endtask
endclass
