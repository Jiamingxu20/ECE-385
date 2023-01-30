## Generated SDC file "lab222.out.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"

## DATE    "Mon Sep 26 20:41:41 2022"

##
## DEVICE  "10M50DAF484C7G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {Clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {Clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.500 [get_ports {Reset_Clear}]
set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.500 [get_ports {Run_Accumulate}]
set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.000 [get_ports {SW[0]}]
set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.000 [get_ports {SW[1]}]
set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.000 [get_ports {SW[2]}]
set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.000 [get_ports {SW[3]}]
set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.000 [get_ports {SW[4]}]
set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.000 [get_ports {SW[5]}]
set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.000 [get_ports {SW[6]}]
set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.000 [get_ports {SW[7]}]
set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.000 [get_ports {SW[8]}]
set_input_delay -add_delay -rise -clock [get_clocks {Clk}]  0.000 [get_ports {SW[9]}]


#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

