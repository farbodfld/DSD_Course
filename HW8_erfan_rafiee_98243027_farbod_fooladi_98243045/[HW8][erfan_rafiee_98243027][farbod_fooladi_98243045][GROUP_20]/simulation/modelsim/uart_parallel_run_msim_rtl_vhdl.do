transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/intelFPGA_lite/uart_parallel/UART_PARALLEL.vhd}
vcom -93 -work work {E:/intelFPGA_lite/uart_parallel/uart_2_parallel.vhd}
vcom -93 -work work {E:/intelFPGA_lite/uart_parallel/clk_divider.vhd}

