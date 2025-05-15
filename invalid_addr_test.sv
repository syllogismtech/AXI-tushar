class invalid_addr_test extends base_test;
  `uvm_component_utils(invalid_addr_test)

  function new(string name = "invalid_addr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    invalid_addr_seq seq = invalid_addr_seq::type_id::create("seq");

    // Connect master0 sequencer
    seq.m0_seqr = env.vseqr.master0_seqr;

    phase.raise_objection(this);
    seq.start(env.vseqr);
    phase.drop_objection(this);
  endtask
endclass
