onerror {resume}
radix define MyStates {
    "5'b00000" "Reset",
    "5'b00001" "Decode",
    "5'b00100" "AddReg",
    "5'b00101" "AddDataAddress",
    "5'b00110" "WriteImm",
    "5'b00111" "ALUNoOp_toReg",
    "5'b01000" "CMP",
    "5'b01001" "BitwiseAND",
    "5'b01010" "BitwiseNOT",
    "5'b01011" "IF1",
    "5'b01101" "UpdatePC",
    "5'b01110" "Halt",
    "5'b01111" "WriteDataAddress",
    "5'b10000" "AddImm",
    "5'b10001" "RegFromMem",
    "5'b10010" "RegToMem",
    "5'b10011" "ALUNOOp_RdToMem",
    "5'b10100" "ALUNoOp_RdToPC",
    "5'b10101" "PCtoRn",
    "5'b10110" "RdtoPC",
    "5'b10111" "Branch",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /ultimate_test/DUT/CPU/PC_reg/PC
add wave -noupdate -radix decimal /ultimate_test/DUT/CPU/DP/REGFILE/R0
add wave -noupdate -radix decimal /ultimate_test/DUT/CPU/DP/REGFILE/R1
add wave -noupdate -radix decimal /ultimate_test/DUT/CPU/DP/REGFILE/R2
add wave -noupdate -radix decimal /ultimate_test/DUT/CPU/DP/REGFILE/R3
add wave -noupdate -radix decimal /ultimate_test/DUT/CPU/DP/REGFILE/R4
add wave -noupdate -radix decimal /ultimate_test/DUT/CPU/DP/REGFILE/R5
add wave -noupdate -radix decimal /ultimate_test/DUT/CPU/DP/REGFILE/R6
add wave -noupdate -radix decimal /ultimate_test/DUT/CPU/DP/REGFILE/R7
add wave -noupdate /ultimate_test/DUT/CPU/PC_reg/reset_pc
add wave -noupdate /ultimate_test/DUT/CPU/PC_reg/allow_branch
add wave -noupdate /ultimate_test/DUT/CPU/PC_reg/branch_en
add wave -noupdate /ultimate_test/DUT/CPU/PC_reg/PC_branch_addr_in
add wave -noupdate /ultimate_test/DUT/CPU/PC_reg/load_pc
add wave -noupdate /ultimate_test/DUT/CPU/PC_reg/clk
add wave -noupdate /ultimate_test/DUT/CPU/PC_reg/next_pc
add wave -noupdate -radix MyStates /ultimate_test/DUT/CPU/controller/state
add wave -noupdate -radix decimal {/ultimate_test/DUT/MEM/mem[27]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {821 ps} 0}
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
WaveRestoreZoom {808 ps} {874 ps}
