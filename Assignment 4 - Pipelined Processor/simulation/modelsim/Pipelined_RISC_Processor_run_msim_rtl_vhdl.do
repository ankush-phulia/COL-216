transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Python27/COL 216 Arm and VHDL/Assignment 4 - Pipelined Processor/Data_Mem.vhd}

