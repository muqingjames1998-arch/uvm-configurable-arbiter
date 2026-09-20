vlib work

vlog -sv ../rtl/configurable_arbiter.sv
vlog -sv ../tb/arbiter_if.sv
vlog -sv +incdir+../tb ../tb/arbiter_pkg.sv
vlog -sv ../tb/tb_top.sv

vsim -novopt work.tb_top

onfinish stop
run -all