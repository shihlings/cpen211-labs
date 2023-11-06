onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Read
add wave -noupdate -radix unsigned /regfile_tb/readnum
add wave -noupdate -radix decimal /regfile_tb/data_out
add wave -noupdate -divider Write
add wave -noupdate /regfile_tb/clk
add wave -noupdate /regfile_tb/write
add wave -noupdate -radix decimal /regfile_tb/data_in
add wave -noupdate -radix unsigned /regfile_tb/writenum
add wave -noupdate -radix decimal /regfile_tb/DUT/R0
add wave -noupdate -radix decimal /regfile_tb/DUT/R1
add wave -noupdate -radix decimal /regfile_tb/DUT/R2
add wave -noupdate -radix decimal /regfile_tb/DUT/R3
add wave -noupdate -radix decimal /regfile_tb/DUT/R4
add wave -noupdate -radix decimal /regfile_tb/DUT/R5
add wave -noupdate -radix decimal /regfile_tb/DUT/R6
add wave -noupdate -radix decimal /regfile_tb/DUT/R7
add wave -noupdate -divider {Error Signal}
add wave -noupdate /regfile_tb/err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {48 ps}
