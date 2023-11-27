onerror {resume}
radix define MyStates {
    "5'b00000" "Reset",
    "5'b00001" "Decode",
    "5'b00010" "GetA",
    "5'b00011" "GetB",
    "5'b00100" "Add",
    "5'b00101" "WriteReg",
    "5'b00110" "WriteImm",
    "5'b00111" "ALUNoOp",
    "5'b01000" "CMP",
    "5'b01001" "BitwiseAND",
    "5'b01010" "BitwiseNOT",
    "5'b01011" "IF1",
    "5'b01100" "IF2",
    "5'b01101" "UpdatePC",
    "5'b01110" "Halt",
    "5'b01111" "WriteDataAddress",
    "5'b10000" "AddImm",
    "5'b10001" "RegFromMem",
    "5'b10010" "RegToMem",
    "5'b10011" "Delay",
    "5'b10100" "GetB_Rd",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab7_top_tb/err
add wave -noupdate -radix binary /lab7_top_tb/DUT/CPU/clk
add wave -noupdate -radix decimal /lab7_top_tb/DUT/CPU/DP/REGFILE/R4
add wave -noupdate -radix decimal /lab7_top_tb/DUT/CPU/DP/REGFILE/R5
add wave -noupdate /lab7_top_tb/DUT/CPU/PC
add wave -noupdate /lab7_top_tb/DUT/read_data
add wave -noupdate /lab7_top_tb/DUT/CPU/instruction_reg_out
add wave -noupdate /lab7_top_tb/DUT/mem_addr
add wave -noupdate /lab7_top_tb/DUT/mem_cmd
add wave -noupdate -radix MyStates /lab7_top_tb/DUT/CPU/controller/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {39 ps} 0}
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
WaveRestoreZoom {0 ps} {99 ps}
