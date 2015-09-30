vcom -check_synthesis ../src/async_fifo.vhd
quit -sim

vlib work

vcom -93 -explicit -work work ../src/async_fifo.vhd
vsim async_fifo

view structure
view signals
view wave

restart -force -nowave
add wave -noupdate -divider -height 32 Inputs
add wave clk
add wave reset
add wave start_of_frame
add wave end_of_frame
add wave data_in

add wave -noupdate -divider -height 32 Outputs
add wave uut/R
add wave uut/T
add wave uut/data
add wave uut/shift_count

add wave -noupdate -divider -height 32 Outputs
add wave fcs_error

run 5400 ns

WaveRestoreZoom {0 ns} {5400 ns}
