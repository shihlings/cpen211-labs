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
`define char_S 7'b0010010
`define char_D 7'b1000000
`define OFF 7'b1111111

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
`define cor_1 4'b0000
`define cor_2 4'b0001
`define inc_2 4'b1001
`define cor_3 4'b0011
`define inc_3 4'b1011
`define cor_4 4'b0010
`define inc_4 4'b1010
`define cor_5 4'b0110
`define inc_5 4'b1110
`define cor_6 4'b0111
`define inc_6 4'b1111
`define open 4'b0101
`define closed 4'b1101

// Moore machine output encoding:
`define display_digit 2'b00
`define display_closed 2'b01
`define display_open 2'b10

// Sequence: 722297
// Sequence macros:
`define in_1 4'b0111
`define in_2 4'b0010
`define in_3 4'b0010
`define in_4 4'b0010
`define in_5 4'b1001
`define in_6 4'b0111

module lab3_top(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
   input [9:0] SW;
   input [3:0] KEY;
   output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   output [9:0]	    LEDR;   // optional: use these outputs for debugging on your DE1-SoC

   wire		    clk = ~KEY[0];  // this is your clock
   wire		    rst_n = KEY[3]; // this is your reset; your reset should be synchronous and active-low

   reg [3:0]	    state;
   reg [1:0]	    moore_out;

   always_ff @(posedge clk) begin
      if (~rst_n) begin
	 state = `cor_1;
      end
      else begin
	 case (state)
	   `cor_1: state = (SW[3:0] == `in_1) ? `cor_2 : `inc_2;
	   `cor_2: state = (SW[3:0] == `in_2) ? `cor_3 : `inc_3;
	   `cor_3: state = (SW[3:0] == `in_3) ? `cor_4 : `inc_4;
	   `cor_4: state = (SW[3:0] == `in_4) ? `cor_5 : `inc_5;
	   `cor_5: state = (SW[3:0] == `in_5) ? `cor_6 : `inc_6;
	   `cor_6: state = (SW[3:0] == `in_6) ? `open : `closed;
	   `open: state = `open;

	   `inc_2: state = `inc_3;
	   `inc_3: state = `inc_4;
	   `inc_4: state = `inc_5;
	   `inc_5: state = `inc_6;
	   `inc_6: state = `closed;
	   `closed: state = `closed;

	   default: state = 4'bxxx;
	 endcase // case (state)
	 
      end // else: !if(reset)

      case (state)
	`open: moore_out = `display_open;
	`closed: moore_out = `display_closed;
	default: moore_out = `display_digit;
      endcase // case (state)

      
   end // always_ff @ (posedge clk)

   always_comb begin
      if (moore_out == `display_digit) begin
	 case (SW[3:0])
	   4'b0000: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_0};
	   4'b0001: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_1};
	   4'b0010: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_2};
	   4'b0011: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_3};
	   4'b0100: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_4};
	   4'b0101: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_5};
	   4'b0110: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_6};
	   4'b0111: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_7};
	   4'b1000: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_8};
	   4'b1001: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_9};
	   default: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `char_E, `char_r, `char_r, `char_O, `char_r};
	 endcase
      end // if (moore_out == `display_digit)
      else if (moore_out == `display_closed) begin
	 {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`char_C, `char_L, `char_O, `char_S, `char_E, `char_D};
      end
      else if (moore_out == `display_open) begin
	 {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `OFF, `char_O, `char_P, `char_E, `char_n};
      end
      
   end 
   
endmodule
