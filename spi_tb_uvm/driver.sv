class driver extends uvm_driver #(transaction);
	`uvm_component_utils(driver);
	transaction t, t_clone;
	virtual spi_if spi_if_i;
	uvm_blocking_put_port #(transaction) port; // sends data to scoreboard via TLM
	uvm_event monitor_sample;

	function new(string path = "driver", uvm_component parent = null);
		super.new(path, parent);
	endfunction

	function void display_op();
		case(t.req)
			2'b00: begin
				`uvm_info(get_name(), "No performing of operation.", UVM_NONE);
			end
			2'b01: begin
				`uvm_info(get_name(), $sformatf("Performing transmission of data. din_master: %0b", this.t.din_master), UVM_NONE);
			end
			2'b10: begin
				`uvm_info(get_name(), $sformatf("Performing reception of data. din_slave: %0b", this.t.din_slave), UVM_NONE);
			end
			2'b11: begin
				`uvm_info(get_name(), $sformatf("Performing full duplex. din_master: %0b din_slave: %0b", this.t.din_master, this.t.din_slave), UVM_NONE);
			end
		endcase
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		port = new("port", this);
		if(!uvm_config_db #(virtual spi_if)::get(this, "", "spi_if_i", spi_if_i)) begin
			`uvm_fatal(get_name(), "Couldn't connect the driver to an interface!");
		end
	endfunction

	virtual task reset_phase(uvm_phase phase);
		phase.raise_objection(this);
		spi_if_i.req <= 2'b00;
		spi_if_i.wait_duration <= 8'd0;
		spi_if_i.din_master <= 12'd0;
		spi_if_i.din_slave <= 12'd0;
		spi_if_i.rst <= 1'b1;
		#(`RST_DURATION);
		spi_if_i.rst <= 1'b0;
		`uvm_info(get_name(), "Reset done.", UVM_NONE);
		phase.drop_objection(this);
	endtask

	task perform_operation();

		spi_if_i.req <= t.req;
		spi_if_i.wait_duration <= t.wait_duration;
		spi_if_i.din_master <= t.din_master;
		spi_if_i.din_slave <= t.din_slave;

		repeat(5) @(posedge spi_if_i.clk);
		spi_if_i.req <= 2'b00;

		case(t.req)
			2'b00: begin
			end
			2'b01: begin
				wait(spi_if_i.done_tx == 1'b1);
			end
			2'b10: begin
				wait(spi_if_i.done_rx == 1'b1);
			end
			2'b11: begin
				wait(spi_if_i.done_rx == 1'b1);
			end
		endcase

		monitor_sample.trigger();
		repeat(5) @(posedge spi_if_i.clk);

	endtask

	virtual task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(t);
			$cast(t_clone, t.clone());
			port.put(t_clone);
			display_op();
			perform_operation();
			seq_item_port.item_done();
		end
	endtask
endclass