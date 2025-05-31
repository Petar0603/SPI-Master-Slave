class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)
	uvm_analysis_imp #(transaction, scoreboard) monitor_imp;
	uvm_blocking_put_imp #(transaction, scoreboard) driver_imp;
	transaction monitor_data, driver_data;

	function new(string path = "scoreboard", uvm_component parent = null);
		super.new(path, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		monitor_imp = new("monitor_imp", this);
		driver_imp = new("driver_imp", this);
		monitor_data = transaction::type_id::create("monitor_data");
		driver_data = transaction::type_id::create("driver_data");
	endfunction

	function void compare();
		case(driver_data.req)
			2'b00: begin
				`uvm_info(get_name(), "No comparison!", UVM_NONE);
			end
			2'b01: begin
				if(driver_data.din_master == monitor_data.dout_slave) begin
					`uvm_info(get_name(), "Data match after transmission!", UVM_NONE);
				end
				else begin
					`uvm_error(get_name(), "Data mismatch after transmission!");
				end
			end
			2'b10: begin
				if(driver_data.din_slave == monitor_data.dout_master) begin
					`uvm_info(get_name(), "Data match after reception!", UVM_NONE);
				end
				else begin
					`uvm_error(get_name(), "Data mismatch after reception!");
				end
			end
			2'b11: begin
				if((driver_data.din_master == monitor_data.dout_slave) && (driver_data.din_slave == monitor_data.dout_master)) begin
					`uvm_info(get_name(), "Data match after full duplex!", UVM_NONE);
				end
				else begin
					`uvm_error(get_name(), "Data mismatch after full duplex!");
				end
			end
		endcase
	endfunction

	virtual function void write(transaction monitor_data);
		this.monitor_data = monitor_data;
		compare();
		`uvm_info(get_name(), $sformatf("Data received from monitor. dout_master = %0b dout_slave = %0b.", this.monitor_data.dout_master, this.monitor_data.dout_slave), UVM_DEBUG);
	endfunction

	virtual function void put(transaction driver_data);
		this.driver_data = driver_data;
		`uvm_info(get_name(), $sformatf("Data received from driver: din_master = %0b din_slave = %0b.", this.monitor_data.din_master, this.monitor_data.din_slave), UVM_DEBUG);
	endfunction

endclass