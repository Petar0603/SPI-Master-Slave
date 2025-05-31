interface spi_if();

	logic clk;
	logic rst;
	logic[1:0] req;
	logic[7:0] wait_duration;
	logic[11:0] din_master;
	logic[11:0] din_slave;
	logic[11:0] dout_master;
	logic[11:0] dout_slave;
	logic done_tx;
	logic done_rx;

endinterface