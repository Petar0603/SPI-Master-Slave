`include "spi_if.sv"

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "spi_pkg.sv"
import spi_pkg::*;

`timescale 1ns/1ps

// in the spi_pkg user can change macro values for:
// number of iterations, master frequency, slave frequency, maximum error count, reset duration
// and wait state duration (check spi_top for clarification!)

module spi_tb_top();

	spi_if tb_if();
	spi_top #(
		.MASTER_FREQ(`MASTER_FREQ),
		.SLAVE_FREQ(`SLAVE_FREQ)
	) dut(
		.clk(tb_if.clk),
		.rst(tb_if.rst),
		.req(tb_if.req),
		.wait_duration(tb_if.wait_duration),
		.din_master(tb_if.din_master),
		.din_slave(tb_if.din_slave),
		.dout_master(tb_if.dout_master),
		.dout_slave(tb_if.dout_slave),
		.done_tx(tb_if.done_tx),
		.done_rx(tb_if.done_rx)
    );

	initial begin
		tb_if.clk <= 1'b0;
	end
	always #5 tb_if.clk <= ~tb_if.clk;

	initial begin
		uvm_top.set_report_verbosity_level(UVM_MEDIUM);
		uvm_top.set_report_max_quit_count(`MAX_ERROR_COUNT);
		uvm_config_db #(virtual spi_if)::set(null, "uvm_test_top.env.agn*", "spi_if_i", tb_if);
		run_test("test");
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end

endmodule