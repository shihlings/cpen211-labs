// 7-segment digits and characters
`define dig_0 7'b1000000
`define dig_1 7'b1111001
`define dig_2 7'b0100100
`define dig_3 7'b0110000
`define dig_4 7'b0011001
`define dig_5 7'b0010010
`define dig_6 7'b0000011
`define dig_7 7'b1111000
`define dig_8 7'b0000000
`define dig_9 7'b0100000

`define char_O 7'b1000000
`define char_C 7'b1110000
`define char_E 7'b0110000
`define char_r 7'b0101111
`define char_P 7'b0001100
`define char_n 7'b0101000
`define char_L 7'b1000111
`define char_s 7'b0010010
`define char_D 7'b1000000

module lab3_top(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
   input [9:0] SW;
   input [3:0] KEY;
   output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   output [9:0]	   LEDR;   // optional: use these outputs for debugging on your DE1-SoC

   wire	       clk = ~KEY[0];  // this is your clock
   wire	rst_n = KEY[3]; // this is your reset; your reset should be synchronous and active-low

   reg [3:0] state;
   // State encoding:
   // 0xxx -> All inputs so far correct
   // 1xxx -> At least one incorrect input
   // 0000 -> First input
   // x001 -> Second input
   // x011 -> Third input
   // x010 -> Fourth input
   // x110 -> Fifth input
   // x111 -> Sixth input
   // x101 -> Open/Closed

   always @(posedge clk) begin
      if (reset) begin
	 state = 4'b0000;
      end
      else begin
	 if (state == 4'b0000) begin
	    state = (KEY == '
	 
   
endmodule
