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

// Gate level simulation use
`timescale 1 ps/ 1 ps

module tb_lab3();
   // declaration for all input/outputs for lab3_top
   reg [9:0] SW;
   reg	     clk;
   reg	     rst;
   reg	     err;
   reg	     unlock;
   reg [6:0] expectedHEX0;
   reg [3:0] expectedState;
   reg [9:0] LEDR;
   
   wire [6:0] HEX0;
   wire [6:0] HEX1;
   wire [6:0] HEX2;
   wire [6:0] HEX3;
   wire [6:0] HEX4;
   wire [6:0] HEX5;

   // declare a DUT with the corresponding i/o
   // For KEY[2:1], they are always 1 as they're not used (buttons are 1 when not preseed)
   lab3_top DUT(.SW(SW), .KEY({rst, 2'b1, ~clk}), .LEDR(LEDR), .HEX0(HEX0), .HEX1(HEX1), 
		.HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));

   // initialize a clock, period = 2 ps, 
   initial begin
     forever begin
	clk = 1'b0; #1;
        clk = 1'b1; #1;
	clk = 1'b0;
     end
   end

   // a checker to see if the HEX0 value matches the expected value
   task HEX0_checker;
      input [6:0] expectedHEX0;
      begin
	 if (tb_lab3.DUT.HEX0 != expectedHEX0) begin
	    $display("ERROR! HEX0 is not displaying the correct output value");
	    $display("       Current Value: %d, Expected: %b, Actual: %b", tb_lab3.DUT.SW, expectedHEX0, tb_lab3.DUT.HEX0);
	    err = 1'b1;
	 end
      end
   endtask // HEX0_checker

   // a checker to see if the state transition is expected
   task testState;
      input [3:0] expectedState;
      begin
	 if (tb_lab3.DUT.currentState != expectedState) begin
	    $display("ERROR! Unexpected state transition");
	    $display("       Current Value: %d, Expected: %b, Actual: %b", tb_lab3.DUT.SW, expectedState, tb_lab3.DUT.currentState);
	    err = 1'b1;
	 end
      end
   endtask // checkState

   // a checker to see if the lock is at the correct final state
   task checkFinal;
      input unlock;
      begin
	 if (unlock) begin
	    if (HEX5 != `OFF | HEX4 != `OFF) begin
	       $display("ERROR! Unused display not turned off");
	       err = 1'b1;
	    end
	    if (HEX3 != `segO | HEX2 != `segP | HEX1 != `segE | HEX0 != `segn) begin
	       $display("ERROR! OPEn not displayed");
	       err = 1'b1;
	    end
	 end
	 else begin
	    if (HEX5 != `segC | HEX4 != `segL | HEX3 != `segO | HEX2 != `segS | HEX1 != `segE | HEX0 != `segD) begin
	       $display("ERROR! CLOSED not displayed");
	       err = 1'b1;
	    end
	 end // else: !if(unlock)
      end
   endtask // checkFinal


   //start running testbench tasks
   initial begin
      //iverilog and GTKWave use only
      $dumpfile("waveform.vcd");
      $dumpvars(0, tb_lab3);
            
      // reset error indicator
      err = 1'b0;
      SW = 10'b0;
            
      // reset the lock -- synchronous reset
      rst = 1'b1;
      #2;
      rst = 1'b0;
      #2;
      rst = 1'b1;
      
      // test HEX0 for displaying digits
      repeat(10) begin
	 // assign an expected value for the checker
	 case (SW)
	   0: expectedHEX0 = `seg0;
	   1: expectedHEX0 = `seg1;
	   2: expectedHEX0 = `seg2;
	   3: expectedHEX0 = `seg3;
	   4: expectedHEX0 = `seg4;
	   5: expectedHEX0 = `seg5;
	   6: expectedHEX0 = `seg6;
	   7: expectedHEX0 = `seg7;
	   8: expectedHEX0 = `seg8;
	   9: expectedHEX0 = `seg9;
	   default: expectedHEX0 = 7'bx;
	 endcase // case (SW)
	 #1;
	 
	 // run checker to display errors and modify error flag
	 HEX0_checker(expectedHEX0);

	 //increment to next "valid" digit check
	 SW += 9'b1;
	 #1;
      end // repeat (10)

      // test HEX0 for displaying ErrOr using a random "invalid" digit
      SW = 11;
      #1;

      // if not showing ErrOr, then print an error
      if(HEX5 != `OFF | HEX4 != `segE | HEX3 != `segr | HEX2 != `segr | HEX1 != `segO | HEX0 != `segr) begin
	 $display("ERROR! ErrOr is not printing on the display");
	 err = 1'b1;
      end
      #1;

      rst = 1'b0;
      #2;
      rst = 1'b1;
            
      // test entering the correct set of student number (722297)
      unlock = 1'b1; //setting to true for a expected unlock test case
      SW = 7;
      expectedState = `T1;
      #1;
      testState(expectedState);
      #1;
      
      SW = 2;
      expectedState = `T2;
      #1;
      testState(expectedState);
      #1;
      
      SW = 2;
      expectedState = `T3;
      #1;
      testState(expectedState);
      #1;
      
      SW = 2;
      expectedState = `T4;
      #1;
      testState(expectedState);
      #1;
      
      SW = 9;
      expectedState = `T5;
      #1;
      testState(expectedState);
      #1;
      
      SW = 7;
      expectedState = `T6;
      #1;
      testState(expectedState);
      #1;

      checkFinal(unlock);
                  
      if (~err)
	$display("PASSED");
      else
	$display("ERROR FOUND");
      $stop;
   end
endmodule: tb_lab3
