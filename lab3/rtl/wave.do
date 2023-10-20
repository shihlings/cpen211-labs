onerror {resume}
radix define MyStates {
    "4'b0000" "cor_1",
    "4'b0001" "cor_2",
    "4'b1001" "inc_2",
    "4'b0011" "cor_3",
    "4'b1011" "inc_3",
    "4'b0010" "cor_4",
    "4'b1010" "inc_4",
    "4'b0110" "cor_5",
    "4'b1110" "inc_5",
    "4'b0111" "cor_6",
    "4'b1111" "inc_6",
    "4'b0101" "open",
    "4'b1101" "closed",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /tb_lab3/DUT/SW
add wave -noupdate /tb_lab3/DUT/KEY
add wave -noupdate /tb_lab3/DUT/HEX0
add wave -noupdate /tb_lab3/DUT/HEX1
add wave -noupdate /tb_lab3/DUT/HEX2
add wave -noupdate /tb_lab3/DUT/HEX3
add wave -noupdate /tb_lab3/DUT/HEX4
add wave -noupdate /tb_lab3/DUT/HEX5
add wave -noupdate /tb_lab3/DUT/LEDR
add wave -noupdate -radix binary /tb_lab3/DUT/clk
add wave -noupdate -radix binary /tb_lab3/DUT/rst_n
add wave -noupdate -radix MyStates /tb_lab3/DUT/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {218 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {235 ps}
