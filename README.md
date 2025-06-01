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
a delay when CS is pulled low to when data transmission starts and for how long to keep it 
low after the transmission has finished in 'spi_master' module.

Master frequency and slave frequency can be modified in 'spi_top', in this module 'spi_master'
and 'spi_slave' are connected with 'sclk_generator'.

Testbench files are in 'spi_tb_sv' and 'spi_tb_uvm' folders. (Both include 'spi_pkg' packages
with all of the classes included: driver, monitor, scoreboard etc.)

---
## Schematic
<div align="center"> <img src="/spi_design/schematic.png"> </div>

---
## Simulation Screenshots
SystemVerilog Simulation
<div align="center"> <img src="/spi_simulation_results/sv_tb_results/vivado_waveforms.png"> </div>

UVM Simulation
<div align="center"> <img src="/spi_simulation_results/uvm_tb_results/uvm_eda_waveforms.png"> </div> 

---
## Console Info
- Console outputs from Vivado Simulator (for SV simulation) and EDA Playground (for UVM simulation)
are included in 'spi_simulation_results' file.
