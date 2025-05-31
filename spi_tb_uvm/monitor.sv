class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)
	uvm_analysis_port #(transaction) port;
	virtual spi_if spi_if_i;
	transaction t, t_clone;
	uvm_event monitor_sample;

	function new(string path = "monitor", uvm_component parent = null);
		super.new(path, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		port = new("port", this);
		t = transaction::type_id::create("t");
		if(!uvm_config_db #(virtual spi_if)::get(this, "", "spi_if_i", spi_if_i)) begin
			`uvm_fatal(get_name(), "Couldn't connect the monitor to an interface!");
		end
	endfunction

	virtual task run_phase(uvm_phase phase);
		forever begin
			monitor_sample.wait_trigger();
			t.dout_master = spi_if_i.dout_master;
			t.dout_slave = spi_if_i.dout_slave;
			`uvm_info(get_name(), $sformatf("Sampled data. dout_master: %0b dout_slave: %0b", this.t.dout_master, this.t.dout_slave), UVM_NONE);
			$cast(t_clone, t.clone());
			port.write(t_clone);
		end
	endtask
endclass