`define seg0 = 7'b0111111
`define seg1 = 7'b0000011
`define seg2 = 7'b1011011
`define seg3 = 7'b1001111
`define seg4 = 7'b1100110
`define seg5 = 7'b1101101
`define seg6 = 7'b1111101
`define seg7 = 7'b0000111
`define seg8 = 7'b1111111
`define seg9 = 7'b1101111
`define segO = 7'b0111111
`define segP = 7'b1110011
`define segE = 7'b1111001
`define segn = 7'b1010100
`define segC = 7'b0111001
`define segL = 7'b0111000
`define segS = 7'b1101101
`define segd = 7'b1011110
`define segr = 7'b1010000

module lab3_top(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
  input [9:0] SW;
  input [3:0] KEY;
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  output [9:0] LEDR;   // optional: use these outputs for debugging on your DE1-SoC

  wire clk = ~KEY[0];  // this is your clock
  wire rst_n = KEY[3]; // this is your reset; your reset should be synchronous and active-low

  // put your solution code here!
endmodule
