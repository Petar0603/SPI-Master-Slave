class transaction extends uvm_sequence_item;

	randc bit[1:0] req; // cyclic randomization!
	bit[7:0] wait_duration = `WAIT_DURATION;
	randc bit[11:0] din_master;
	randc bit[11:0] din_slave;

	bit[11:0] dout_master;
	bit[11:0] dout_slave;
	bit done_tx;
	bit done_rx;

	function new(string path = "transaction");
		super.new(path);
	endfunction

	`uvm_object_utils_begin(transaction) // registering to a factory (for clone method)
		`uvm_field_int(req, UVM_DEFAULT)
		`uvm_field_int(wait_duration, UVM_DEFAULT)
		`uvm_field_int(din_master, UVM_DEFAULT)
		`uvm_field_int(din_slave, UVM_DEFAULT)
		`uvm_field_int(dout_master, UVM_DEFAULT)
		`uvm_field_int(dout_slave, UVM_DEFAULT)
		`uvm_field_int(done_tx, UVM_DEFAULT)
		`uvm_field_int(done_rx, UVM_DEFAULT)
	`uvm_object_utils_end

endclass