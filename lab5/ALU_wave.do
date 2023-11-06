onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate -radix decimal /ALU_tb/Ain
add wave -noupdate -radix decimal /ALU_tb/Bin
add wave -noupdate -radix binary /ALU_tb/ALUop
add wave -noupdate -divider Outputs
add wave -noupdate -radix decimal /ALU_tb/out
add wave -noupdate -radix binary /ALU_tb/Z
add wave -noupdate -divider {Error Signal}
add wave -noupdate -radix binary /ALU_tb/err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 136
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {17 ps}
