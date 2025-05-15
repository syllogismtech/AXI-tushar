class slave_busy_test extends base_test;
  `uvm_component_utils(slave_busy_test)

  function new(string name = "slave_busy_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    slave_busy_seq seq = slave_busy_seq::type_id::create("seq");
    seq.m0_seqr = env.vseqr.master0_seqr;

    phase.raise_objection(this);
    seq.start(env.vseqr);
    phase.drop_objection(this);
  endtask
endclass
