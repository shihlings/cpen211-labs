onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 30 {Register MUX}
add wave -noupdate -height 20 -radix decimal /datapath_tb/datapath_in
add wave -noupdate -height 20 -radix decimal /datapath_tb/datapath_out
add wave -noupdate -height 20 -radix binary /datapath_tb/vsel
add wave -noupdate -divider -height 30 Regfile
add wave -noupdate -height 20 -radix unsigned /datapath_tb/readnum
add wave -noupdate -height 20 -radix decimal /datapath_tb/DUT/data_out
add wave -noupdate -height 20 /datapath_tb/clk
add wave -noupdate -height 20 -radix decimal /datapath_tb/DUT/data_in
add wave -noupdate -height 20 -radix unsigned /datapath_tb/writenum
add wave -noupdate -height 20 /datapath_tb/write
add wave -noupdate -height 20 -radix decimal /datapath_tb/DUT/REGFILE/R0
add wave -noupdate -height 20 -radix decimal /datapath_tb/DUT/REGFILE/R1
add wave -noupdate -height 20 -radix decimal /datapath_tb/DUT/REGFILE/R2
add wave -noupdate -height 20 -radix decimal /datapath_tb/DUT/REGFILE/R3
add wave -noupdate -height 20 -radix decimal /datapath_tb/DUT/REGFILE/R4
add wave -noupdate -height 20 -radix decimal /datapath_tb/DUT/REGFILE/R5
add wave -noupdate -height 20 -radix decimal /datapath_tb/DUT/REGFILE/R6
add wave -noupdate -height 20 -radix decimal /datapath_tb/DUT/REGFILE/R7
add wave -noupdate -divider -height 30 {DFFE A}
add wave -noupdate -height 20 -radix unsigned /datapath_tb/DUT/data_out
add wave -noupdate -height 20 -radix binary /datapath_tb/clk
add wave -noupdate -height 20 -radix binary /datapath_tb/loada
add wave -noupdate -height 20 -radix unsigned /datapath_tb/DUT/A
add wave -noupdate -divider -height 30 {A MUX}
add wave -noupdate -height 20 -radix unsigned /datapath_tb/DUT/A
add wave -noupdate -height 20 /datapath_tb/asel
add wave -noupdate -height 20 -radix unsigned /datapath_tb/DUT/Ain
add wave -noupdate -divider -height 30 {DFFE B}
add wave -noupdate -height 20 -radix unsigned /datapath_tb/DUT/data_out
add wave -noupdate -height 20 -radix binary /datapath_tb/clk
add wave -noupdate -height 20 -radix binary /datapath_tb/loadb
add wave -noupdate -height 20 -radix unsigned /datapath_tb/DUT/B
add wave -noupdate -divider -height 30 Shifter
add wave -noupdate -height 20 /datapath_tb/shift
add wave -noupdate -height 20 /datapath_tb/DUT/SHIFTER/in
add wave -noupdate -height 20 /datapath_tb/DUT/SHIFTER/sout
add wave -noupdate -divider -height 30 {B MUX}
add wave -noupdate -height 20 /datapath_tb/DUT/SHIFTER/sout
add wave -noupdate -height 20 -radix binary /datapath_tb/datapath_in
add wave -noupdate -height 20 /datapath_tb/bsel
add wave -noupdate -height 20 /datapath_tb/DUT/Bin
add wave -noupdate -divider -height 30 ALU
add wave -noupdate -height 20 -radix unsigned /datapath_tb/DUT/Ain
add wave -noupdate -height 20 /datapath_tb/DUT/Bin
add wave -noupdate -height 20 /datapath_tb/ALUop
add wave -noupdate -height 20 /datapath_tb/DUT/out
add wave -noupdate -divider -height 25 {DFFE C}
add wave -noupdate -height 20 /datapath_tb/DUT/out
add wave -noupdate -height 20 /datapath_tb/clk
add wave -noupdate -height 20 /datapath_tb/loadc
add wave -noupdate -height 20 /datapath_tb/DUT/C
add wave -noupdate -divider -height 30 {DFFE status}
add wave -noupdate -height 20 -radix binary /datapath_tb/DUT/Z
add wave -noupdate -height 20 -radix binary /datapath_tb/clk
add wave -noupdate -height 20 -radix binary /datapath_tb/loads
add wave -noupdate -height 20 -radix binary /datapath_tb/Z_out
add wave -noupdate -divider -height 30 {Error signal}
add wave -noupdate -height 20 /datapath_tb/err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 126
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
WaveRestoreZoom {0 ps} {60 ps}
