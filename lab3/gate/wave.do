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
radix define 7_Seg_Display {
    "7'b1000000" "dig_0",
    "7'b1111001" "dig_1",
    "7'b0100100" "dig_2",
    "7'b0110000" "dig_3",
    "7'b0011001" "dig_4",
    "7'b0010010" "dig_5",
    "7'b0000010" "dig_6",
    "7'b1111000" "dig_7",
    "7'b0000000" "dig_8",
    "7'b0010000" "dig_9",
    "7'b1000110" "char_C",
    "7'b0000110" "char_E",
    "7'b0101111" "char_r",
    "7'b0001100" "char_P",
    "7'b0101011" "char_n",
    "7'b1000111" "char_L",
    "7'b1111111" "OFF",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Inputs
add wave -noupdate -radix decimal -childformat {{{/tb_lab3_gate/DUT/SW[9]} -radix decimal} {{/tb_lab3_gate/DUT/SW[8]} -radix decimal} {{/tb_lab3_gate/DUT/SW[7]} -radix decimal} {{/tb_lab3_gate/DUT/SW[6]} -radix decimal} {{/tb_lab3_gate/DUT/SW[5]} -radix decimal} {{/tb_lab3_gate/DUT/SW[4]} -radix decimal} {{/tb_lab3_gate/DUT/SW[3]} -radix decimal} {{/tb_lab3_gate/DUT/SW[2]} -radix decimal} {{/tb_lab3_gate/DUT/SW[1]} -radix decimal} {{/tb_lab3_gate/DUT/SW[0]} -radix decimal}} -subitemconfig {{/tb_lab3_gate/DUT/SW[9]} {-radix decimal} {/tb_lab3_gate/DUT/SW[8]} {-radix decimal} {/tb_lab3_gate/DUT/SW[7]} {-radix decimal} {/tb_lab3_gate/DUT/SW[6]} {-radix decimal} {/tb_lab3_gate/DUT/SW[5]} {-radix decimal} {/tb_lab3_gate/DUT/SW[4]} {-radix decimal} {/tb_lab3_gate/DUT/SW[3]} {-radix decimal} {/tb_lab3_gate/DUT/SW[2]} {-radix decimal} {/tb_lab3_gate/DUT/SW[1]} {-radix decimal} {/tb_lab3_gate/DUT/SW[0]} {-radix decimal}} /tb_lab3_gate/DUT/SW
add wave -noupdate -childformat {{{/tb_lab3_gate/DUT/KEY[3]} -radix binary} {{/tb_lab3_gate/DUT/KEY[2]} -radix binary} {{/tb_lab3_gate/DUT/KEY[1]} -radix binary} {{/tb_lab3_gate/DUT/KEY[0]} -radix binary}} -expand -subitemconfig {{/tb_lab3_gate/DUT/KEY[3]} {-radix binary} {/tb_lab3_gate/DUT/KEY[2]} {-radix binary} {/tb_lab3_gate/DUT/KEY[1]} {-radix binary} {/tb_lab3_gate/DUT/KEY[0]} {-radix binary}} /tb_lab3_gate/DUT/KEY
add wave -noupdate -divider {Output 7-Seg-Display}
add wave -noupdate -radix 7_Seg_Display -childformat {{{/tb_lab3_gate/DUT/HEX5[6]} -radix binary} {{/tb_lab3_gate/DUT/HEX5[5]} -radix binary} {{/tb_lab3_gate/DUT/HEX5[4]} -radix binary} {{/tb_lab3_gate/DUT/HEX5[3]} -radix binary} {{/tb_lab3_gate/DUT/HEX5[2]} -radix binary} {{/tb_lab3_gate/DUT/HEX5[1]} -radix binary} {{/tb_lab3_gate/DUT/HEX5[0]} -radix binary}} -subitemconfig {{/tb_lab3_gate/DUT/HEX5[6]} {-radix binary} {/tb_lab3_gate/DUT/HEX5[5]} {-radix binary} {/tb_lab3_gate/DUT/HEX5[4]} {-radix binary} {/tb_lab3_gate/DUT/HEX5[3]} {-radix binary} {/tb_lab3_gate/DUT/HEX5[2]} {-radix binary} {/tb_lab3_gate/DUT/HEX5[1]} {-radix binary} {/tb_lab3_gate/DUT/HEX5[0]} {-radix binary}} /tb_lab3_gate/DUT/HEX5
add wave -noupdate -radix 7_Seg_Display -childformat {{{/tb_lab3_gate/DUT/HEX4[6]} -radix binary} {{/tb_lab3_gate/DUT/HEX4[5]} -radix binary} {{/tb_lab3_gate/DUT/HEX4[4]} -radix binary} {{/tb_lab3_gate/DUT/HEX4[3]} -radix binary} {{/tb_lab3_gate/DUT/HEX4[2]} -radix binary} {{/tb_lab3_gate/DUT/HEX4[1]} -radix binary} {{/tb_lab3_gate/DUT/HEX4[0]} -radix binary}} -subitemconfig {{/tb_lab3_gate/DUT/HEX4[6]} {-radix binary} {/tb_lab3_gate/DUT/HEX4[5]} {-radix binary} {/tb_lab3_gate/DUT/HEX4[4]} {-radix binary} {/tb_lab3_gate/DUT/HEX4[3]} {-radix binary} {/tb_lab3_gate/DUT/HEX4[2]} {-radix binary} {/tb_lab3_gate/DUT/HEX4[1]} {-radix binary} {/tb_lab3_gate/DUT/HEX4[0]} {-radix binary}} /tb_lab3_gate/DUT/HEX4
add wave -noupdate -radix 7_Seg_Display -childformat {{{/tb_lab3_gate/DUT/HEX3[6]} -radix binary} {{/tb_lab3_gate/DUT/HEX3[5]} -radix binary} {{/tb_lab3_gate/DUT/HEX3[4]} -radix binary} {{/tb_lab3_gate/DUT/HEX3[3]} -radix binary} {{/tb_lab3_gate/DUT/HEX3[2]} -radix binary} {{/tb_lab3_gate/DUT/HEX3[1]} -radix binary} {{/tb_lab3_gate/DUT/HEX3[0]} -radix binary}} -subitemconfig {{/tb_lab3_gate/DUT/HEX3[6]} {-radix binary} {/tb_lab3_gate/DUT/HEX3[5]} {-radix binary} {/tb_lab3_gate/DUT/HEX3[4]} {-radix binary} {/tb_lab3_gate/DUT/HEX3[3]} {-radix binary} {/tb_lab3_gate/DUT/HEX3[2]} {-radix binary} {/tb_lab3_gate/DUT/HEX3[1]} {-radix binary} {/tb_lab3_gate/DUT/HEX3[0]} {-radix binary}} /tb_lab3_gate/DUT/HEX3
add wave -noupdate -radix 7_Seg_Display -childformat {{{/tb_lab3_gate/DUT/HEX2[6]} -radix binary} {{/tb_lab3_gate/DUT/HEX2[5]} -radix binary} {{/tb_lab3_gate/DUT/HEX2[4]} -radix binary} {{/tb_lab3_gate/DUT/HEX2[3]} -radix binary} {{/tb_lab3_gate/DUT/HEX2[2]} -radix binary} {{/tb_lab3_gate/DUT/HEX2[1]} -radix binary} {{/tb_lab3_gate/DUT/HEX2[0]} -radix binary}} -subitemconfig {{/tb_lab3_gate/DUT/HEX2[6]} {-radix binary} {/tb_lab3_gate/DUT/HEX2[5]} {-radix binary} {/tb_lab3_gate/DUT/HEX2[4]} {-radix binary} {/tb_lab3_gate/DUT/HEX2[3]} {-radix binary} {/tb_lab3_gate/DUT/HEX2[2]} {-radix binary} {/tb_lab3_gate/DUT/HEX2[1]} {-radix binary} {/tb_lab3_gate/DUT/HEX2[0]} {-radix binary}} /tb_lab3_gate/DUT/HEX2
add wave -noupdate -radix 7_Seg_Display -childformat {{{/tb_lab3_gate/DUT/HEX1[6]} -radix binary} {{/tb_lab3_gate/DUT/HEX1[5]} -radix binary} {{/tb_lab3_gate/DUT/HEX1[4]} -radix binary} {{/tb_lab3_gate/DUT/HEX1[3]} -radix binary} {{/tb_lab3_gate/DUT/HEX1[2]} -radix binary} {{/tb_lab3_gate/DUT/HEX1[1]} -radix binary} {{/tb_lab3_gate/DUT/HEX1[0]} -radix binary}} -subitemconfig {{/tb_lab3_gate/DUT/HEX1[6]} {-radix binary} {/tb_lab3_gate/DUT/HEX1[5]} {-radix binary} {/tb_lab3_gate/DUT/HEX1[4]} {-radix binary} {/tb_lab3_gate/DUT/HEX1[3]} {-radix binary} {/tb_lab3_gate/DUT/HEX1[2]} {-radix binary} {/tb_lab3_gate/DUT/HEX1[1]} {-radix binary} {/tb_lab3_gate/DUT/HEX1[0]} {-radix binary}} /tb_lab3_gate/DUT/HEX1
add wave -noupdate -radix 7_Seg_Display -childformat {{{/tb_lab3_gate/DUT/HEX0[6]} -radix binary} {{/tb_lab3_gate/DUT/HEX0[5]} -radix binary} {{/tb_lab3_gate/DUT/HEX0[4]} -radix binary} {{/tb_lab3_gate/DUT/HEX0[3]} -radix binary} {{/tb_lab3_gate/DUT/HEX0[2]} -radix binary} {{/tb_lab3_gate/DUT/HEX0[1]} -radix binary} {{/tb_lab3_gate/DUT/HEX0[0]} -radix binary}} -subitemconfig {{/tb_lab3_gate/DUT/HEX0[6]} {-radix binary} {/tb_lab3_gate/DUT/HEX0[5]} {-radix binary} {/tb_lab3_gate/DUT/HEX0[4]} {-radix binary} {/tb_lab3_gate/DUT/HEX0[3]} {-radix binary} {/tb_lab3_gate/DUT/HEX0[2]} {-radix binary} {/tb_lab3_gate/DUT/HEX0[1]} {-radix binary} {/tb_lab3_gate/DUT/HEX0[0]} {-radix binary}} /tb_lab3_gate/DUT/HEX0
add wave -noupdate -divider {LED - NOT USED}
add wave -noupdate -radix binary -childformat {{{/tb_lab3_gate/DUT/LEDR[9]} -radix binary} {{/tb_lab3_gate/DUT/LEDR[8]} -radix binary} {{/tb_lab3_gate/DUT/LEDR[7]} -radix binary} {{/tb_lab3_gate/DUT/LEDR[6]} -radix binary} {{/tb_lab3_gate/DUT/LEDR[5]} -radix binary} {{/tb_lab3_gate/DUT/LEDR[4]} -radix binary} {{/tb_lab3_gate/DUT/LEDR[3]} -radix binary} {{/tb_lab3_gate/DUT/LEDR[2]} -radix binary} {{/tb_lab3_gate/DUT/LEDR[1]} -radix binary} {{/tb_lab3_gate/DUT/LEDR[0]} -radix binary}} -subitemconfig {{/tb_lab3_gate/DUT/LEDR[9]} {-radix binary} {/tb_lab3_gate/DUT/LEDR[8]} {-radix binary} {/tb_lab3_gate/DUT/LEDR[7]} {-radix binary} {/tb_lab3_gate/DUT/LEDR[6]} {-radix binary} {/tb_lab3_gate/DUT/LEDR[5]} {-radix binary} {/tb_lab3_gate/DUT/LEDR[4]} {-radix binary} {/tb_lab3_gate/DUT/LEDR[3]} {-radix binary} {/tb_lab3_gate/DUT/LEDR[2]} {-radix binary} {/tb_lab3_gate/DUT/LEDR[1]} {-radix binary} {/tb_lab3_gate/DUT/LEDR[0]} {-radix binary}} /tb_lab3_gate/DUT/LEDR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 194
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
WaveRestoreZoom {0 ps} {63 ps}
