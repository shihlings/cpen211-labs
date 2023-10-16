`timescale 1 ps/ 1 ps

// Buttons go low when pressed
// Reset is synchronous
// Number display should be updated in real time



module tb_lab3();
   //inputs
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
	 if (tb_lab3.dut.hex0 !== exp_hex0) begin
	    $display("Expected hex0 %b, got %b",
		     exp_hex0, tb_lab3.dut.hex0);
	    err = 1;
	 end
	 if (tb_lab3.dut.hex1 !== exp_hex1) begin
	    $display("Expected hex1 %b, got %b",
		     exp_hex1, tb_lab3.dut.hex1);
	    err = 1;
	 end
	 if (tb_lab3.dut.hex2 !== exp_hex2) begin
	    $display("Expected hex2 %b, got %b",
		     exp_hex2, tb_lab3.dut.hex2);
	    err = 1;
	 end
	 if (tb_lab3.dut.hex3 !== exp_hex3) begin
	    $display("Expected hex3 %b, got %b",
		     exp_hex3, tb_lab3.dut.hex3);
	    err = 1;
	 end
	 if (tb_lab3.dut.hex4 !== exp_hex4) begin
	    $display("Expected hex4 %b, got %b",
		     exp_hex4, tb_lab3.dut.hex4);
	    err = 1;
	 end
	 if (tb_lab3.dut.hex5 !== exp_hex5) begin
	    $display("Expected hex5 %b, got %b",
		     exp_hex5, tb_lab3.dut.hex5);
	    err = 1;
	 end
	 

endmodule: tb_lab3
