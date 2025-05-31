class driver;

	virtual spi_if drv_if;

	mailbox #(transaction) gen2drv;
	transaction tr;

	event monitor_sample;

	function new(mailbox #(transaction) gen2drv, event monitor_sample, virtual spi_if drv_if);
		this.gen2drv = gen2drv;
		this.drv_if = drv_if;
		this.monitor_sample = monitor_sample;
	endfunction

	task perform_operation();

		drv_if.req <= tr.req;
		drv_if.wait_duration <= tr.wait_duration;
		drv_if.din_master <= tr.din_master;
		drv_if.din_slave <= tr.din_slave;

		repeat(5) @(posedge drv_if.clk);
		drv_if.req <= 2'b00;

		case(tr.req)
			2'b00: begin
			end
			2'b01: begin
				wait(drv_if.done_tx == 1'b1);
			end
			2'b10: begin
				wait(drv_if.done_rx == 1'b1);
			end
			2'b11: begin
				wait(drv_if.done_rx == 1'b1);
			end
		endcase

		->monitor_sample;
		repeat(5) @(posedge drv_if.clk);

	endtask

	function void display_op();
		case(tr.req)
			2'b00: begin
				$display("[DRV] : NO PERFORMING OF OPERATION! \t | \t TIME : %0t", $time);
			end
			2'b01: begin
				$display("[DRV] : PERFORMING TRANSMISSION OF DATA \t DIN_MASTER : %0b \t | \t TIME : %0t", tr.din_master, $time);
			end
			2'b10: begin
				$display("[DRV] : PERFORMING RECEPTION OF DATA \t DIN_SLAVE : %0b \t | \t TIME : %0t", tr.din_slave, $time);
			end
			2'b11: begin
				$display("[DRV] : PERFORMING FULL DUPLEX \t DIN_MASTER : %0b DIN_SLAVE : %0b \t | \t TIME : %0t", tr.din_master, tr.din_slave, $time);
			end
		endcase
	endfunction

	task run();
		forever begin
			gen2drv.get(tr);
			display_op();
			perform_operation();
		end 
	endtask

endclass