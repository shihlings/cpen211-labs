// 7-segment digits and characters
`define dig_0 7'b1000000
`define dig_1 7'b1111001
`define dig_2 7'b0100100
`define dig_3 7'b0110000
`define dig_4 7'b0011001
`define dig_5 7'b0010010
`define dig_6 7'b0000010
`define dig_7 7'b1111000
`define dig_8 7'b0000000
`define dig_9 7'b0010000

`define char_O 7'b1000000
`define char_C 7'b1000110
`define char_E 7'b0000110
`define char_r 7'b0101111
`define char_P 7'b0001100
`define char_n 7'b0101011
`define char_L 7'b1000111
`define char_S 7'b0010010
`define char_D 7'b1000000
`define OFF    7'b1111111

// definition of all of the possible display combination used
`define dis_ErrOr  {`OFF, `char_E, `char_r, `char_r, `char_O, `char_r}
`define dis_OPEn   {`OFF, `OFF, `char_O, `char_P, `char_E, `char_n}
`define dis_CLOSED {`char_C, `char_L, `char_O, `char_S, `char_E, `char_D}
`define dis_0 {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_0}
`define dis_1 {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_1}
`define dis_2 {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_2}
`define dis_3 {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_3}
`define dis_4 {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_4}
`define dis_5 {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_5}
`define dis_6 {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_6}
`define dis_7 {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_7}
`define dis_8 {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_8}
`define dis_9 {`OFF, `OFF, `OFF, `OFF, `OFF, `dig_9}

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
`define cor_1  4'b0000
`define cor_2  4'b0001
`define inc_2  4'b1001
`define cor_3  4'b0011
`define inc_3  4'b1011
`define cor_4  4'b0010
`define inc_4  4'b1010
`define cor_5  4'b0110
`define inc_5  4'b1110
`define cor_6  4'b0111
`define inc_6  4'b1111
`define open   4'b0101
`define closed 4'b1101

