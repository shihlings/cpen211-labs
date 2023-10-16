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

// Buttons go low when pressed
// Reset is synchronous
// Number display should be updated in real time

module tb_lab3();
   //inputs (active low)
   reg enter;
   reg reset;
   reg [3:0] input_num;

   //outputs (7-segment)
   reg[6:0]	     hex0;
   reg[6:0]	     hex1;
   reg[6:0]	     hex2;
   reg[6:0]	     hex3;
   reg[6:0]	     hex4;
   reg[6:0]	     hex5;

   reg		     err; //Error tracing   

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
      
      // Test sequence here
   end 

endmodule: tb_lab3
// Run iverilog with -g2005-sv for SystemVerilog
