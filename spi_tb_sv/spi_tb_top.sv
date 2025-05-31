`include "spi_if.sv"
`include "spi_pkg.sv"

`timescale 1ns / 1ps

`define MASTER_FREQ 100_000_000
`define SLAVE_FREQ 1_800_000

import spi_pkg::*;

module spi_tb_top;

	int spi_iterations = 10; // forwarded to environment then to generator, how many times to generate an iteration of signals

	spi_if tb_if();

	environment env;

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

	task pre_test;
		tb_if.rst <= 1;
		repeat(5) @(posedge tb_if.clk);
		tb_if.rst <= 0;
		@(posedge tb_if.clk);
	endtask

	initial begin
		tb_if.clk <= 0;
	end
	always #5 tb_if.clk = ~tb_if.clk;

	initial begin
		env = new(spi_iterations, tb_if);
	end

	initial begin
		pre_test();
		env.run();
	end

endmodule