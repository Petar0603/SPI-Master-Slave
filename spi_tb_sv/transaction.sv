`define WAIT_DURATION 10

class transaction;

	randc bit[1:0] req; // cyclic randomization!
	bit[7:0] wait_duration = `WAIT_DURATION;
	randc bit[11:0] din_master;
	randc bit[11:0] din_slave;

	bit[11:0] dout_master;
	bit[11:0] dout_slave;
	bit done_tx;
	bit done_rx;

	function transaction copy(); // deep copy of the transaction
		copy = new();
		copy.req = this.req;
		copy.wait_duration = this.wait_duration;
		copy.din_master = this.din_master;
		copy.din_slave = this.din_slave;
		copy.dout_master = this.dout_master;
		copy.dout_slave = this.dout_slave;
		copy.done_tx = this.done_tx;
		copy.done_rx = this.done_rx;
	endfunction

endclass