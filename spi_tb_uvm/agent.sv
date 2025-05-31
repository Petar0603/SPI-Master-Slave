class agent extends uvm_agent;
	`uvm_component_utils(agent)
	uvm_sequencer #(transaction) seq;
	monitor mon;
	driver drv;
	uvm_event monitor_sample;

	function new(string path = "agent", uvm_component parent = null);
		super.new(path, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon = monitor::type_id::create("mon", this);
		drv = driver::type_id::create("drv", this);
		seq = uvm_sequencer #(transaction)::type_id::create("seq", this);
		monitor_sample = new("monitor_sample");
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(seq.seq_item_export);
		drv.monitor_sample = monitor_sample;
		mon.monitor_sample = monitor_sample;
	endfunction
endclass