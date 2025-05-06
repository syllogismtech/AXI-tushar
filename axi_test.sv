class axi_test extends uvm_test;

    uvm_component_utils(axi_test)
    
    function new(string name = "", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    axi_env env_h;
    int file_h;

    axi_read_seq_delay0 seq_delay0;
    axi_read_seq_random_delay seq_rand_delay;
    axi_read_seq_delay15 seq_delay15;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = adder_env::type_id::create("env_h", this);

        seq_delay0 = axi_read_seq_delay0::type_id::create("seq_delay0");
        seq_rand_delay = axi_read_seq_random_delay::type_id::create("seq_rand_delay");
        seq_delay15 = axi_read_seq_delay15::type_id::create("seq_delay15");
    endfunction
    
    function void end_of_elaboration_phase(uvm_phase phase);
        $display("End of elaboration phase in agent");
    endfunction
    
    function void start_of_simulation_phase(uvm_phase phase);
        $display("start_of_simulation_phase");
        file_h = $fopen("LOG_FILE.log", "w");
        set_report_default_file_hier(file_h);
        set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY + UVM_LOG);
        env_h.set_report_verbosity_level_hier(UVM_MEDIUM);
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        seq_delay0.start(env_h.agent_h.sequencer_h);
        seq_rand_delay.start(env_h.agent_h.sequencer_h);
        seq_delay15.start(env_h.agent_h.sequencer_h);

        #10;
        phase.drop_objection(this);
    endtask
endclass: axi_test