// Moore machine output encoding:
`define display_digit  2'b00
`define display_closed 2'b01
`define display_open   2'b10

// Sequence: 722297
// Correct sequence macros:
`define in_1 4'b0111
`define in_2 4'b0010
`define in_3 4'b0010
`define in_4 4'b0010
`define in_5 4'b1001
`define in_6 4'b0111

module tb_lab3();
   // declaration for all input/outputs for lab3_top
   reg [9:0]      SW;
   reg		  clk;
   reg		  rst;
   reg		  err;
   reg		  unlock;
   reg [41:0]	  expectedHEX;
   reg [3:0]	  expectedState;
   reg [0:59]	  test_inputs;
   wire [9:0]	  LEDR;
   wire [6:0]	  HEX0;
   wire [6:0]	  HEX1;
   wire [6:0]	  HEX2;
   wire [6:0]	  HEX3;
   wire [6:0]	  HEX4;
   wire [6:0]	  HEX5;

   // declare a DUT with the corresponding i/o
   // For KEY[2:1], they are always 1 as they're not used (buttons are 1 when not preseed)
   lab3_top DUT(.SW(SW), .KEY({~rst, 2'b1, ~clk}), .LEDR(LEDR), .HEX0(HEX0), .HEX1(HEX1), 
		.HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
   
   // initialize a clock, period = 4 ps
   initial begin
      // do not start clock at the beginning while testing HEX functionality
      clk = 1'b0;
      #48;
      forever begin
	 clk = 1'b1; #2;
	 clk = 1'b0; #2;
	 clk = 1'b1;
      end
   end
   
   // a checker to see if the HEX0 value matches the expected value
   task HEX_checker;
      input [41:0] expectedHEX;
      begin
	 if (tb_lab3.DUT.displayHEX != expectedHEX) begin
	    $display("ERROR! HEX0 is not displaying the correct output value");
	    $display("       Current Value: %d, Expected: %b, Actual: %b", 
		     tb_lab3.DUT.SW, expectedHEX[6:0], tb_lab3.DUT.displayHEX[6:0]);
	    err = 1'b1;
	 end
	 else begin
	    $display("PASS,  displaying %d, %b", SW, tb_lab3.DUT.displayHEX[6:0]);
	 end
      end
   endtask // HEX_checker
   
   // a checker to see if the state transition is expected
   task testState;
      input [3:0] expectedState;
      begin
	 if (tb_lab3.DUT.state != expectedState) begin
	    $display("ERROR! Unexpected state transition");
	    $display("       Current Value: %d, Expected: %b, Actual: %b", 
		     tb_lab3.DUT.SW, expectedState, tb_lab3.DUT.state);
	    err = 1'b1;
	 end
	 else begin
	    $display("PASS,  Current Value: %d, Current State: %b", 
		     tb_lab3.DUT.SW, tb_lab3.DUT.state);
	 end
      end
   endtask // checkState
   
   // a checker to see if the lock is at the correct final state
   task checkFinal;
      input unlock;
      begin
	 if (unlock) begin
	    if (tb_lab3.DUT.displayHEX != `dis_OPEn) begin
	       $display("ERROR! OPEn not displayed");
	       err = 1'b1;
	    end
	    else begin
	       $display("PASS,  Displaying OPEn on HEX");
	    end
	 end
	 else begin
	    if (tb_lab3.DUT.displayHEX != `dis_CLOSED) begin
	       $display("ERROR! CLOSED not displayed");
	       err = 1'b1;
	    end
	    else begin
	       $display("PASS,  Displaying CLOSED on HEX");
	    end
	 end // else: !if(unlock)
      end
   endtask // checkFinal

   // takes in a set of inputs and checks if the state machine works properly
   task checkTransition;
      input [0:59] num_in;
      begin
	 // put in first digit
	 SW = num_in[0:9];
	 #2;
	 // check against correct answer: 722297
	 if (SW == 10'd7) begin
	    expectedState = `cor_2;
	 end
	 else begin
	    expectedState = `inc_2;
	 end
	 #1;
	 // check state
	 testState(expectedState);
	 #1;

	 // put in second digit
	 SW = num_in[10:19];
	 #2;
	 // check against correct answer: 722297
	 if (SW == 10'd2 && expectedState == `cor_2) begin
	    expectedState = `cor_3;
	 end
	 else begin
	    expectedState = `inc_3;
	 end
	 #1;
	 testState(expectedState);
	 #1;

	 // put in third digit 
	 SW = num_in[20:29];
	 #2;
	 // check against correct answer: 722297
	 if (SW == 10'd2 && expectedState == `cor_3) begin
	    expectedState = `cor_4;
	 end
	 else begin
	    expectedState = `inc_4;
	 end
	 #1;
	 testState(expectedState);
	 #1;

	 // put in 4th digit
	 SW = num_in[30:39];
	 #2;
	 // check against correct answer: 722297
	 if (SW == 10'd2 && expectedState == `cor_4) begin
	    expectedState = `cor_5;
	 end
	 else begin
	    expectedState = `inc_5;
	 end
	 #1;
	 testState(expectedState);
	 #1;

	 // put in fifth digit
	 SW = num_in[40:49];
	 #2;
	 // check against correct answer: 722297
	 if (SW == 10'd9 && expectedState == `cor_5) begin
	    expectedState = `cor_6;
	 end
	 else begin
	    expectedState = `inc_6;
	 end
	 #1;
	 testState(expectedState);
	 #1;

	 // put in 6th digit (last)
	 SW = num_in[50:59];
	 #2;
	 // check against correct answer: 722297
	 if (SW == 10'd7 && expectedState == `cor_6) begin
	    expectedState = `open;
	 end
	 else begin
	    expectedState = `closed;
	 end
	 #1;
	 testState(expectedState);
	 #1;

	 // check if this conbination should unlock
	 if (expectedState == `open) begin
	    unlock = 1'b1;
	 end
	 else begin
	    unlock = 1'b0;
	 end

	 // check if the lock is actually unlocked
	 checkFinal(unlock);

	 // check if the self loop at the end works
	 #4;
	 testState(expectedState);

	 // change an input and see if the self loop still works
	 SW = 10'b0;
	 #4;
	 testState(expectedState);
      end
   endtask // checkTransition
   
   //start running testbench tasks
   initial begin
      //iverilog and GTKWave use only
      $dumpfile("waveform.vcd");
      $dumpvars(0, tb_lab3);
      
      // reset error indicator
      err = 1'b0;
      SW = 10'b0;
      
      // reset the lock -- synchronous reset
      rst = 1'b0;
      #4;
      rst = 1'b1;
      #2;
      if (tb_lab3.DUT.state != `cor_1) begin
	 err = 1'b1;
	 $display("ERROR! Reset did not return to state cor_1");
	 $display("       Current value: %d, Expected State: %b, Actual State: %b", 
		  SW, `cor_1, tb_lab3.DUT.state);
      end
      else begin
	 $display("PASS,  Reset success");
      end
      rst = 1'b0;
      
      // test HEX0 for displaying digits
      repeat(10) begin
	 // assign an expected value for the checker
	 case (SW)
	   0: expectedHEX = `dis_0;
	   1: expectedHEX = `dis_1;
	   2: expectedHEX = `dis_2;
	   3: expectedHEX = `dis_3;
	   4: expectedHEX = `dis_4;
	   5: expectedHEX = `dis_5;
	   6: expectedHEX = `dis_6;
	   7: expectedHEX = `dis_7;
	   8: expectedHEX = `dis_8;
	   9: expectedHEX = `dis_9;
	   default: expectedHEX = 42'bx;
	 endcase // case (SW)
	 #4;
	 
	 // run checker to display errors and modify error flag
	 HEX_checker(expectedHEX);
	 
	 //increment to next "valid" digit check
	 SW += 9'b1;
      end // repeat (10)
      
      // test HEX0 for displaying ErrOr using a random "invalid" digit
      SW = 10;
      #2;
      
      // if not showing ErrOr, then print an error
      if(tb_lab3.DUT.displayHEX != `dis_ErrOr) begin
	 $display("ERROR! ErrOr is not printing on the display");
	 err = 1'b1;
      end
      else begin
	 $display("PASS,  ErrOr is printing on the display");
      end
      #2;

      // resetting to ensure a fresh start
      rst = 1'b1;
      #4;
      rst = 1'b0;

      // TEST CASE 1: 722297 (correct input)
      $display("---TEST CASE 1: 722297---");
      test_inputs = {10'd7, 10'd2, 10'd2, 10'd2, 10'd9, 10'd7};
      checkTransition(test_inputs);
      
      // resetting to ensure a fresh start
      rst = 1'b1;
      #4;
      rst = 1'b0;

      // TEST CASE 2: 702297
      $display("---TEST CASE 2: 702297---");
      test_inputs = {10'd7, 10'd0, 10'd2, 10'd2, 10'd9, 10'd7};
      checkTransition(test_inputs);
      
      // resetting to ensure a fresh start
      rst = 1'b1;
      #4;
      rst = 1'b0;

      // TEST CASE 3: 723297      
      $display("---TEST CASE 3: 723297---");
      test_inputs = {10'd7, 10'd2, 10'd3, 10'd2, 10'd9, 10'd7};
      checkTransition(test_inputs);
      
      // resetting to ensure a fresh start
      rst = 1'b1;
      #4;
      rst = 1'b0;

      // TEST CASE 4: 722497
      $display("---TEST CASE 4: 722497---");
      test_inputs = {10'd7, 10'd2, 10'd2, 10'd4, 10'd9, 10'd7};
      checkTransition(test_inputs);
      
      // resetting to ensure a fresh start
      rst = 1'b1;
      #4;
      rst = 1'b0;

      // TEST CASE 5: 722257
      $display("---TEST CASE 5: 722257---");
      test_inputs = {10'd7, 10'd2, 10'd2, 10'd2, 10'd5, 10'd7};
      checkTransition(test_inputs);
      
      // resetting to ensure a fresh start
      rst = 1'b1;
      #4;
      rst = 1'b0;

      
      // TEST CASE 6: 722296
      $display("---TEST CASE 6: 722296---");
      test_inputs = {10'd7, 10'd2, 10'd2, 10'd2, 10'd9, 10'd6};
      checkTransition(test_inputs);
      
      // resetting to ensure a fresh start
      rst = 1'b1;
      #4;
      rst = 1'b0;

      // TEST CASE 7: 012345
      $display("---TEST CASE 7: 012345---");
      test_inputs = {10'd0, 10'd1, 10'd2, 10'd3, 10'd4, 10'd5};
      checkTransition(test_inputs);
      
      if (~err)
	$display("TEST PASSED");
      else
	$display("TEST FAILED: ERROR(S) FOUND");
      $finish;
   end
endmodule: tb_lab3
