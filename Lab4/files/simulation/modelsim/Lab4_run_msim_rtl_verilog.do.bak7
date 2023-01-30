transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/ECE385/lab4/files/SV\ files {D:/ECE385/lab4/files/SV files/Multiplier_unit.sv}
vlog -sv -work work +incdir+D:/ECE385/lab4/files/SV\ files {D:/ECE385/lab4/files/SV files/Synchronizers.sv}
vlog -sv -work work +incdir+D:/ECE385/lab4/files/SV\ files {D:/ECE385/lab4/files/SV files/Register_unit.sv}
vlog -sv -work work +incdir+D:/ECE385/lab4/files/SV\ files {D:/ECE385/lab4/files/SV files/Reg_8.sv}
vlog -sv -work work +incdir+D:/ECE385/lab4/files/SV\ files {D:/ECE385/lab4/files/SV files/HexDriver.sv}
vlog -sv -work work +incdir+D:/ECE385/lab4/files/SV\ files {D:/ECE385/lab4/files/SV files/full_adder_9bit.sv}
vlog -sv -work work +incdir+D:/ECE385/lab4/files/SV\ files {D:/ECE385/lab4/files/SV files/full_adder_1bit.sv}
vlog -sv -work work +incdir+D:/ECE385/lab4/files/SV\ files {D:/ECE385/lab4/files/SV files/Control_unit.sv}
vlog -sv -work work +incdir+D:/ECE385/lab4/files/SV\ files {D:/ECE385/lab4/files/SV files/Processor.sv}

vlog -sv -work work +incdir+D:/ECE385/lab4/files/SV\ files {D:/ECE385/lab4/files/SV files/testbench_lab4.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench_lab4

add wave *
view structure
view signals
run 2000 ns
