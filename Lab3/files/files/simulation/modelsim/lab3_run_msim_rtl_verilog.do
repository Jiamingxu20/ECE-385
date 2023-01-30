transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/ECE385/lab3/385_lab4_adders_provided_fa20 {D:/ECE385/lab3/385_lab4_adders_provided_fa20/mux.sv}
vlog -sv -work work +incdir+D:/ECE385/lab3/385_lab4_adders_provided_fa20 {D:/ECE385/lab3/385_lab4_adders_provided_fa20/full_adder_1bit.sv}
vlog -sv -work work +incdir+D:/ECE385/lab3/385_lab4_adders_provided_fa20 {D:/ECE385/lab3/385_lab4_adders_provided_fa20/select_adder.sv}
vlog -sv -work work +incdir+D:/ECE385/lab3/385_lab4_adders_provided_fa20 {D:/ECE385/lab3/385_lab4_adders_provided_fa20/full_adder.sv}

vlog -sv -work work +incdir+D:/ECE385/lab3/385_lab4_adders_provided_fa20 {D:/ECE385/lab3/385_lab4_adders_provided_fa20/testbench_lab3.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench_lab3

add wave *
view structure
view signals
run 200 ns
