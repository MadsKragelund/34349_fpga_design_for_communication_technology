vlib work

vcom -93 -explicit -work work fcs_check_serial_test.vhd
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
add wave fcs_error

run 4850 ns

WaveRestoreZoom {0 ns} {4850 ns}
