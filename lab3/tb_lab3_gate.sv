`timescale 1 ps/ 1 ps

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

module tb_lab3_gate();
   // declare all input/outputs for lab3_top
   reg [9:0]  SW;
   reg	      clk;
   reg	      rst;
   reg	      err;
   reg	      unlock;
   reg [41:0] expectedHEX;
   reg [3:0]  expectedState;
   reg [0:59] test_inputs;
   wire [6:0] HEX0;
   wire [6:0] HEX1;
   wire [6:0] HEX2;
   wire [6:0] HEX3;
   wire [6:0] HEX4;
   wire [6:0] HEX5;
   wire [9:0] LEDR;
   wire [41:0] displayHEX;

   assign displayHEX = {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0};
   
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
	 if (displayHEX != expectedHEX) begin
	    $display("ERROR! HEX0 is not displaying the correct output value");
	    $display("       Current Value: %d, Expected: %b, Actual: %b", 
		     tb_lab3_gate.DUT.SW, expectedHEX[6:0], displayHEX[6:0]);
	    err = 1'b1;
	 end
	 else begin
	    $display("PASS,  displaying %d, %b", SW, displayHEX[6:0]);
	 end
      end
   endtask // HEX_checker

   // a checker to see if the lock is at the correct final state
   task checkFinal;
      input unlock;
      begin 
	 if (unlock) begin
	    if (displayHEX != `dis_OPEn) begin
	       $display("ERROR! OPEn not displayed");
	       err = 1'b1;
	    end
	    else begin
	       $display("PASS,  Displaying OPEn on HEX");
	    end
	 end
	 else begin
	    if (displayHEX != `dis_CLOSED) begin
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
	    expectedState = `T1;
	 end
	 else begin
	    expectedState = `F1;
	 end
	 #2;

	 // put in second digit
	 SW = num_in[10:19];
	 #2;
	 // check against correct answer: 722297
	 if (SW == 10'd2 && expectedState == `T1) begin
	    expectedState = `T2;
	 end
	 else begin
	    expectedState = `F2;
	 end
	 #2;

	 // put in third digit 
	 SW = num_in[20:29];
	 #2;
	 // check against correct answer: 722297
	 if (SW == 10'd2 && expectedState == `T2) begin
	    expectedState = `T3;
	 end
	 else begin
	    expectedState = `F3;
	 end
	 #2;

	 // put in 4th digit
	 SW = num_in[30:39];
	 #2;
	 // check against correct answer: 722297
	 if (SW == 10'd2 && expectedState == `T3) begin
	    expectedState = `T4;
	 end
	 else begin
	    expectedState = `F4;
	 end
	 #2;
	 
	 // put in fifth digit
	 SW = num_in[40:49];
	 #2;
	 // check against correct answer: 722297
	 if (SW == 10'd9 && expectedState == `T4) begin
	    expectedState = `T5;
	 end
	 else begin
	    expectedState = `F5;
	 end
	 #2;

	 // put in 6th digit (last)
	 SW = num_in[50:59];
	 #2;
	 // check against correct answer: 722297
	 if (SW == 10'd7 && expectedState == `T5) begin
	    expectedState = `T6;
	 end
	 else begin
	    expectedState = `F6;
	 end
	 #2;

	 // check if this conbination should unlock
	 if (expectedState == `T6) begin
	    unlock = 1'b1;
	 end
	 else begin
	    unlock = 1'b0;
	 end

	 // check if the lock is actually unlocked
	 checkFinal(unlock);

	 // check if the self loop at the end works
	 #4;
	 checkFinal(unlock);

	 // change an input and see if the self loop still works
	 SW = 10'b0;
	 #4;
	 checkFinal(unlock);
      end
   endtask // checkTransition

   initial begin
      //iverilog and GTKWave use only
      $dumpfile("waveform.vcd");
      $dumpvars(0, tb_lab3_gate);

      // reset error indicator
      err = 1'b0;
      SW = 10'b0;
      
      // reset the lock -- synchronous reset
      rst = 1'b0;
      #4;
      rst = 1'b1;
      #2;
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
      if(displayHEX != `dis_ErrOr) begin
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
endmodule: tb_lab3_gate
