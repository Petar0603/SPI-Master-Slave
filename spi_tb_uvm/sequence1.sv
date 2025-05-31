class sequence1 extends uvm_sequence #(transaction);
	`uvm_object_utils(sequence1)
	transaction t;
	int count = 0; // only tracks the current no. of iteration

	function new(string path = "sequence1");
		super.new(path);
	endfunction

	function void display_op();
		case(t.req)
			2'b00: begin
				`uvm_info(get_name(), "No operation.", UVM_NONE);
			end
			2'b01: begin
				`uvm_info(get_name(), $sformatf("Transmitting data. din_master: %0b", this.t.din_master), UVM_NONE);
			end
			2'b10: begin
				`uvm_info(get_name(), $sformatf("Receiving data. din_slave: %0b", this.t.din_slave), UVM_NONE);
			end
			2'b11: begin
				`uvm_info(get_name(), $sformatf("Full duplex. din_master: %0b din_slave: %0b", this.t.din_master, this.t.din_slave), UVM_NONE);
			end
		endcase
	endfunction

	virtual task body();
		#(`RST_DURATION); // wait for reset_phase of driver to finish
		t = transaction::type_id::create("t");
		repeat(`NUM_ITERATIONS) begin
			start_item(t);
			if (!t.randomize()) begin
				`uvm_error(get_name(), "Randomization failed!");
			end
			`uvm_info(get_name(), $sformatf("Iteration no. %0d ", count), UVM_NONE);
			display_op();
			count++;
			finish_item(t);
		end
	endtask
endclass