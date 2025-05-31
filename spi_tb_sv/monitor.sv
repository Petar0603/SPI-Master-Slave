class monitor;

	virtual spi_if mon_if;

	mailbox #(transaction) mon2sco;
	transaction tr;

	event monitor_sample;

	function new(mailbox #(transaction) mon2sco, event monitor_sample, virtual spi_if mon_if);
		this.mon2sco = mon2sco;
		this.mon_if = mon_if;
		this.monitor_sample = monitor_sample;
	endfunction

	task run();
		tr = new();
		forever begin
			@(monitor_sample);
			tr.dout_master = mon_if.dout_master;
			tr.dout_slave = mon_if.dout_slave;
			$display("[MON] : SAMPLED DATA: \t DOUT_MASTER : %0b DOUT_SLAVE : %0b \t | \t TIME : %0t", tr.dout_master, tr.dout_slave, $time);
			mon2sco.put(tr.copy());
		end
	endtask

endclass