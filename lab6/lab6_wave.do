onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/clk
add wave -noupdate /cpu_tb/err
add wave -noupdate -divider I/O
add wave -noupdate -radix binary /cpu_tb/reset
add wave -noupdate -radix binary /cpu_tb/load
add wave -noupdate -radix binary /cpu_tb/s
add wave -noupdate -radix binary /cpu_tb/w
add wave -noupdate /cpu_tb/DUT/DP/Z_out
add wave -noupdate -radix decimal -childformat {{{/cpu_tb/in[15]} -radix decimal} {{/cpu_tb/in[14]} -radix decimal} {{/cpu_tb/in[13]} -radix decimal} {{/cpu_tb/in[12]} -radix decimal} {{/cpu_tb/in[11]} -radix decimal} {{/cpu_tb/in[10]} -radix decimal} {{/cpu_tb/in[9]} -radix decimal} {{/cpu_tb/in[8]} -radix decimal} {{/cpu_tb/in[7]} -radix decimal} {{/cpu_tb/in[6]} -radix decimal} {{/cpu_tb/in[5]} -radix decimal} {{/cpu_tb/in[4]} -radix decimal} {{/cpu_tb/in[3]} -radix decimal} {{/cpu_tb/in[2]} -radix decimal} {{/cpu_tb/in[1]} -radix decimal} {{/cpu_tb/in[0]} -radix decimal}} -subitemconfig {{/cpu_tb/in[15]} {-height 14 -radix decimal} {/cpu_tb/in[14]} {-height 14 -radix decimal} {/cpu_tb/in[13]} {-height 14 -radix decimal} {/cpu_tb/in[12]} {-height 14 -radix decimal} {/cpu_tb/in[11]} {-height 14 -radix decimal} {/cpu_tb/in[10]} {-height 14 -radix decimal} {/cpu_tb/in[9]} {-height 14 -radix decimal} {/cpu_tb/in[8]} {-height 14 -radix decimal} {/cpu_tb/in[7]} {-height 14 -radix decimal} {/cpu_tb/in[6]} {-height 14 -radix decimal} {/cpu_tb/in[5]} {-height 14 -radix decimal} {/cpu_tb/in[4]} {-height 14 -radix decimal} {/cpu_tb/in[3]} {-height 14 -radix decimal} {/cpu_tb/in[2]} {-height 14 -radix decimal} {/cpu_tb/in[1]} {-height 14 -radix decimal} {/cpu_tb/in[0]} {-height 14 -radix decimal}} /cpu_tb/in
add wave -noupdate -radix decimal -childformat {{{/cpu_tb/out[15]} -radix decimal} {{/cpu_tb/out[14]} -radix decimal} {{/cpu_tb/out[13]} -radix decimal} {{/cpu_tb/out[12]} -radix decimal} {{/cpu_tb/out[11]} -radix decimal} {{/cpu_tb/out[10]} -radix decimal} {{/cpu_tb/out[9]} -radix decimal} {{/cpu_tb/out[8]} -radix decimal} {{/cpu_tb/out[7]} -radix decimal} {{/cpu_tb/out[6]} -radix decimal} {{/cpu_tb/out[5]} -radix decimal} {{/cpu_tb/out[4]} -radix decimal} {{/cpu_tb/out[3]} -radix decimal} {{/cpu_tb/out[2]} -radix decimal} {{/cpu_tb/out[1]} -radix decimal} {{/cpu_tb/out[0]} -radix decimal}} -subitemconfig {{/cpu_tb/out[15]} {-height 15 -radix decimal} {/cpu_tb/out[14]} {-height 15 -radix decimal} {/cpu_tb/out[13]} {-height 15 -radix decimal} {/cpu_tb/out[12]} {-height 15 -radix decimal} {/cpu_tb/out[11]} {-height 15 -radix decimal} {/cpu_tb/out[10]} {-height 15 -radix decimal} {/cpu_tb/out[9]} {-height 15 -radix decimal} {/cpu_tb/out[8]} {-height 15 -radix decimal} {/cpu_tb/out[7]} {-height 15 -radix decimal} {/cpu_tb/out[6]} {-height 15 -radix decimal} {/cpu_tb/out[5]} {-height 15 -radix decimal} {/cpu_tb/out[4]} {-height 15 -radix decimal} {/cpu_tb/out[3]} {-height 15 -radix decimal} {/cpu_tb/out[2]} {-height 15 -radix decimal} {/cpu_tb/out[1]} {-height 15 -radix decimal} {/cpu_tb/out[0]} {-height 15 -radix decimal}} /cpu_tb/out
add wave -noupdate -divider Registers
add wave -noupdate -radix decimal /cpu_tb/DUT/DP/REGFILE/R0
add wave -noupdate -radix decimal /cpu_tb/DUT/DP/REGFILE/R1
add wave -noupdate -radix decimal /cpu_tb/DUT/DP/REGFILE/R2
add wave -noupdate -radix decimal /cpu_tb/DUT/DP/REGFILE/R3
add wave -noupdate -radix decimal /cpu_tb/DUT/DP/REGFILE/R4
add wave -noupdate -radix decimal /cpu_tb/DUT/DP/REGFILE/R5
add wave -noupdate -radix decimal /cpu_tb/DUT/DP/REGFILE/R6
add wave -noupdate -radix decimal /cpu_tb/DUT/DP/REGFILE/R7
add wave -noupdate -divider {Decoded Instruction}
add wave -noupdate /cpu_tb/DUT/opcode
add wave -noupdate /cpu_tb/DUT/op
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {858 ps} 0}
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
WaveRestoreZoom {0 ps} {1085 ps}
