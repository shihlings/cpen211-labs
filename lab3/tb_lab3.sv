`timescale 1 ps/ 1 ps

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


module tb_lab3();
   //inputs (active low)
   reg enter;
   reg reset;
   reg [3:0] input_num;

   //outputs (7-segment)
   wire[6:0]	     hex0;
   wire[6:0]	     hex1;
   wire[6:0]	     hex2;
   wire[6:0]	     hex3;
   wire[6:0]	     hex4;
   wire[6:0]	     hex5;

   reg		     err; //Error tracing

   lab3_top dut({6'b000000, input_num}, // SW
		{reset, 2'b00, enter}, // KEY
		hex0, hex1, hex2, hex3,
		hex4, hex5, ); // Don't care about LEDR
   

   // Task to check state and outputs
   task checker;
      input [4:0] exp_state;
      input [6:0] exp_hex0;
      input [6:0] exp_hex1;
      input [6:0] exp_hex2;
      input [6:0] exp_hex3;
      input [6:0] exp_hex4;
      input [6:0] exp_hex5;
      begin
	 if (tb_lab3.dut.state !== exp_state) begin
	    $display("Expected state %b, got %b",
		     exp_state, tb_lab3.dut.state);
	    err = 1;
	 end
	 if (tb_lab3.dut.HEX0 !== exp_hex0) begin
	    $display("Expected hex0 %b, got %b",
		     exp_hex0, tb_lab3.dut.HEX0);
	    err = 1;
	 end
	 if (tb_lab3.dut.HEX1 !== exp_hex1) begin
	    $display("Expected hex1 %b, got %b",
		     exp_hex1, tb_lab3.dut.HEX1);
	    err = 1;
	 end
	 if (tb_lab3.dut.HEX2 !== exp_hex2) begin
	    $display("Expected hex2 %b, got %b",
		     exp_hex2, tb_lab3.dut.HEX2);
	    err = 1;
	 end
	 if (tb_lab3.dut.HEX3 !== exp_hex3) begin
	    $display("Expected hex3 %b, got %b",
		     exp_hex3, tb_lab3.dut.HEX3);
	    err = 1;
	 end
	 if (tb_lab3.dut.HEX4 !== exp_hex4) begin
	    $display("Expected hex4 %b, got %b",
		     exp_hex4, tb_lab3.dut.HEX4);
	    err = 1;
	 end
	 if (tb_lab3.dut.HEX5 !== exp_hex5) begin
	    $display("Expected hex5 %b, got %b",
		     exp_hex5, tb_lab3.dut.HEX5);
	    err = 1;
	 end
      end
   endtask // checker
   
   initial forever begin
      enter = 1;
      #1;
      enter = 0;
      #1;
   end

   initial begin
      //iverilog setup
      $dumpfile("tb_lab3.vcd");
      $dumpvars(0, tb_lab3);
      
      reset = 0;
      #2;
      reset = 1;

      #2;
      

      $finish;
   end 

endmodule: tb_lab3
// Run iverilog with -g2005-sv for SystemVerilog
