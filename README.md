# SPI-Master-Slave
SPI module designed in Verilog and verified in SystemVerilog and UVM.
---
## About
'Req' signal in 'spi_master' module is used to select one of the following modes:
- 00 -> No Operation,
- 01 -> Transmission (Master -> Slave),
- 10 -> Reception (Slave -> Master),
- 11 -> Full duplex (Master -> Slave & Slave -> Master).
'Wait_duration' is a register where 8 bit value is stored, this value is used to determine
a delay when CS is pulled low to when data transmission starts in 'spi_master' module.
Master frequency and slave frequency can be modified in 'spi_top', in this module 'spi_master'
and 'spi_slave' are connected with 'sclk_generator'.
---
## SPI General Info
SPI (Serial Peripheral Interface) is a high-speed, full-duplex, synchronous serial communication protocol
used to connect microcontrollers with peripheral devices like sensors, displays, and memory. It uses four 
main lines: MOSI (Master Out Slave In), MISO (Master In Slave Out), SCLK (Serial Clock), and CS/SS 
(Chip Select/Slave Select). SPI is fast and simple, but requires more wires compared to protocols like I²C.
## Simulation Screenshots
- SystemVerilog Simulation
<div align="center"> <img src="/spi_simulation_results/sv_tb_results/vivado_waveforms.png"> </div>
- UVM Simulation
<div align="center"> <img src="/spi_simulation_results/uvm_tb_results/uvm_eda_waveforms.png"> </div> 
