// definition for each letter/number on 7 segment display (1 means on, 0 is off)
`define seg0 7'b1000000
`define seg1 7'b1111001
`define seg2 7'b0100100
`define seg3 7'b0110000
`define seg4 7'b0011001
`define seg5 7'b0010010
`define seg6 7'b0000010
`define seg7 7'b1111000
`define seg8 7'b0000000
`define seg9 7'b0010000
`define segO 7'b1000000
`define segP 7'b0001100
`define segE 7'b0000110
`define segn 7'b0101011
`define segC 7'b1000110
`define segL 7'b1000111
`define segS 7'b0010010
`define segD 7'b1000000
`define segr 7'b0101111
`define OFF  7'b1111111

// definition of all of the possible display combination used
`define dis_ErrOr  {`OFF, `segE, `segr, `segr, `segO, `segr}
`define dis_OPEn   {`OFF, `OFF, `segO, `segP, `segE, `segn}
`define dis_CLOSED {`segC, `segL, `segO, `segS, `segE, `segD}
`define dis_0 {`OFF, `OFF, `OFF, `OFF, `OFF, `seg0}
`define dis_1 {`OFF, `OFF, `OFF, `OFF, `OFF, `seg1}
`define dis_2 {`OFF, `OFF, `OFF, `OFF, `OFF, `seg2}
`define dis_3 {`OFF, `OFF, `OFF, `OFF, `OFF, `seg3}
`define dis_4 {`OFF, `OFF, `OFF, `OFF, `OFF, `seg4}
`define dis_5 {`OFF, `OFF, `OFF, `OFF, `OFF, `seg5}
`define dis_6 {`OFF, `OFF, `OFF, `OFF, `OFF, `seg6}
`define dis_7 {`OFF, `OFF, `OFF, `OFF, `OFF, `seg7}
`define dis_8 {`OFF, `OFF, `OFF, `OFF, `OFF, `seg8}
`define dis_9 {`OFF, `OFF, `OFF, `OFF, `OFF, `seg9}

// definition of states (T means still on correct path, F means 1 or more entry is wrong already)
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
   output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   output [9:0] LEDR;   // optional: use these outputs for debugging on your DE1-SoC

   wire		clk = ~KEY[0];  // this is your clock
   wire		rst_n = KEY[3]; // this is your reset; your reset should be synchronous and active-low

   wire [3:0]	currentState; // the current state that is stored in flip flop
   reg [3:0]	nextState; // the next state according to the current input
   reg [41:0]	displayHEX; // the compilation of all 6 7-segment displays

   // disassembling the displayHEX signal into individual 7-segment display
   // a not is used infront of all signals because 0 indicates on for the DE1
   // the definition used uses 1 as on
   assign HEX0 = displayHEX[6:0];
   assign HEX1 = displayHEX[13:7];
   assign HEX2 = displayHEX[20:14];
   assign HEX3 = displayHEX[27:21];
   assign HEX4 = displayHEX[34:28];
   assign HEX5 = displayHEX[41:35];

   // initiate a DFF
   vDFF #4 U0(nextState, currentState, clk, rst_n);
      
   // Type 1: combinational
   // determine the next state and what to display
   always @* begin
      case (SW)
	0: displayHEX = `dis_0;
	1: displayHEX = `dis_1;
	2: displayHEX = `dis_2;
	3: displayHEX = `dis_3;
	4: displayHEX = `dis_4;
	5: displayHEX = `dis_5;
	6: displayHEX = `dis_6;
	7: displayHEX = `dis_7;
	8: displayHEX = `dis_8;
	9: displayHEX = `dis_9;
	default: displayHEX = `dis_ErrOr;
      endcase // case (SW)

      case (currentState)
	`T0: nextState = (SW == 7) ? `T1:`F1;
	`T1: nextState = (SW == 2) ? `T2:`F2;
	`T2: nextState = (SW == 2) ? `T3:`F3;
	`T3: nextState = (SW == 2) ? `T4:`F4;
	`T4: nextState = (SW == 9) ? `T5:`F5;
	`T5: nextState = (SW == 7) ? `T6:`F6;
	`T6: {displayHEX, nextState} = {`dis_OPEn, `T6}; // overwrite the number with OPEn if the lock is unlocked
	`F1: nextState = `F2;
	`F2: nextState = `F3;
	`F3: nextState = `F4;
	`F4: nextState = `F5;
	`F5: nextState = `F6;
	`F6: {displayHEX, nextState} = {`dis_CLOSED, `F6}; // overwrite the number with CLOSED if the lock is closed
	default: nextState = 4'bx;
      endcase // case (currentState)
   end
   
endmodule

// general DFF with a parameter (for how many bits)
module vDFF (D, Q, clk, rst_n);
   parameter n = 1;
   input [n-1:0]      D;
   output reg [n-1:0] Q;
   input	      clk;
   input	      rst_n;

   // store the next signal (D) into Q if clock is pressed
   always @(posedge clk) begin
      if (rst_n)
	Q = D;
      else
	Q = `T0;
   end
endmodule // vDFF
