class generator;

	mailbox #(transaction) gen2drv;
	mailbox #(transaction) gen2sco;
	int count;
	transaction tr;
	event scoreboard_done, generator_done;

	function new(mailbox #(transaction) gen2drv, mailbox #(transaction) gen2sco, int count, event scoreboard_done, generator_done);
		this.gen2drv = gen2drv;
		this.gen2sco = gen2sco;
		this.count = count;
		this.scoreboard_done = scoreboard_done;
		this.generator_done = generator_done;
	endfunction

	function void display_op();
		case(tr.req)
			2'b00: begin
				$display("[GEN] : NO OPERATION! \t | \t TIME : %0t", $time);
			end
			2'b01: begin
				$display("[GEN] : TRANSMITTING DATA \t DIN_MASTER : %0b \t | \t TIME : %0t", tr.din_master, $time);
			end
			2'b10: begin
				$display("[GEN] : RECEIVING DATA \t DIN_SLAVE : %0b \t | \t TIME : %0t", tr.din_slave, $time);
			end
			2'b11: begin
				$display("[GEN] : FULL DUPLEX \t DIN_MASTER : %0b DIN_SLAVE : %0b \t | \t TIME : %0t", tr.din_master, tr.din_slave, $time);
			end
		endcase
	endfunction

	task run();
		tr = new();
		repeat(count) begin
			assert(tr.randomize) else begin
				$display("[GEN] : RANDOMIZATION FAILED! \t | \t TIME : %0t", $time);
			end
			display_op();
			gen2drv.put(tr.copy);
			gen2sco.put(tr.copy);
			@(scoreboard_done); // wait for the scoreboard to finish comparison of data
		end
		->generator_done;
	endtask
endclass