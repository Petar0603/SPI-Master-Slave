class scoreboard;

	mailbox #(transaction) mon2sco, gen2sco;
	event scoreboard_done;

	transaction generator_data, monitor_data;
	int error_count = 0;

	function new(mailbox #(transaction) mon2sco, gen2sco, event scoreboard_done);
		this.mon2sco = mon2sco;
		this.gen2sco = gen2sco;
		this.scoreboard_done = scoreboard_done;
	endfunction

	function void compare();
		case(generator_data.req)
			2'b00: begin
				$display("[SCO] : NO COMPARISON! \t | \t TIME : %0t", $time);
			end
			2'b01: begin
				if(generator_data.din_master == monitor_data.dout_slave) begin
					$display("[SCO] : DATA MATCH AFTER TRANSMISSION! \t | \t TIME : %0t", $time);
				end
				else begin
					$display("[SCO] : DATA MISMATCH AFTER TRANSMISSION! \t | \t TIME : %0t", $time);
					error_count++;
				end
			end
			2'b10: begin
				if(generator_data.din_slave == monitor_data.dout_master) begin
					$display("[SCO] : DATA MATCH AFTER RECEPTION! \t | \t TIME : %0t", $time);
				end
				else begin
					$display("[SCO] : DATA MISMATCH AFTER RECEPTION! \t | \t TIME : %0t", $time);
					error_count++;
				end
			end
			2'b11: begin
				if((generator_data.din_master == monitor_data.dout_slave) && (generator_data.din_slave == monitor_data.dout_master)) begin
					$display("[SCO] : DATA MATCH AFTER FULL DUPLEX! \t | \t TIME : %0t", $time);
				end
				else begin
					$display("[SCO] : DATA MISMATCH AFTER FULL DUPLEX! \t | \t TIME : %0t", $time);
					error_count++;
				end
			end
		endcase
	endfunction

	task display_error_count;
		$display("[SCO] : CURRENT ERROR COUNT = %0d \t | \t TIME : %0t", error_count, $time);
		$display("-----------------------------------------------------");
	endtask

	task run;
		forever begin
			gen2sco.get(generator_data);
			mon2sco.get(monitor_data);
			compare();
			display_error_count();
			->scoreboard_done;
		end
	endtask
endclass