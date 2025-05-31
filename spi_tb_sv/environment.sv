class environment;

	generator gen;
	driver drv;
	monitor mon;
	scoreboard sco;

	mailbox #(transaction) gen2drv;
	mailbox #(transaction) mon2sco, gen2sco;

	event scoreboard_done, generator_done, monitor_sample;

	function new(input int count, virtual spi_if env_if);

		gen2drv = new();
		gen2sco = new();
		mon2sco = new();

		gen = new(gen2drv, gen2sco, count, scoreboard_done, generator_done);
		drv = new(gen2drv, monitor_sample, env_if);
		mon = new(mon2sco, monitor_sample, env_if);
		sco = new(mon2sco, gen2sco, scoreboard_done);

	endfunction

	task test;
		fork
			gen.run();
			drv.run();
			mon.run();
			sco.run();
		join_none
	endtask

	task post_test;
		@(generator_done);
		$finish;
	endtask

	task run;
		test();
		post_test();
	endtask

endclass