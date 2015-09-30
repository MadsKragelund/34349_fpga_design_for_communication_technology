vcom -check_synthesis ../src/fcs_check_serial.vhd
quit -sim

vlib work

vcom -93 -explicit -work work ../src/fcs_check_serial_test.vhd
vsim fcs_check_serial_test

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
add wave i_fcs_check_1/R
add wave i_fcs_check_1/data
add wave i_fcs_check_1/shift_count

add wave -noupdate -divider -height 32 Outputs
add wave fcs_error

run 5400 ns

WaveRestoreZoom {0 ns} {5400 ns}
