`define seg0 7'b0111111
`define seg1 7'b0000011
`define seg2 7'b1011011
`define seg3 7'b1001111
`define seg4 7'b1100110
`define seg5 7'b1101101
`define seg6 7'b1111101
`define seg7 7'b0000111
`define seg8 7'b1111111
`define seg9 7'b1101111
`define segO 7'b0111111
`define segP 7'b1110011
`define segE 7'b1111001
`define segn 7'b1010100
`define segC 7'b0111001
`define segL 7'b0111000
`define segS 7'b1101101
`define segD 7'b1011110
`define segr 7'b1010000
`define OFF  7'b0000000
`define T0   4'b0000
`define T1   4'b0001
`define T2   4'b0010
`define T3   4'b0011
`define T4   4'b0100
`define T5   4'b0101
`define T6   4'b0110
`define F1   4'b1001
`define F2   4'b1010
`define F3   4'b1011
`define F4   4'b1100
`define F5   4'b1101
`define F6   4'b1110

module lab3_top(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
   input [9:0] SW;
   input [3:0] KEY;
   output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   output reg [9:0] LEDR;   // optional: use these outputs for debugging on your DE1-SoC

   wire		clk = ~KEY[0];  // this is your clock
   wire		rst_n = KEY[3]; // this is your reset; your reset should be synchronous and active-low

   wire [3:0]	currentState;
   reg [3:0]	nextState;
	

   vDFF #4 U0(nextState, currentState, clk, rst_n);
      
  // put your solution code here!

   always @* begin
      case (SW)
	0: HEX0 = `seg0;
	1: HEX0 = `seg1;
	2: HEX0 = `seg2;
	3: HEX0 = `seg3;
	4: HEX0 = `seg4;
	5: HEX0 = `seg5;
	6: HEX0 = `seg6;
	7: HEX0 = `seg7;
	8: HEX0 = `seg8;
	9: HEX0 = `seg9;
	default: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = 
		 {`OFF, `segE, `segr, `segr, `segO, `segr};
      endcase // case (SW)

      case (currentState)
	`T0: nextState = (SW == 7) ? `T1:`F1;
	`T1: nextState = (SW == 2) ? `T2:`F2;
	`T2: nextState = (SW == 2) ? `T3:`F3;
	`T3: nextState = (SW == 2) ? `T4:`F4;
	`T4: nextState = (SW == 9) ? `T5:`F5;
	`T5: nextState = (SW == 7) ? `T6:`F6;
	`T6: nextState = `T6;
	`F1: nextState = `F2;
	`F2: nextState = `F3;
	`F3: nextState = `F4;
	`F4: nextState = `F5;
	`F5: nextState = `F6;
	`F6: nextState = `F6;
	default: nextState = 4'bx;
      endcase // case (currentState)
   end
   
endmodule

module vDFF (D, Q, clk, rst_n);
   parameter n = 1;
   input [n-1:0]      D;
   output reg [n-1:0] Q;
   input	      clk;
   input	      rst_n;

   always @(posedge clk) begin
      if (rst_n)
	Q <= D;
      else
	Q <= `T0;
   end
endmodule // vDFF
